function [spec, f_crop] = calculatePSD(spikes,ephys, fs)
spec = NaN(501,length(spikes));
for i = 1:length(spikes)
    idx = round(spikes(i) * fs);
    if idx > 1000 && idx < (length(ephys)-1000)
        [temp_spec,f] = periodogram(ephys(idx-1000:idx+1000),hamming(2001),2001,1000,'power');
        spec(1:501,i) = temp_spec(1:501);
    end
end
f_crop = f(1:501);
% Testing
% a = abs(nanmean(spec,3));
% figure
% h = pcolor(t,f,a);
% set(h, 'EdgeColor', 'none');
% shading interp
end