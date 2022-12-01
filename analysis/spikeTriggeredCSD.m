%%
clear; init;
spk_info = getSpkInfo;
animal_info = createAnimalInfo(spk_info, data_dir, cache_dir);
window_size = 0.5*Fs;
%% calculate
csd = cell(numel(animal_info), 2);
for i=1:numel(animal_info)
    fprintf('%d/%d\n', i, numel(animal_info));
    data = load(fullfile(cache_dir, 'data', [animal_info(i).name '.mat']));
    % only care about the spikes that are within the ephys recording time
    rec_seconds = size(data.lfp,1)/Fs;
    data.spikes.spikes = cellfun(@(c) c(c < rec_seconds), data.spikes.spikes, 'UniformOutput', false);
    for lr=1:2
        fprintf('\t%d\n', lr);
        % TODO: is 1-16 left and 17-32 right?
        is_upper = data.spikes.chan(lr) > 16;
        aligned = align(data.lfp(:, (1:16)+16*is_upper), data.spikes.spikes{lr} * Fs, window_size);
        csd{i, lr} = mean(convn(aligned, [-1 2 -1], 'valid'), 3);  % hey look it's a csd
%         csd_animal = NaN(size(aligned));
%         for j=1:size(aligned, 3)
%             csd_animal(:, :, j) = CSDlite(aligned(:, :, j), Fs, 1e-4);
%         end
%         csd{i, lr} = mean(csd_animal(:, 2:end-1, :), 3);
    end
end
%% plot
out_file = '~/desktop/csd.pdf';
delete(out_file);
types = unique({animal_info.type});
for i=1:numel(types)
    t = types{i};
    idxs = find(cellfun(@(c) strcmp(c, t), {animal_info.type}));
    n = numel(idxs);
    fig = figure('Position', [0, 0, 1000, 1000], 'Visible', 'off');
    for j=1:n
        for lr=1:2
            hold on
            ax = subplot(n, 2, (j-1)*2+lr);
            imagesc(csd{idxs(j)}' * voltScalar * 0.003)  % magic numbers for converting to μA/mm^3
            if lr == 1
                left_or_right = 'L';
            else
                left_or_right = 'R';
            end
            title(sprintf('%s, %s', animal_info(idxs(j)).name, left_or_right))
            xticks(linspace(1, window_size, 5))
            xticklabels(arrayfun(@(x) num2str(round(x/Fs, 2)), linspace(-window_size/2, window_size/2, 5), 'UniformOutput', false))
            colormap(flipud(jet))
            colorbar
            hold off
        end
    end
    exportgraphics(gcf, out_file, 'append', true)
    close(gcf)
end
%% Plot with error bands (WIP)
t = linspace(-window_size/2, window_size/2, window_size);
mu = mean(aligned, 3);
sigma = std(aligned, 0, 3) / sqrt(size(aligned, 3));
fill([t';flipud(t')], [mu-1.96*sigma; flipud(mu+1.96*sigma)], [.9 .9 .9], 'LineStyle', 'none')
line(t, mu)