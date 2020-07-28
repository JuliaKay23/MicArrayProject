% Test whether the input data is periodic with period "period". The length
% of the input data must be a multiple of period.
function [isPeriodic] = test_periodicity(data, period)
    isPeriodic = true;
    len = length(data) / period;
    if ~(isfinite(len) && (len == floor(len)))
        disp("Error: length(data) is not a multiple of period.");
        isPeriodic = false;
        return;
    end
    for i = 1:period
        for j = 1:len-1
            if data(i+j*period) ~= data(i)
                str = sprintf( ...
                    "data(%d) = %d is different from data(%d) = %d.", ...
                    i, data(i), i+j*period, data(i+j*period));
                disp(str);
                isPeriodic = false;
            end
        end
    end
end

