#include <string>
#include <stdint.h>

#include "CIC.h"

#ifdef MEX_COMPILE
#include "mex.h"
#endif

#ifdef MEX_COMPILE
inline std::string getString(int index, const mxArray* prhs[])
{
    char* str = (char*)mxCalloc(mxGetN(prhs[index]) + 1, sizeof(char));
    mxGetString(prhs[index], str, mxGetN(prhs[index]) + 1);
    std::string result = std::string(str);
    mxFree(str);
    return result;
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    if (nrhs < 13) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "Missing arguments.\nUsage: cic(filter_type{'i','d'}, N, M, R_max, R_min, is_size, cs_size, B_in, B_out, rounding_type{'TRUNCATE','CONV_ROUND','ROUND_UP','SATURATE','H_PRUNE'}, operation{'LOAD'}, input_file, output_file)");
    }

    std::string filter_type = getString(0, prhs);
    if (filter_type == "d") {
        filter_type = "Decimator";
        mexPrintf("\n");
        mexPrintf("DECIMATOR");
    }
    else if (filter_type == "i") {
        filter_type = "Interpolator";
        mexPrintf("\n");
        mexPrintf("INTERPOLATOR");
    }
    else {
        mexErrMsgIdAndTxt("Altera:CIC:InputString", "<filter> is invalid.");
    }

    int N = (int)*mxGetPr(prhs[1]);
    int M = (int)*mxGetPr(prhs[2]);
    int R_Max = (int)*mxGetPr(prhs[3]);
    int R_Min = (int)*mxGetPr(prhs[4]);
    int is_size = (int)*mxGetPr(prhs[5]);
    int cs_size = (int)*mxGetPr(prhs[6]);
    int B_in = (int)*mxGetPr(prhs[7]);
    int B_out = (int)*mxGetPr(prhs[8]);

    std::string ROUNDING_TYPE = getString(9, prhs);

    if (N <= 0) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "N must be greater than 0.");
    }
    if (M <= 0) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "M must be greater than 0.");
    }
    if (R_Min <= 1) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "R_Min must be greater than 1.");
    }
    if (R_Max <= 1) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "R_Max must be greater than 1.");
    }
    if (is_size <= 0) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "i must be greater than 0.");
    }
    if (is_size > R_Min) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "i must not be greater than R.");
    }
    if (cs_size <= 0) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "c must be greater than 0.");
    }
    if (B_in <= 0) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "B_in must be greater than 0.");
    }
    if (B_out <= 0) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "B_out must be greater than 0.");
    }

    int B_max1;
    if (filter_type == "Decimator") {
        B_max1 = B_max(N, M, R_Max, B_in) + 1;
    }
    else {
        B_max1 = static_cast<int>(ceil(B_in + log(pow(R_Max * M, N) / R_Max) / log(2)));
    }
    if (B_out > B_max1) {
        mexPrintf("Warning: B_out is greater than theoretical maximum for this rate, this is only valid for variable rate tests");
        B_out = B_max1;
    }
    if (ROUNDING_TYPE == "NONE") {
        B_out = B_max1;
    }
    if (B_max1 > 64) {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "B_max (%d) is too big (> %d) to be supported by this simulation.", B_max1, 64);
    }

    int h_prune = 0;
    if (filter_type == "Decimator") {
        if (ROUNDING_TYPE == "H_PRUNE") {
            h_prune = 1;
            ROUNDING_TYPE = "TRUNCATION";
        }
    }
    mexPrintf(" N=%d Differential Delay=%d Max rate=%d Min rate=%d Interfaces=%d Channels=%d B_in=%d B_out=%d, Rounding=%s \n", N, M, R_Max, R_Min, is_size, cs_size, B_in, B_out, ROUNDING_TYPE.c_str());

    std::string operation = getString(10, prhs);
    if (operation == "LOAD") {
        std::string input_file_string = getString(11, prhs);
        std::string output_file_string = getString(12, prhs);
        const char* input_file = input_file_string.c_str();
        const char* output_file = output_file_string.c_str();
        CIC_data CIC_0;
        mexPrintf("Loading data from %s:  \n", input_file);
        CIC_0.load_data(filter_type, B_in, B_out, R_Max, R_Min, cs_size, is_size, input_file);
        mexPrintf("Done \n");
        mexPrintf("Executing CIC: \n");
        CIC_0.execute_CIC(filter_type, is_size, N, M, ROUNDING_TYPE, B_in, B_out, h_prune);
        mexPrintf("Done \n");
        mexPrintf("Storing data to %s:  \n", output_file);
        CIC_0.store_data(output_file, B_out);
        mexPrintf("Done \n");
    }
    else {
        mexErrMsgIdAndTxt("Altera:CIC:InputArgs", "Only Loaded data is currently supported");
    }
}
#endif