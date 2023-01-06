function [amplitude, mean_voltage_arr] = calculateSTA(spikes,ephys, fs)
% This function calculates the spike-triggered average (STA) of a set of spikes and a corresponding electrophysiology signal.
%
% Inputs:
% - spikes: A vector of spike times, in seconds.
% - ephys: The corresponding electrophysiology signal, in voltsages.
% - fs: The sampling rate of the electrophysiology signal, in Hz.
%
% Outputs:
% - amplitude: A vector of amplitudes for each spike, in voltsages.
% - mean_voltage_arr: The STA of the electrophysiology signal, in voltages.
%

% Set the window size to 2 seconds
window = fs*2;

% Initialize the time-range voltage array with NaN values
time_range_voltage_arr = NaN(length(spikes), window);

% Initialize the amplitude vector with NaN values
amplitude = NaN(length(spikes),1);

% Loop through each spike
for i = 1:length(spikes)
    % Convert the spike time to samples
    curr_time = round(spikes(i) * fs);
    % Check if the current time is within the range of the electrophysiology signal
    if curr_time >= 1000 && (curr_time + 1000) <= length(ephys)
        % Extract the corresponding 2-second time range of the signal
        time_range_voltage_arr(i, :) = ephys(curr_time - 999:curr_time + 1000);
        
        % Calculate the amplitude of the spike by taking the maximum absolute value of the time range
        amplitude(i) = max(abs(ephys(curr_time - 999:curr_time + 1000)))*2;
    end
end

% Remove missing values from the time-range voltage array
time_range_voltage_arr = rmmissing(time_range_voltage_arr);

% Calculate the mean voltage array by taking the mean of the time-range voltage array
mean_voltage_arr = mean(time_range_voltage_arr, 1);

% Remove missing values from the amplitude vector
amplitude = rmmissing(amplitude);

end