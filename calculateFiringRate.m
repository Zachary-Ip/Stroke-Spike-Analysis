function [firing_rate] = calculateFiringRate(spikes,total_time,Fs)
num_spikes = length(spikes);
firing_rate = num_spikes ./ (total_time./Fs);
end

