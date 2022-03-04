function [cropped, f_crop, t] = calculateSpec(spikes,ephys, fs)
spec = NaN(31,86,length(spikes));
for i = 1:length(spikes)
    idx = round(spikes(i) * fs);
    if idx > 1000 && idx < (length(ephys)-1000)
        [temp_spec,f,t] = spectrogram(ephys(idx-1000:idx+1000),24,1,60,1000);
        spec(:,:,i) = temp_spec;
    end
end
cropped = abs(spec(1:10,:,:));
f_crop = f(1:10);
% Testing
% a = abs(nanmean(spec,3));
% figure
% h = pcolor(t,f,a);
% set(h, 'EdgeColor', 'none');
% shading interp
end