function [time_range_voltage_arr_avg] = calculateSTA(spikes,total_time)
time_range_voltage_arr = NaN(length(spikes), total_time); % nanmean(data)
for i = 1:length(spikes)
    curr_time = spikes(i) * 1000;
    if curr_time >= 500
        lower_index = curr_time - (total_time / 2);
    else
        continue;
    end

    if (curr_time + 500) <= length(full_ephys)
        upper_index = curr_time + (total_time / 2) - 1;
    else
        continue;
    end
    time_range_voltage_arr(i, :) = full_ephys(lower_index:upper_index);
end
time_range_voltage_arr_avg = mean(time_range_voltage_arr, 1);
end

