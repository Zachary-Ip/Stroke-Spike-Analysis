function [mean_voltage_arr] = calculateSTA(spikes,ephys, fs)
window = fs*2;
time_range_voltage_arr = NaN(length(spikes), window); % nanmean(data)
% disp(['spikes size ' size(spikes) side])
for i = 1:length(spikes)
    curr_time = round(spikes(i) * fs);
    if curr_time >= 1000 && (curr_time + 1000) <= length(ephys)
        time_range_voltage_arr(i, :) = ephys(curr_time - 999:curr_time + 1000);
    end

    
end
time_range_voltage_arr = rmmissing(time_range_voltage_arr);
disp(['time_range_voltage_arr size 1 ' size(time_range_voltage_arr, 1)])
disp(['time_range_voltage_arr size 2 ' size(time_range_voltage_arr, 2)])
mean_voltage_arr = mean(time_range_voltage_arr, 1);
disp(['mean_voltage_arr size 1 ' size(mean_voltage_arr, 1)])
disp(['mean_voltage_arr size 2 ' size(mean_voltage_arr, 2)])
end

