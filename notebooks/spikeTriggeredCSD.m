%%
clear; init;
%% subset
animal_info = animal_info(~ismember({animal_info.type}, {'2W Strk'}));
%% calculate
window_size = 0.5*Fs;
[csd, dipoles] = deal(cell(numel(animal_info), 1));
for i=1:numel(animal_info)
    fprintf('%d/%d\n', i, numel(animal_info));
    data = load(fullfile(cache_dir, 'data', [animal_info(i).name '.mat']));
    % only care about the spikes that are within the ephys recording time
    rec_seconds = size(data.lfp,1)/Fs;
    data.spikes.spikes = cellfun(@(c) c(c < rec_seconds), data.spikes.spikes, 'UniformOutput', false);
    for lr=1  % just ipsilesional
        fprintf('\t%s\n', side2char(lr));
        aligned = align(data.lfp(:, side2idxs(lr)), data.spikes.spikes{lr} * Fs, window_size);
        tmp = zscore(convn(aligned, [-1 2 -1], 'valid'), 0, 'all');  % hey look it's a csd
        csd{i, lr} = mean(tmp, 3);
        dipoles{i, lr} = squeeze(max(tmp, [], 1:2) - min(tmp, [], 1:2));
        clear aligned tmp
%         csd_animal = NaN(size(aligned));
%         for j=1:size(aligned, 3)
%             csd_animal(:, :, j) = CSDlite(aligned(:, :, j), Fs, 1e-4);
%         end
%         csd{i, lr} = mean(csd_animal(:, 2:end-1, :), 3);
    end
end
%%
% don't need to do this if we zscore each animal
% csd = cellfun(@(c) c' * voltScalar * 0.003, csd, 'UniformOutput', false);  % magic numbers for converting to μA/mm^3
%% align and plot mean CSD
aligned = alignElectrodes(csd, animal_info);
[grouped, types] = groupByAnimalType(aligned, animal_info);
averaged = cellfun(@(c) mean(cat(3, c{:}), 3), grouped, 'UniformOutput', false);

mn = min(cat(3, averaged{:}), [], 'all');
mx = max(cat(3, averaged{:}), [], 'all');
x_ticks = linspace(1, window_size, 5);
x_tick_labels = arrayfun(@(x) num2str(round(x/Fs, 2)), linspace(-window_size/2, window_size/2, 5), 'UniformOutput', false);
fig = figure('Visible', 'off', 'Position', [0, 0, 5, 4]*250);
for i=1:numel(averaged)
    hold on
    subplot(2, 2, i);
    imagesc(averaged{i})
    title(types(i));
    xticks(x_ticks)
    xticklabels(x_tick_labels)
    xlabel('Time (s)')
    ylabel('Depth')
    clim([mn, mx])
    colormap(jet)
    colorbar
    hold off
end
exportgraphics(fig, fullfile(plot_dir, 'csd_by_condition.png'))
close(fig)
%%
% aligned = alignElectrodes(csd, animal_info);
% [mean_dipole, stderr_dipole, types] = calculateDipoles(aligned, animal_info);
averaged = cellfun(@mean, dipoles);
[grouped, types] = groupByAnimalType(averaged, animal_info);
m = cellfun(@mean, grouped);
ci = cellfun(@(c) bootci(1000, @mean, c)', grouped, 'UniformOutput', false);
ci = cat(1, ci{:});
m = [m ci-m];

fig = figure('Visible', 'off');
hold on
colors = {'#5db2f5', '#ffbf44', '#a78df0', '#fd755d'};
for i=1:numel(types)
    bar(types(i), m(i, 1), 'FaceColor', colors{i});
end
% bar(types, m(:, 1))
er = errorbar(types, m(:,1), m(:,2), m(:,3));
er.Color = [0 0 0];
er.LineStyle = 'none';
ylabel('ΔCSD Dipole (au)')
hold off
exportgraphics(fig, fullfile(plot_dir, 'csd_dipole.png'))
close(fig)
%%
labs = cell(1, numel(types));
for i=1:numel(labs)
    labs{i} = repmat(types(i), 1, numel(grouped{i}));
end
labs = [labs{:}];
grouped = cat(1, grouped{:});
[p, ~, stats] = anova1(grouped, labs, 'on');  % this is fine (...for now)
%%
% c = multcompare(stats, 'Display', 'off');  % and same here