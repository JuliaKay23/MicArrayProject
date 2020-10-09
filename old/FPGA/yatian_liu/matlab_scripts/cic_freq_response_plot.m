function cic_freq_response_plot(R, M, N, Fs)
    f_n = 0.001:0.001:0.500; % Normalized frequency
    f = Fs * f_n; % Real frequency
    H = (abs(sin(R*M*pi * f_n) ./ sin(pi * f_n))).^N;
    H_dB = 20 * log10(H / H(1));

    figure;
    plot(f, H_dB);
    title('CIC Filter''s Frequency Response');
    xlabel('Frequency [Hz]');
    ylabel('Amplitude [dB]');
    ylim([-140, 20]);
end
