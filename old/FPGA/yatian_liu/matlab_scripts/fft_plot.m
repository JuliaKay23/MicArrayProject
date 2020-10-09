% Plot the FFT of the given signal with sampling rate Fs.
function fft_plot(signal, Fs)
    len = length(signal);
    y = fft(signal);
    f = Fs * (0:len/2) / len;
    P2 = abs(y / len);
    if (mod(len, 2) == 0)
        P1 = P2(1:len/2+1);
    else
        P1 = P2(1:floor(len/2)+1);
    end
    P1(2:end-1) = 2*P1(2:end-1);
    figure;
    plot(f, P1);
    title('Input Signal in Frequency Domain');
    xlabel('Frequency (Hz)');
    ylabel('|P(f)|');
end
