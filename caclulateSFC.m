function caclulateSFC(spike_times, ephys, Fs)

% To break phase into windows
nbin = 0:17; % defines how many fractions to divide phase into
winsize = 2*pi/18;
position = nbin*winsize-pi;

time_idx = 1:len(ephys) ./Fs;
%pull out phase info
phase = angle(hilbert(ephys));
for i = 1:len(spike times)
    % add exception for spikes close to start or end
    curr_time = round(spikes(i)*Fs);
    intsa_phase = phase(curr_time);
    
    % grab phase value during spike
    spectrogram()
end