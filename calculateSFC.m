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
A: seconds

%}
% To break phase into windows
%nbin = 0:17; % defines how many fractions to divide phase into
%winsize = 2*pi/18;
%position = nbin*winsize-pi;

spike_phases = [];

%time_idx = 1:len(ephys) ./Fs;
%pull out phase info
phase = angle(hilbert(ephys));
disp(['ephys size 1 ' size(ephys, 1)])
disp(['ephys size 2 ' size(ephys, 2)])
disp(['phase size 1 ' size(phase, 1)])
disp(['phase size 2 ' size(phase, 2)])
disp(['spike_times size 1 ' size(spike_times, 1)])
disp(['spike_times size 2 ' size(spike_times, 2)])
for i = 1:length(spike_times)    
    curr_time = round(spike_times(i)*Fs);
    instantaneous_phase = phase(curr_time);
    spike_phases(i) = instantaneous_phase;
end
spike_phases = spike_phases;
disp(['spike_phases size 1 ' size(spike_phases, 1)])
disp(['spike_phases size 2 ' size(spike_phases, 2)])
end


