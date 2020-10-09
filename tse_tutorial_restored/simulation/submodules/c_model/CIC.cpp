#include "CIC.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sstream>
#include <iostream>
#include <vector>
#include <fstream>

#ifdef MEX_COMPILE
#include "mex.h"
#endif

using namespace std;

void CIC_data_single_channel::print_vector(void)
{
    int i;
    for (i = 0; i < 10; i++) {
        //    printf("%ld\n",data[i]);
    }
}

int CIC_data_single_channel::get_sample_length(void)
{
    return static_cast<int>(data.size());
}

//Hogenauer Pruning
double CIC_data_single_channel::binomial_coefficient(int n, int k)
{
    assert(n >= k);
    int i;
    k = k <= n / 2 ? k : n - k;
    double b = 1; /* greater range than int64, less precision */
    for (i = 0; i < k; i++) {
        b *= n--;
    }
    for (i = 2; i <= k; i++) {
        b /= i;
    }
    return b;
}

double CIC_data_single_channel::F_j(int j, int N, int M, int R)
{
    int k, k_max = j <= N ? (R * M - 1) * N + j - 1 : 2 * N + 1 - j;
    double h, F2 = 0; /* greater range than int64, less precision */
    for (k = 0; k <= k_max; k++) {
        h = h_j(j, k, N, M, R);
        F2 += h * h;
    }
    return sqrt(F2);
}

double CIC_data_single_channel::h_j(int j, int k, int N, int M, int R)
{
    if (j <= N) {
        int l, l_max = k / (R * M);
        double h = 0; /* greater range than int64, less precision */
        for (l = 0; l <= l_max; l++) {
            h += (l % 2 == 0 ? 1 : -1) * binomial_coefficient(N, l) * binomial_coefficient(N - j + k - R * M * l, k - R * M * l);
        }
        return h;
    }
    return (k % 2 == 0 ? 1 : -1) * binomial_coefficient(2 * N + 1 - j, k);
}

int CIC_data_single_channel::B_max(int N, int M, int R, int B_in)
{
    return static_cast<int>(ceil(N * log(R * M) / log(2) + B_in - 1));
}

int CIC_data_single_channel::hogenauer_calc(int j, int N, int M, int R, int B_in, int B_out)
{
    double log2 = log(2);
    double a = -log(F_j(j, N, M, R));
    double b = -.5 * log(3) + (B_max(N, M, R, B_in) - B_out) * log2; /* -log2-.5*log(3)+(B_max(N, M, R, B_in)-B_out+1)*log2 */
    double c = .5 * log((double)6 / N);
    int B = static_cast<int>(floor((a + b + c) / log2 + 0.000000001)); /* to avoid floating-point error */
    return B >= 0 ? B : 0;
}

vector<int> CIC_data_single_channel::h_prune(int N_stages, int D_Delay, int rate, int B_in, int B_out)
{
    vector <int> result;
    int j;
    int B_max1 = B_max(N_stages, D_Delay, rate, B_in) + 1;

    for (j = 1; j <= 2 * N_stages; j++) {
        result.push_back(hogenauer_calc(j, N_stages, D_Delay, rate, B_in, B_out));
    }
    result.push_back(B_max1 - B_out);
    for (j = static_cast<int>(result.size()) - 1; j > 0; j--) {
        result[j] = result[j] - result[j - 1];
    }

    return result;
}

// Rounding

void CIC_data_single_channel::convergent_round(int bit_width)
{
    vector <int64_t> result;
    result.resize(data.size());
    int64_t value;
    for (std::vector<int64_t>::size_type n = 0; n < data.size(); n++) {
        value = data[n];
        if (bit_width >= 1 && (value & (int64_t)1 << (bit_width - 1)) != 0 && ((value & ~(~(int64_t)0 << (bit_width - 1))) != 0 || (value & (int64_t)1 << bit_width) != 0)) {
            value += (int64_t)1 << bit_width;
        }
        result[n] = value >> bit_width;
    }
    data.clear();
    data = result;
}

