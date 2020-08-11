len = length(mux_val) / 8;
audio_val = zeros(len, 2);

for i = 1:len
    audio_val(i, 1) = ...
        mux_val(8*(i-1)+1)*2^11 + mux_val(8*(i-1)+2)*2^7 ...
      + mux_val(8*(i-1)+3)*2^3  + mux_val(8*(i-1)+4)/2;
    audio_val(i, 2) = ...
        (mux_val(8*(i-1)+5) - 1)*2^11 + (mux_val(8*(i-1)+6) - 1)*2^7 ...
      + (mux_val(8*(i-1)+7) - 1)*2^3  + (mux_val(8*(i-1)+8) - 1) / 2;
    if audio_val(i, 1) >= 2^15
        audio_val(i, 1) = -(2^16 - audio_val(i, 1));
    end
    if audio_val(i, 2) >= 2^15
        audio_val(i, 2) = -(2^16 - audio_val(i, 2));
    end
end

audio_val_filtered = zeros(size(audio_val));
audio_val_filtered(1:3, :) = audio_val(1:3, :); 
for i = 4:length(audio_val)
    for ch = 1:2
        ch_avg = mean(audio_val_filtered(i-3:i-1, ch));
        if abs(audio_val(i, ch)) > 5*abs(ch_avg) && abs(audio_val(i, ch)) > 1200
            audio_val_filtered(i, ch) = audio_val_filtered(i-1, ch);
        else
            audio_val_filtered(i, ch) = audio_val(i, ch);
        end
    end
end
