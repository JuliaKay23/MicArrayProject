duration = 0.02; % in seconds
sine_freq = 100;

t_analog = 0:(1/sine_freq/100):duration;
analog_sig = sin(2*pi * sine_freq * t_analog);
[pdm_sig, t_pdm] = pdm_sine_gen(sine_freq, sine_freq * 64, duration);

f = figure;
stairs(t_pdm, pdm_sig, 'LineWidth', 2);
hold on
plot(t_analog, analog_sig, 'LineWidth', 2);