void CIC_data_single_channel::round_up(int bit_width)
{
    vector <int64_t> result;
    result.resize(data.size());
    int64_t value;
    for (std::vector<int64_t>::size_type n = 0; n < data.size(); n++) {
        value = data[n];
        if (bit_width >= 1 && (value & (int64_t)1 << (bit_width - 1)) != 0) {
            value += (int64_t)1 << bit_width;
        }
        result[n] = value >> bit_width;
    }
    data.clear();
    data = result;
}

void CIC_data_single_channel::saturate(int bit_width)
{
    vector <int64_t> result;
    result.resize(data.size());

    int64_t value, min = ~(int64_t)0 << (bit_width - 1);
    int64_t max = ~min;
    for (std::vector<int64_t>::size_type n = 0; n < data.size(); n++) {
        value = data[n];
        if (value < min) {
            value = min;
        } else if (value > max) {
            value = max;
        }
        result[n] = value;
    }
    data.clear();
    data = result;
}

void CIC_data_single_channel::truncate(int bit_width)
{
    vector <int64_t> result;
    result.resize(data.size());
    for (std::vector<int64_t>::size_type n = 0; n < data.size(); n++) {
        result[n] = data[n] >> bit_width;
    }
    data.clear();
    data = result;
}

void CIC_data_single_channel::decimate(int N_stages, int D_Delay, int rate, int B_in, int B_out, int h_pruning, int max_rate)
{
    vector <int> pruning_widths;

    if (h_pruning == 1) {
        pruning_widths = h_prune(N_stages, D_Delay, max_rate, B_in, B_out);
    } else {
        pruning_widths.resize(2 * N_stages + 1);
        int j;
        for (j = 0; j <= 2 * N_stages; j++) {
            pruning_widths[j] = 0;
        }
    }

    int i, b;

    print_vector();

    for (i = 0; i <= 2 * N_stages; i++) {
        cout << "\t\t\tPruning width: " << i << " is: " << pruning_widths[i] << endl;
    }
    for (i = 0; i < 2 * N_stages; i++) {
        if (i == N_stages) {
//            printf("delay \n");
            delay(N_stages);
            print_vector();
//            printf("Down \n");
            downsample(rate);
            print_vector();
        }
        b = pruning_widths[i];
        if (b > 0) {
//            printf("Trunc \n");
            truncate(b);
            print_vector();

        }
        if (i < N_stages) {
//            printf("Int \n");
            integrate();
            print_vector();
        } else {
//            printf("Diff \n");
            differentiate(D_Delay);
            print_vector();

        }
    }
//    printf("Finished processing");
    if (h_pruning == 1 ) {
        truncate(pruning_widths[2 * N_stages]);
    }

}

void CIC_data_single_channel::interpolate(int N_stages, int D_Delay, int rate)
{
    int i;
    for (i = 0; i < 2 * N_stages; i++) {
        if (i == N_stages) {
            upsample(rate);
        }
        if (i < N_stages) {
            differentiate(D_Delay);
        } else {
            integrate();
        }
    }
}

void CIC_data_single_channel::delay(int d)
{
    vector <int64_t> result;
    if (d >= static_cast<int>(data.size())) {
        printf("d is larger than the number of samples!");
        cout << "d: " << d << " data.size " << data.size() << endl;
    }
    result.resize(data.size() - d);
    for (std::vector<int64_t>::size_type n = 0; n < data.size() - d; n++) {
        result[n] = data[n + d];
    }
    data.clear();
    data = result;
}


void CIC_data_single_channel::integrate()
{
    vector <int64_t> result;
    result.resize(data.size());
    if (data.size() != 0) {
        result[0] = 0;
    }
    for (std::vector<int64_t>::size_type n = 1; n < data.size(); n++) {
        result[n] = data[n - 1] + result[n - 1];
    }
    data.clear();
    data = result;
}

void CIC_data_single_channel::differentiate(int D_Delay)
{
    vector <int64_t> result;
    result.resize(data.size());
    std::vector<int64_t>::size_type n;
    for (n = 0; n < data.size() && n < static_cast<uint64_t>(D_Delay); n++) {
        result[n] = data[n];
    }
    for (n = D_Delay; n < data.size(); n++) {
        result[n] = data[n] - data[n - D_Delay];
    }
    data.clear();
    data = result;
}

