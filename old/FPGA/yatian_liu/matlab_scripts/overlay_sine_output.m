Fs_pdm = 2e6; %  PDM sampling rate
duration = 4e-3; % 4 ms duration

% Generate PDM signal.
t_pdm = 0:(1/Fs_pdm):duration;
t_pdm(end) = []; % Remove the last sample point to get a whole length
len = length(t_pdm);
analog_sig = overlay_sine(t_pdm);
fft_plot(analog_sig, Fs_pdm);

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
fft_plot(pdm_sig, Fs_pdm);
pdm_file_output(pdm_sig, 'overlay_sine.mif');

% Calculate the normalized overlayed sine signal given a time array t.
function signal = overlay_sine(t)
    signal = zeros(size(t));
    f_base = 2000; % base frequency
    f_max = 40000;
    % Generate the signal.
    for f = f_base:f_base:f_max
        signal = signal + sin(2*pi * f * t);
    end
    % Normalize the signal.
    signal_abs_max = max(abs(signal));
    signal = signal ./ signal_abs_max * 0.5;
end
