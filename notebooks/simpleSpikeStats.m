clear; init
%% subset
animal_info = animal_info(~ismember({animal_info.type}, {'2W Strk'}));
%% Load spikes
n = numel(animal_info);
spikes = cell(n, 2);
for i=1:n
    fprintf('%d/%d\n', i, numel(animal_info));
    tmp = load(fullfile(cache_dir, 'data', [animal_info(i).name '.mat']), 'spikes').spikes;
    for lr=1:2
        spikes{i, lr} = tmp.spikes{lr};
    end
end
%% Calculate ISI by condition
[grouped, types] = groupByAnimalType(spikes, animal_info);
types = categorical(types, {'Control', '1M Strk', 'EE Sham', 'EE Strk'}, "Ordinal", true);
[types, sortperm] = sort(types);
grouped = grouped(sortperm);
[den, xi] = deal(cell(numel(types), 2));
for i=1:numel(grouped)
    group = cellfun(@diff, grouped{i}, 'UniformOutput', false);
    for lr=1:2
        [den{i, lr}, xi{i, lr}] = ksdensity(log(cat(1, group{:, lr})));
        den{i, lr} = den{i, lr} / sum(den{i, lr});
    end
end
%% plot ISI by condition
x_low = min(cat(1, xi{:}), [], 'all');
x_high = max(cat(1, xi{:}), [], 'all');
y_high = max(cat(1, den{:}), [], 'all');
for i=1:size(den, 1)
    subplot(ceil(size(den, 1)/2), 2, i)
    plot(xi{i, 1}, den{i, 1})
    hold on
    xlim([x_low-abs(0.05*x_low), x_high+abs(0.05*x_high)])
    ylim([0, y_high*1.05])
    title(types(i))
    plot(xi{i, 2}, den{i, 2})
    legend('Ipsi', 'Contra')
    xlabel('ISI (log)')
    hold off
end
%% Plot ipsilateral ISI in one plot
for i=1:numel(gcf().Number)
    close(gcf)
end
figure('Position',[0,0,3,2]*150, 'Visible','off')
ax = gca;
hold on
for i=1:size(den, 1)
    semilogx(ax, exp(xi{i, 1}), den{i, 1}, 'LineWidth',2)
end
xlabel(ax, 'ISI (s)')
legend(ax, types)
ax.XScale = 'log';
hold off
exportgraphics(gcf, fullfile(plot_dir, 'isi.png'))
%% ISI condition and brain state
% load HTD/LTD info
states = struct('L', cell(1, n), 'R', cell(1, n));
for i=1:n
    s = load(fullfile(data_dir, 'Chronic Stroke', animal_info(i).alt_name, 'cREM.mat')).cREM;
    states(i).L = cat(1, s.L.start, s.L.end);
    states(i).R = cat(1, s.R.start, s.R.end);
end
%% Plot ipsilateral ISI by brain state and condition
lr = 1;
[htd_den, htd_xi, htd_isi] = calculateISIDensityByGroup(spikes, states, animal_info, lr);
[ltd_den, ltd_xi, ltd_isi] = calculateISIDensityByGroup(spikes, createLTDStates(states), animal_info, lr);
den = [htd_den ltd_den];
xi = [htd_xi ltd_xi];
isi = [htd_isi' ltd_isi'];

for i=1:numel(gcf().Number)
    close(gcf)
end
figure('Position',[0,0,2,3]*250, 'Visible','off')
for j=1:2
    ax = subplot(2,1,j);
    hold on
    for i=1:size(den, 1)
        semilogx(ax, exp(xi{i, j}), den{i, j}, 'LineWidth',2)
    end
    xlabel(ax, 'ISI (s)')
    legend(ax, types)
    if j==1, title(ax, 'HTD'), else, title(ax, 'LTD'); end
    ax.XScale = 'log';
    hold off