void CIC_data_single_channel::downsample(int rate)
{
    vector <int64_t> result;
    for (std::vector<int64_t>::size_type n = 0; n < data.size(); n += rate) {
        result.push_back(data[n]);
    }
    data.clear();
    data = result;
}

void CIC_data_single_channel::upsample(int rate)
{
    vector <int64_t> result;
    for (std::vector<int64_t>::size_type n = 0; n < data.size(); n++) {
        result.push_back(data[n]);
        for (int n1 = 0; n1 < rate - 1; n1++) {
            result.push_back(0);
        }
    }
    data.clear();
    data = result;
}


int64_t CIC_data_single_channel::get_data(int clock_cycle)
{
    if (clock_cycle < static_cast<int>(data.size())) {
        return data[clock_cycle];
    } else {
        return 0;
    }
}

void CIC_data_single_channel::insert_data(int64_t value)
{
    data.push_back(value);
}


void CIC_data_single_channel::execute_CIC(string filter_type, int N_stages, int D_Delay, int rate, string rounding_type, int B_in, int B_out, int h_pruning, int max_rate)
{
    if (filter_type == "Decimator") {
        decimate(N_stages, D_Delay, rate, B_in, B_out, h_pruning, max_rate);
    } else {
        interpolate(N_stages, D_Delay, rate);
    }
    int B_max1;
    if (filter_type == "Decimator") {
        B_max1 = B_max(N_stages, D_Delay, max_rate, B_in) + 1;
    } else {
        B_max1 = static_cast<int>(ceil(B_in + log(pow(max_rate * D_Delay, N_stages) / max_rate) / log(2)));
    }
    int truncate_by = B_max1 - B_out;
    printf("Max Width: %d, Requested Width: %d, Rounding By: %d \n", B_max1, B_out, truncate_by);
    if (h_pruning == 0) { //h pruning implies output already correct width
        if (rounding_type.find("TRUNCATE") != -1) {
            printf("TRUNCATE\n");
            truncate(B_max1 - B_out);
        } else if (rounding_type.find("CONV_ROUND") != -1) {
            printf("CONV_ROUND\n");
            convergent_round(B_max1 - B_out);
        } else if (rounding_type.find("ROUND_UP") != -1) {
            printf("ROUND_UP\n");
            round_up(B_max1 - B_out);
        } else if (rounding_type.find("SATURATE") != -1) {
            printf("Saturating\n");
            saturate(B_out);
        } else {
            printf("No rounding occurred \n");
        }

    }
    print_vector();
}

int CIC_data_single_interface::get_sample_length(void)
{
    return channel_vec[0].get_sample_length() * static_cast<int>(channel_vec.size());
}

CIC_data_single_interface::CIC_data_single_interface(int channels)
{
    channel_count = channels;
    channel_vec.resize(channels);
    write_channel_index = 0;
}

int64_t CIC_data_single_interface::get_data(int clock_cycle)
{
    return channel_vec[clock_cycle % channel_count].get_data((int)floor(clock_cycle / channel_count));
}

void CIC_data_single_interface::append_data(int64_t value)
{
    channel_vec[write_channel_index].insert_data(value);
    write_channel_index = (write_channel_index + 1) % channel_count;


}

int CIC_data_single_interface::get_channels(void)
{
    return channel_count;
}

void CIC_data_single_interface::execute_CIC(string filter_type, int N_stages, int D_Delay, int rate, string  rounding_type, int B_in, int B_out, int h_pruning, int max_rate)
{
    for (std::vector<CIC_data_single_channel>::iterator j = channel_vec.begin() ; j != channel_vec.end(); ++j) {
        j->execute_CIC(filter_type, N_stages, D_Delay, rate, rounding_type, B_in, B_out, h_pruning, max_rate);
    }

}

