function heatmapByAnimal(out_file, animal_info, matrices, x_ticks, x_tick_labels, varargin)
if numel(varargin) < 1
    color_map = jet;
else
    color_map = varargin{1};
end
assert(all(size(matrices) == [numel(animal_info), 2]))
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
            subplot(n, 2, (j-1)*2+lr);
            imagesc(matrices{idxs(j), lr})
            title(sprintf('%s, %s', animal_info(idxs(j)).name, side2char(lr)))
            xticks(x_ticks)
            xticklabels(x_tick_labels)
            colormap(color_map)
            colorbar
            hold off
        end
    end
    exportgraphics(fig, out_file, 'append', true)
    close(gcf)
end
end