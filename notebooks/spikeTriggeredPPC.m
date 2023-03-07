% This script loads and processes data from multiple animals to calculate the
% phase-pairing consistency (PPC) for each animal in the theta frequency range
% (4-7 Hz). The PPC is calculated for three conditions: all spikes, spikes
% occurring during high-theta-descending (HTD) periods, and spikes occurring
% during low-theta-descending (LTD) periods. The PPC for each animal is
% plotted as a heatmap and as a bar graph with error bars. Statistical
% significances between the HTD and LTD conditions are also plotted.

% Clear workspace and initialize variables
clear; init

% Subset the animal information to exclude animals of type '2W Strk'
animal_info = animal_info(~ismember({animal_info.type}, {'2W Strk'}));
n = numel(animal_info);
% Load HTD/LTD information for each animal
states = struct('L', cell(1, n), 'R', cell(1, n));
for i=1:n
    % Load cREM data for the current animal
    s = load(fullfile(data_dir, 'Chronic Stroke', animal_info(i).alt_name, 'cREM.mat')).cREM;
    % Concatenate the start and end times of the HTD/LTD periods for left and right sides
    states(i).L = cat(1, s.L.start, s.L.end);
    states(i).R = cat(1, s.R.start, s.R.end);
end
%% calculate ipsilateral PPC for all freq
[ppc, freq] = deal(cell(numel(animal_info), 3));
for i=1:numel(animal_info)
    fprintf('%d/%d\n', i, numel(animal_info));
    data = load(fullfile(cache_dir, 'data', [animal_info(i).name '.mat']));
    sp = data.spikes.spikes{1};  % left
    data = toFieldtrip(data, Fs);
    spec_out = calculateSpikeTriggeredSpectrum(data, 1);
    
    s = htd(states(i).L);
    is_htd = zeros(size(sp));
    for j=1:size(s,2)
        is_htd = or(is_htd, and(s(1, j) < sp, sp < s(2, j)));
    end
    
    s = ltd(states(i).L);
    is_ltd = zeros(size(sp));
    for j=1:size(s,2)
        is_ltd = or(is_ltd, and(s(1, j) < sp, sp < s(2, j)));
    end
    
    f = spec_out.fourierspctrm{1};
    ppc{i,1} = ft_connectivity_ppc(f(is_htd, :, :));
    ppc{i,2} = ft_connectivity_ppc(f(is_ltd, :, :));
    ppc{i,3} = ft_connectivity_ppc(f);
    freq{i,1} = spec_out.freq;
end
%%
freq = freq{1};  % assume all freqs are the same
%% Plot heatmaps by condition
fig = plotPPC(ppc(:, 3), freq, animal_info);
exportgraphics(fig, fullfile(plot_dir, 'ppc_by_condition_combined.png'))
close(fig)

fig = plotPPC(ppc(:, 1), freq, animal_info);
exportgraphics(fig, fullfile(plot_dir, 'ppc_by_condition_htd.png'))
close(fig)

fig = plotPPC(ppc(:, 2), freq, animal_info);
exportgraphics(fig, fullfile(plot_dir, 'ppc_by_condition_ltd.png'))
close(fig)
%% Plot bar graphs + significances by condition
freq_idxs = and(freq>=4, freq<=7);

fig = plotPPCErrorBars(ppc(:, 3), freq_idxs, 'L_pyramidal_chan', animal_info);
exportgraphics(fig, fullfile(plot_dir, 'ppc_error_bars_by_condition_combined_theta_pyr.png'))
close(fig)

fig = plotPPCErrorBars(ppc(:, 1), freq_idxs, 'L_pyramidal_chan', animal_info);
exportgraphics(fig, fullfile(plot_dir, 'ppc_error_bars_by_condition_htd_theta_pyr.png'))
close(fig)

fig = plotPPCErrorBars(ppc(:, 2), freq_idxs, 'L_pyramidal_chan', animal_info);
exportgraphics(fig, fullfile(plot_dir, 'ppc_error_bars_by_condition_ltd_theta_pyr.png'))
close(fig)
%%
function fig = plotPPC(ppc, freq, animal_info)
assert(size(ppc, 2) == 1)
aligned = alignElectrodes(ppc, animal_info);
[grouped, types] = groupByAnimalType(aligned, animal_info);
averaged = cellfun(@(c) mean(cat(3, c{:}), 3, 'omitnan'), grouped, 'UniformOutput', false);

m = max(cat(3, averaged{:}), [], 'all');
x = linspace(1, numel(freq), 5);
x_tick_labels = arrayfun(@(x) num2str(round(x, 2)), interp1(1:numel(freq), freq, x), 'UniformOutput', false);
fig = figure('Visible', 'off', 'Position', [0, 0, 5, 4]*250);
for i=1:numel(averaged)
    hold on
    subplot(2, 2, i);
    imagesc(averaged{i})
    title(types(i));
    xticks(x)
    xticklabels(x_tick_labels)
    xlabel('Frequency')
    ylabel('Depth')
    clim([0, m])
    colorbar
    hold off
end
end

function fig = plotPPCErrorBars(ppc, freq_idxs, chan, animal_info)
assert(size(ppc, 2) == 1)

% extract freq/chans
subsetted = cell(numel(animal_info), 1);
for i=1:numel(animal_info)
    chan_num = animal_info(i).(chan);
    subsetted{i} = ppc{i}(chan_num, freq_idxs);
end
[subsetted, types] = groupByAnimalType(subsetted, animal_info);
% concat all samples within frequency band and across animals in the same
% group together
subsetted = cellfun(@(c) [c{:}], subsetted, 'UniformOutput', false); % num groups -> 1 x m PPC array

ci = cellfun(@(c) bootci(10000, @(x) mean(x, 'omitnan'), c)', subsetted, 'UniformOutput', false);
ci = cat(1, ci{:});
m = cellfun(@(x) mean(x, 'omitnan'), subsetted);
m = [m ci-m];

labs = cell(1, numel(types));
for i=1:numel(labs)
    labs{i} = repmat(types(i), 1, numel(subsetted{i}));
end
labs = [labs{:}];
subsetted = [subsetted{:}];
[p, ~, stats] = anova1(subsetted, labs, 'off');  % this is fine (...for now)
c = multcompare(stats, 'Display', 'off');  % and same here

fig = figure('Position',[0,0,1,1]*500, 'Visible','off');
hold on
colors = {'#5db2f5', '#ffbf44', '#a78df0', '#fd755d'};
for i=1:numel(types)
    bar(types(i), m(i, 1), 'FaceColor', colors{i});
end
% bar(types, m(:, 1))
er = errorbar(types, m(:,1), m(:,2), m(:,3));
er.Color = [0 0 0];
er.LineStyle = 'none';
c = c(c(:,6) < 0.05, :);
compars = cell(1,size(c,1));
for i=1:numel(compars)
    compars{i} = types(c(i, 1:2));
end
if p<0.05
    sigstar(compars, c(:, 6))
end
hold off
end

function out = htd(times)
out = times;
end

function out = ltd(times)
out = [times(2, 1:end-1); times(1, 2:end)];
end