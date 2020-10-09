#pragma once

#include <stdint.h>
#include <vector>
#include <string>
#include <math.h>

#ifdef MEX_COMPILE
#include "mex.h"
#endif

inline int B_max(int N, int M, int R, int B_in)
{
    return static_cast<int>(ceil(N * log(R * M) / log(2) + B_in - 1));
}

class CIC_data_single_channel
{
public:
    int64_t         get_data(int clock_cycle);
    void            insert_data(int64_t value);
    int64_t         generate_data(int B_in, const char* method);
    void            execute_CIC(std::string filter_type, int N_stages, int D_Delay, int rate, std::string rounding_type, int B_in, int B_out, int h_pruning, int max_rate);
    int             get_sample_length(void);

private:
    void            round(int rounding_type);
    void            truncate(int bit_width);
    void            saturate(int bit_width);
    void            round_up(int bit_width);
    void            convergent_round(int bit_width);
// directly copied from hogenauer.c
    double          binomial_coefficient(int n, int k);
    double          h_j(int j, int k, int N, int M, int R);
    double          F_j(int j, int N, int M, int R);
    int             B_max(int N, int M, int R, int B_in);

//--
    void            print_vector(void);
    int             hogenauer_calc(int stage, int N_stages, int D_Delay, int rate, int B_in, int B_out);
    std::vector <int> h_prune(int N_stages, int D_Delay, int rate, int B_in, int B_out);

    void            decimate(int N_stages, int D_Delay, int rate, int B_in, int B_out, int h_pruning, int max_rate);
    void            interpolate(int N_stages, int D_Delay, int rate);

    void            delay(int delay);

    void            integrate();
    void            differentiate(int D_Delay);

    void            downsample(int rate);
    void            upsample(int rate);

    std::vector <int64_t> data;
};

class CIC_data_single_interface
{
public:
    CIC_data_single_interface(int channels);
    void    append_data(int64_t value);
    void    execute_CIC(std::string filter_type, int N_stages, int D_Delay, int rate, std::string rounding_type, int B_in, int B_out, int h_pruning, int max_rate);
    int     get_channels(void);
    int64_t get_data(int clock_cycle);
    int     get_sample_length(void);

private:
    std::vector <CIC_data_single_channel> channel_vec;
    int     channel_count;
    int     write_channel_index;
};

class CIC_data_single_rate
{
public:
    CIC_data_single_rate(int interfaces, int channels, int rate_change);

    int                   get_channels(void);
    void                  insert_data(std::vector <int64_t> values);
    void                  execute_CIC(std::string filter_type, int interfaces, int N_stages, int D_Delay, std::string rounding_type, int B_in, int B_out, int h_pruning, int max_rate);
    std::vector<int64_t>  get_data(int clock_cycle);
    void                  reset_read();
    int                   sample_length(void);

private:
    void                  combine_interfaces(void);
    void                  separate_interfaces(int interfaces);

    std::vector < CIC_data_single_interface > interface;
    int64_t   rate;
};

class CIC_data
{
public:
    void        load_data(std::string filter_type, int B_in, int B_out, int max_rate, int min_rate, int channels, int interfaces, const char* input_file);
    void        store_data(const char* output_file, int B_out);

#ifdef MEX_COMPILE
    void        store_data(mxArray* plhs[], int index, int B_out);
    void        load_data(std::string filter_type, int B_in, int B_out, int max_rate, int min_rate, int channels, int interfaces, const mxArray* matrix);
#endif

    void        generate_data(int B_in, int B_out, int interfaces, int channels, int rate_max, int rate_min);
    void        execute_CIC(std::string filter_type, int interfaces, int N_stages, int D_Delay, std::string  rounding_type, int B_in, int B_out, int h_pruning);

private:
    std::vector < CIC_data_single_rate > rate;
    int64_t     _B_in;
    int64_t     _B_out;
    int         _max_rate;
};
