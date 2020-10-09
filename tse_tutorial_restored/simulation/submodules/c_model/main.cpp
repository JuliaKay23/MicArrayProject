#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

using namespace std;

#include "CIC.h"

#define N_CHARS 80 /* per line */
#define SIZEOF_INT64 64
#define VER "3.1"

typedef enum {
    FULL_RESOLUTION,
    TRUNCATION,
    CONVERGENT_ROUNDING,
    ROUNDING_UP,
    SATURATION
} out_round_opt_t;

static void exit_failure(const char* msg)
{
    printf("\n");
    printf("Error: %s\n", msg);
    printf("\n");
    exit(EXIT_FAILURE);
}

static void exit_failure_verbose(const char* msg)
{
    printf("\n");
    printf("Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

int main(int argc, char** argv)
{
    if (argc < 13) {
        exit_failure_verbose("Missing arguments.\nUsage: ./cic filter_type{i,d} N M R_max R_min is_size cs_size B_in B_out rounding_type{TRUNCATE,CONV_ROUND,ROUND_UP,SATURATE,H_PRUNE} operation{LOAD} input_file output_file");
    }

    string filter_type;
    if (strcmp(argv[1], "d") == 0) {
        filter_type = "Decimator";
        printf("\n");
        printf("DECIMATOR");
    } else if (strcmp(argv[1], "i") == 0) {
        filter_type = "Interpolator";
        printf("\n");
        printf("INTERPOLATOR");
    } else {
        exit_failure_verbose("<filter> is invalid.");
    }

    int N = atoi(argv[2]);
    int M = atoi(argv[3]);
    int R_Max = atoi(argv[4]);
    int R_Min = atoi(argv[5]);
    int is_size = atoi(argv[6]);
    int cs_size = atoi(argv[7]);
    int B_in = atoi(argv[8]);
    int B_out = atoi(argv[9]);
    string ROUNDING_TYPE = argv[10];
    if (N <= 0) {
        exit_failure("N must be greater than 0.");
    }
    if (M <= 0) {
        exit_failure("M must be greater than 0.");
    }
    if (R_Min <= 1) {
        exit_failure("R_Min must be greater than 1.");
    }
    if (R_Max <= 1) {
        exit_failure("R_Max must be greater than 1.");
    }
    if (is_size <= 0) {
        exit_failure("i must be greater than 0.");
    }
    if (is_size > R_Min) {
        exit_failure("i must not be greater than R.");
    }
    if (cs_size <= 0) {
        exit_failure("c must be greater than 0.");
    }
    if (B_in <= 0) {
        exit_failure("B_in must be greater than 0.");
    }
    if (B_out <= 0) {
        exit_failure("B_out must be greater than 0.");
    }

    int B_max1;
    if (filter_type == "Decimator") {
        B_max1 = B_max(N, M, R_Max, B_in) + 1;
    } else {
        B_max1 = static_cast<int>(ceil(B_in + log(pow(R_Max * M, N) / R_Max) / log(2)));
    }
    if (B_out > B_max1) {
        printf("Warning: B_out is greater than theoretical maximum for this rate, this is only valid for variable rate tests");
        B_out = B_max1;
    }
    if (ROUNDING_TYPE == "NONE") {
        B_out = B_max1;
    }
    if (B_max1 > SIZEOF_INT64) {
        char msg[N_CHARS + 1];
        sprintf(msg, "B_max (%d) is too big (> %d) to be supported by this simulation.", B_max1, SIZEOF_INT64);
        exit_failure(msg);
    }

    int h_prune = 0;

    if (filter_type == "Decimator") {
        if (ROUNDING_TYPE == "H_PRUNE") {
            h_prune = 1;
            ROUNDING_TYPE = "TRUNCATION";
        }
    }
    printf(" N=%d Differential Delay=%d Max rate=%d Min rate=%d Interfaces=%d Channels=%d B_in=%d B_out=%d, Rounding=%s \n", N, M, R_Max, R_Min, is_size, cs_size, B_in, B_out, ROUNDING_TYPE.c_str());

    string operation = argv[11];
    if (operation == "LOAD") {
        string input_file_string = argv[12];
        string output_file_string = argv[13];
        const char* input_file = input_file_string.c_str();
        const char* output_file = output_file_string.c_str();
        CIC_data CIC_0;
        printf("Loading data from %s:  \n", input_file);
        CIC_0.load_data(filter_type, B_in, B_out, R_Max, R_Min, cs_size, is_size, input_file);
        printf("Done \n");
        printf("Executing CIC: \n");
        CIC_0.execute_CIC(filter_type, is_size, N, M, ROUNDING_TYPE, B_in, B_out, h_prune);
        printf("Done \n");
        printf("Storing data to %s:  \n", output_file);
        CIC_0.store_data(output_file, B_out);
        printf("Done \n");
    } else {
        exit_failure("Only Loaded data is currently supported");
    }

    return 0;
}