CIC_data_single_rate::CIC_data_single_rate(int interfaces, int channels, int rate_change)
{
    CIC_data_single_interface new_interface(channels);
    rate = rate_change;
    int i;
    for (i = 0; i < interfaces; i++) {
        CIC_data_single_interface new_interface(channels);
        interface.push_back(new_interface);
    }
}

vector <int64_t>  CIC_data_single_rate::get_data(int clock_cycle)
{
    vector <int64_t> cycle_data;
    for (std::vector<CIC_data_single_interface>::iterator j = interface.begin() ; j != interface.end(); ++j) {
        cycle_data.push_back(j->get_data(clock_cycle));
    }
    return cycle_data;
}

void CIC_data_single_rate::insert_data(vector <int64_t> values)
{
    for (std::vector<int64_t>::size_type i = 0; i < interface.size(); i++) {
        interface[i].append_data(values[i]);
    }
}

int CIC_data_single_rate::sample_length(void)
{
    return interface[0].get_sample_length();
}

void CIC_data_single_rate::combine_interfaces()
{
    int i;
    int new_channel_count  = static_cast<int>(interface.size()) * interface[0].get_channels();
    int new_interface_count = 1;
    cout << "old Ch: " << interface[0].get_channels() << endl;
    cout << "old int: " << interface.size() << endl;
    cout << "new Ch: " << new_channel_count << endl;
    cout << "new int: " << new_interface_count << endl;

    CIC_data_single_interface new_interface(new_channel_count);
    for (i = 0; i < sample_length(); i++) {
        for (std::vector<CIC_data_single_interface>::iterator j = interface.begin() ; j != interface.end(); ++j) {
            new_interface.append_data(j->get_data(i));
        }
    }
    interface.clear();
    interface.push_back(new_interface);
}

void CIC_data_single_rate::separate_interfaces(int interfaces)
{
    int i;
    int old_interface_count = static_cast<int>(interface.size());
    int new_channel_count  = interface[0].get_channels() / interfaces;
    int new_interface_count = interfaces;
    int new_sample_length = sample_length() / interfaces;
    vector <CIC_data_single_interface> new_interface_vec;
    for (i = 0; i < new_interface_count; i++) {
        CIC_data_single_interface new_interface(new_channel_count);
        new_interface_vec.push_back(new_interface);
    }
    int interface_index = 0;
    for (i = 0; i < sample_length(); i++) {
        for (std::vector<CIC_data_single_interface>::iterator j = interface.begin() ; j != interface.end(); ++j) {
            new_interface_vec[interface_index].append_data(j->get_data(i));
            interface_index = (interface_index + 1) % new_interface_count;
        }

    }
    interface.clear();
    interface = new_interface_vec;
}

void CIC_data_single_rate::execute_CIC(string filter_type, int interfaces, int N_stages, int D_Delay, string  rounding_type, int B_in, int B_out, int h_pruning, int _max_rate)
{
    for (std::vector<CIC_data_single_interface>::iterator j = interface.begin() ; j != interface.end(); ++j) {
        j->execute_CIC(filter_type, N_stages, D_Delay, static_cast<int>(rate), rounding_type, B_in, B_out, h_pruning, _max_rate);
    }
    if (filter_type == "Interpolator") {
        separate_interfaces(interfaces);
    }
    if (filter_type == "Decimator") {
        combine_interfaces();
    }
}

