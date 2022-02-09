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
nbin = 0:17; % defines how many fractions to divide phase into
winsize = 2*pi/18;
position = nbin*winsize-pi;

spike_phases = [];

%time_idx = 1:len(ephys) ./Fs;
%pull out phase info
phase = angle(hilbert(ephys));
for i = 1:len(spike_times)    
    curr_time = round(spike_times(i)*Fs);
    instantaneous_phase = phase(curr_time);
    spike_phases(i) = instantaneous_phase;
end


