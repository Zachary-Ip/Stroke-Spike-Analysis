function out = toFieldtrip(data, Fs)
N = size(data.lfp, 1);
T = N / Fs;
spike = [];
spike.label = arrayfun(@(n) sprintf('unit_%d', n), data.spikes.chan, 'UniformOutput', false);
spike.timestamp = cell(1, numel(data.spikes.spikes));
for i=1:numel(data.spikes.spikes)
    idxs = int64(round(data.spikes.spikes{i} * Fs));
    idxs = idxs(idxs <= N);
    spike.timestamp{i} = idxs;
end
spike = ft_checkdata(ft_datatype_spike(spike));

cfg = [];
cfg.trl = [1 N 0];
cfg.timestampspersecond = Fs;
spike = ft_spike_maketrials(cfg, spike);

lfp = [];
lfp.label = arrayfun(@num2str, 1:size(data.lfp, 2), 'UniformOutput', false);
lfp.time = {linspace(0, T, N)};  % 1x1 cell array because we only have 1 "trial"
lfp.trial = {data.lfp'};  % channel x time
lfp.sampleinfo = [1 N];
lfp = ft_preprocessing([], ft_checkdata(lfp));

lfp.cfg.trl = spike.cfg.trl;  % silly out of date software is silly
lfp.hdr.FirstTimeStamp = 1;
lfp.hdr.TimeStampPerSample = 1;
out = ft_appendspike([], lfp, spike);
end