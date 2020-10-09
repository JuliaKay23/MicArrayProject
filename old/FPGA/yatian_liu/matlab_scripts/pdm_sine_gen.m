function [pdm_sig, ts] = pdm_sine_gen(sine_freq, sampling_rate, duration)
% Generate a vector of a pdm signal corresponding to a sine wave with
% frequency sine_freq, sampling rate sampling_rate, and time duration duration
% (unit: s). ts is the timestamp of the pdm_sig for plotting.

t = 0:(1/sampling_rate):duration;
len = length(t);
analog_sig = sin(2*pi * sine_freq * t);
pdm_sig = zeros(1, len);
quant_error = 0;

for i = 1:len
    if analog_sig(i) >= quant_error
        pdm_sig(i) = 1;
    else
        pdm_sig(i) = -1;
    end
    quant_error = quant_error + pdm_sig(i) - analog_sig(i);
end

ts = t;

end

