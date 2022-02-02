function [spike_phases] = calculateSFC(spike_times, ephys, Fs)
%{
QUESTIONS: 
Should I be returning the spike phases so the caller of this
function can create a historgram? Or create the histogram within this
function?

What bandpass filter frequency band should I be using on the ephys before
inputting the ephys data into the hilbert and phase functions?
A: We should be getting filtered data.

What are the units of the spike times that we are extracting? Are they in
seconds or ms?


%}
% To break phase into windows
nbin = 0:17; % defines how many fractions to divide phase into
winsize = 2*pi/18;
position = nbin*winsize-pi;

spike_phases = []

%time_idx = 1:len(ephys) ./Fs;
%pull out phase info
phase = angle(hilbert(ephys));
for i = 1:len(spike_times)
    % add exception for spikes close to start or end
    
    curr_time = round(spike_times(i)*Fs);
    instantaneous_phase = phase(ephys(curr_time));
    spike_phases(i) = instantaneous_phase;
    
    % grab phase value during spike
    % spectrogram()
end

%{
ephys_data = ephys.dat;
bp_delta = bandpass(ephys_data, [0.1, 3], recording_frequency);
bp_theta = bandpass(ephys_data, [3, 7], recording_frequency);
bp_alpha = bandpass(ephys_data, [7, 12], recording_frequency);
bp_beta = bandpass(ephys_data, [12, 30], recording_frequency);
bp_gamma = bandpass(ephys_data, [32, 58], recording_frequency);
bp_highgamma = bandpass(ephys_data, [62, 150], recording_frequency);

hilbert_ephys_data_angle_delta = angle(hilbert(bp_delta));
hilbert_ephys_data_angle_theta = angle(hilbert(bp_theta));
hilbert_ephys_data_angle_alpha = angle(hilbert(bp_alpha));
hilbert_ephys_data_angle_beta = angle(hilbert(bp_beta));
hilbert_ephys_data_angle_gamma = angle(hilbert(bp_gamma));
hilbert_ephys_data_angle_highgamma = angle(hilbert(bp_highgamma));
%}