function [firing_rate] = calculateFiringRate(spikes,total_time,recording_freq)
num_spikes = length(spikes);
firing_rate = num_spikes ./ (total_time./recording_freq);
end