void CIC_data::load_data(string filter_type, int B_in, int B_out, int max_rate, int min_rate, int channels, int interfaces, const char* input_file)
{
    ifstream CIC_file;
    _max_rate = max_rate;
    int interfaces_in;
    int channels_in;
    if (filter_type == "Interpolator") {
        interfaces_in = 1;
        channels_in = channels * interfaces;
    } else {
        interfaces_in = interfaces;
        channels_in = channels;
    }

    CIC_file.open(input_file);
    if (!CIC_file.is_open()) {
        printf("Couldn't open input file");
    }
    int previous_rate = max_rate + 1;
    int reset_start = 1;
    int line_number = 0;
    int rate_count = 1;
    int current_rate = -1;
    while (CIC_file.good()) {
        line_number++;
        int i;
        const int LINE_LENGTH = interfaces * 500;
        std::vector<char> line(LINE_LENGTH);
        CIC_file.getline(line.data(), LINE_LENGTH, '\n');
        char* temp_val = NULL;
        temp_val = strtok(line.data(), ",\n");
        if (temp_val == NULL) {
            printf("611: Short line detected on line %d, assuming end of file \n", line_number);
            break;
        }
        string read_value(temp_val);
        string reset_string("reset");
        if (read_value.find(reset_string) != -1) {
            reset_start = 1;
            rate_count++;
            printf("Rate found \n");
        } else {
            if (strlen(line.data()) < 1) {
                printf("622: Short line detected on line %d, assuming end of file (line length %d, interfaces %d)\n", line_number, strlen(line.data()), interfaces_in);
                break;
            }
            vector <int64_t> current_vec;
            for (i = 0; i < interfaces_in; i++) {
                int64_t input_value = strtoull(temp_val, NULL, 10);
                //do the checking of values here;
                current_vec.push_back(input_value);
                temp_val = strtok(NULL, ",\n");
                if (temp_val == NULL) {
                    printf("FAIL: Invalid value detected in input file (too few interfaces)- check format on line %d \n", line_number);
                    exit(1);
                }

            }
            int new_rate = atoi(temp_val);
            if (reset_start == 0 && new_rate != current_rate) {
                reset_start = 1;
                rate_count++;
                printf("Rate found \n");
            }
            current_rate = new_rate;

            if (strtok(NULL, ",\n") != NULL) {
                printf("FAIL: Invalid value detected in input file (too many interfaces)- check format on line %d \n", line_number);
                exit(1);
            }
            if (reset_start == 1) {
                CIC_data_single_rate new_rate (interfaces_in, channels_in, current_rate);
                rate.push_back(new_rate);
                reset_start = 0;
            }
            rate.back().insert_data(current_vec);
        }
        // if(CIC_file.eof()) {
        //     printf("Finished the file after %d lines", line_number);
        // }
        // if(CIC_file.bad()) {
        //     printf("Finished the file after bad bit");
        // }
    }
    CIC_file.close();
    printf("%d rates detected in file\n", rate_count);
}

void CIC_data::store_data(const char* output_file, int B_out)
{
    FILE* CIC_file;
    CIC_file = fopen(output_file, "w");
    for (std::vector<CIC_data_single_rate>::iterator it = rate.begin() ; it != rate.end(); ++it) {
        if (it != rate.begin()) {
            fprintf(CIC_file, "Rate Change\n");
        }
        int i;
        for (i = 0; i < it->sample_length(); i++) {
            vector <int64_t> cycle;
            cycle = it->get_data(i);
            for (std::vector<int64_t>::iterator j = cycle.begin() ; j != cycle.end(); ++j) {
                // We need to effectively allow overflows of the right bit width
                int64_t value = *j;
                if (value > int64_t(0)) {
                    value = value % int64_t(pow(2, B_out));
                    if (value >= int64_t(pow(2, B_out - 1))) {
                        value = value - int64_t(pow(2, B_out));
                    }
                } else {
                    value = value % int64_t(pow(2, B_out));
                    if (value >= int64_t(pow(2, B_out - 1))) {
                        value = value - int64_t(pow(2, B_out));
                    }
                }
                if (cycle.end() - 1 != j) {
                    if (B_out <= 32) {
                        fprintf(CIC_file, "%d,", value);
                    } else {
                        int b;
                        for (b = B_out - 1; b >= 0; b--) {
                            fprintf(CIC_file, "%d", (value & (int64_t)1 << b) == 0 ? 0 : 1);
                        }
                        fprintf(CIC_file, ",");
                    }
                } else {
                    if (B_out <= 32) {
                        fprintf(CIC_file, "%d\n", value);
                    } else {
                        int b;
                        for (b = B_out - 1; b >= 0; b--) {
                            fprintf(CIC_file, "%d", (value & (int64_t)1 << b) == 0 ? 0 : 1);
                        }
                        fprintf(CIC_file, "\n");
                    }
                }
            }
        }

    }
    fclose(CIC_file);
}

