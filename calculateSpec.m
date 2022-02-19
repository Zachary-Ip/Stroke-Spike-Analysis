function [spec] = calculateSpec(spikes,ephys, fs)
spec = NaN(129,79,length(spikes));
for i = 1:length(spikes)
    idx = round(spikes(i) * fs);
    if idx >= 1000 && idx <= (length(ephys)-1000)
        temp_spec = spectrogram(ephys(idx-1000:idx+1000),50,[],[],1000);
        spec(:,:,i) = temp_spec;
    end
end
end