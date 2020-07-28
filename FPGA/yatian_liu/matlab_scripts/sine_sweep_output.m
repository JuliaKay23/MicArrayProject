% Generate a PDM sine wave sweep from 1000 Hz to 40000 Hz.

start_freq = 1000;
end_freq = 40000;
freq_step = 1000;
sampling_rate = 2e6; % 2 MHz
duration = 0.0005; % 0.5 ms

pdm_sig_sweep = int8([]);

for i = start_freq:freq_step:end_freq
    % Each frequency of sine wave lasts for 4 periods.
    pdm_sig = pdm_sine_gen(i, sampling_rate, duration);
    % Remove the last sample point to get a whole number of sample points.
    pdm_sig(end) = [];
    pdm_sig_sweep = [pdm_sig_sweep, int8(pdm_sig)];
end

pdm_file_output(pdm_sig_sweep, 'sine_sweep.mif');