end
exportgraphics(gcf, fullfile(plot_dir, 'isi_by_state.png'))
close(gcf)
%%
x_low = min(cat(1, xi{:}), [], 'all');
x_high = max(cat(1, xi{:}), [], 'all');
y_high = max(cat(1, den{:}), [], 'all');
for j=1:size(den, 2)
    for i=1:size(den, 1)
        subplot(size(den, 1), size(den, 2), (i-1)*size(den, 2)+j)
        plot(xi{i, j}, den{i, j})
        hold on
        xlim([x_low-abs(0.05*x_low), x_high+abs(0.05*x_high)])
        ylim([0, y_high*1.05])
        title(types(i))
%         plot(xi{i, 2}, isi{i, 2})
%         legend('Ipsi', 'Contra')
        xlabel('ISI (log)')
        hold off
    end
end
%% Plot statitics
% stats = cell(size((isi)));
% for i=1:numel(isi)
%     [lambda, ] = poissfit(1./isi{i});
%     stats{i} = [lambda lambdaci(1)-lambda lambda-lambdaci(2)];
% end
stats = cellfun(@(c) poissfit(1./c), isi);
lower = icdf('Poisson', 0.025, stats);
upper = icdf('Poisson', 0.975, stats);
stats = cat(3, stats, stats-lower, upper-stats);
x = types;
% htd_stats = cat(1, stats{:, 1});
% ltd_stats = cat(1, stats{:, 2});
% stats = permute(cat(3, htd_stats, ltd_stats), [1, 3, 2]);  % type x htd/ltd x stats
b = bar(x, stats(:, :, 1), 'Visible', 'off');
legend({'HTD', 'LTD'}, 'Location','northwest')
ylabel('Spike rate')
hold on
error_x = cat(1,b.XEndPoints);
er = errorbar(error_x', stats(:, :, 1), stats(:, :, 2), stats(:, :, 3));
[er.Color] = deal([0 0 0]);
[er.LineStyle] = deal('none');
ax = gca;
ax.Legend.String = ax.Legend.String(1:2);  % hack
hold off
exportgraphics(gcf, fullfile(plot_dir, 'spike_rates.png'))
%%
a = cat(1, isi{:});
labs = cell(size(isi));
for i=1:size(labs, 1)
    for j=1:size(labs, 2)
        if j==1, htd_ltd = 'HTD'; else, htd_ltd = 'LTD'; end
        c = {string(types(i)), htd_ltd};
        labs{i,j}= repmat(c, numel(isi{i,j}), 1);
    end
end
labs = cat(1, labs{:});
% anovan(log(a), labs, 'model', 2)  womp womp, can't do this
%%
function out = htd(times)
out = times;
end

function out = ltd(times)
out = [times(2, 1:end-1); times(1, 2:end)];
end

function out = htd_duration(times)
out = diff(htd(times));
end

function out = ltd_duration(times)
out = diff(ltd(times));
end

function out = createLTDStates(states)
out = [];
out = copyfields(states, out, fieldnames(states));
for i=1:numel(out)
    out(i).L = ltd(out(i).L);
    out(i).R = ltd(out(i).R);
end
end

function [dens, xi, isi, types] = calculateISIDensityByGroup(spikes, states, animal_info, side)
n = numel(animal_info);
isi = cell(n, 1);
for i=1:n
    s = spikes{i, 1};
    st = states(i).(side2char(side));
    tmp = cell(1, size(st, 1));
    for j=1:size(st, 2)
        start = st(1, j);
        stop = st(2, j);
        tmp{j} = diff(s(and(s > start, s < stop)));
    end
    isi{i} = cat(1, tmp{:});
end
[isi, types] = groupByAnimalType(isi, animal_info);
isi = cellfun(@(c) cat(1, c{:}), isi, 'UniformOutput', false);
[dens, xi] = deal(cell(numel(types), 1));
for i=1:numel(isi)
    [dens{i}, xi{i}] = ksdensity(log(isi{i}));
    dens{i} = dens{i} / sum(dens{i});
end
end