#ifdef MEX_COMPILE
void CIC_data::load_data(std::string filter_type, int B_in, int B_out, int max_rate, int min_rate, int channels, int interfaces, const mxArray* cell)
{
    _max_rate = max_rate;
    int interfaces_in;
    int channels_in;
    if (filter_type == "Interpolator") {
        interfaces_in = 1;
        channels_in = channels * interfaces;
    }
    else {
        interfaces_in = interfaces;
        channels_in = channels;
    }

    int previous_rate = max_rate + 1;
    int reset_start = 1;
    int line_number = 0;
    int rate_count = 1;
    int current_rate = -1;
    int numLines = static_cast<int>(mxGetNumberOfElements(cell));
    for (int i = 0; i < numLines; ++i) {
        const mxArray* arr = mxGetCell(cell, i);
        double* in_array = mxGetPr(arr);
        int cols = static_cast<int>(mxGetN(arr));
        int rows = static_cast<int>(mxGetM(arr));

        if (rows == 0 && cols == 0) {
            // empty matrix counts as a reset
            reset_start = 1;
            rate_count++;
            mexPrintf("Rate found \n");
            continue;
        }

        if (cols != (interfaces_in + 1)) {
            mexErrMsgIdAndTxt("Altera:CIC:Arguments", "Incorrect number of columns in input matrix for number of interfaces (got %i expected %i)", cols, interfaces_in + 1);
        }

        for (int r = 0; r < rows; ++r) {
            vector <int64_t> current_vec;
            for (i = 0; i < interfaces_in; i++) {
                current_vec.push_back((int64_t)in_array[i * rows + r]);
            }

            int new_rate = (int)in_array[interfaces_in * rows + r];
            if (reset_start == 0 && new_rate != current_rate) {
                reset_start = 1;
                rate_count++;
                mexPrintf("Rate found \n");
            }
            current_rate = new_rate;

            if (reset_start == 1) {
                CIC_data_single_rate new_rate(interfaces_in, channels_in, current_rate);
                rate.push_back(new_rate);
                reset_start = 0;
            }
            rate.back().insert_data(current_vec);
        }
    }
    mexPrintf("%d rates detected in file\n", rate_count);
}

void CIC_data::store_data(mxArray* plhs[], int index, int B_out)
{
    int cell = 0;
    plhs[index] = mxCreateCellMatrix(1, rate.size());
    for (std::vector<CIC_data_single_rate>::iterator it = rate.begin(); it != rate.end(); ++it) {
        int sample_length = it->sample_length();
        mxArray* arr = mxCreateNumericMatrix(sample_length, it->get_data(0).size(), mxINT64_CLASS, mxREAL);
        int64_t* data = (int64_t*)mxGetData(arr);
        for (int i = 0; i < sample_length; i++) {
            vector<int64_t> cycle = it->get_data(i);
            int j = 0;
            for (std::vector<int64_t>::iterator jt = cycle.begin(); jt != cycle.end(); ++jt) {
                // We need to effectively allow overflows of the right bit width
                int64_t value = *jt;
                if (value > int64_t(0)) {
                    value = value % int64_t(pow(2, B_out));
                    if (value >= int64_t(pow(2, B_out - 1))) {
                        value = value - int64_t(pow(2, B_out));
                    }
                }
                else {
                    value = value % int64_t(pow(2, B_out));
                    if (value >= int64_t(pow(2, B_out - 1))) {
                        value = value - int64_t(pow(2, B_out));
                    }
                }
                data[j * sample_length + i] = value;
                ++j;
            }
        }
        mxSetCell(plhs[index], cell++, arr);
    }
}
#endif

void CIC_data::execute_CIC(string filter_type, int interfaces, int N_stages, int D_Delay, string  rounding_type, int B_in, int B_out, int h_pruning)
{
    for (std::vector<CIC_data_single_rate>::iterator it = rate.begin() ; it != rate.end(); ++it) {
        it->execute_CIC(filter_type, interfaces, N_stages,  D_Delay,  rounding_type, B_in, B_out, h_pruning, _max_rate);
    }
}