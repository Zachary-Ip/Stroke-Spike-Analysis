function animal_info = createAnimalInfo(spk_info, data_dir, cache_dir)
a = spk_info(ismember(spk_info(:, 1), {'Control', 'EE Sham', '2W Strk', '1M Strk', 'EE Strk'}), :);
n_animals = sum(cellfun(@numel, a(:, 2)));
s = struct('type', cell(n_animals, 1), 'name', cell(n_animals, 1), 'num', NaN(n_animals, 1), 'alt_name', cell(n_animals, 1));
[s.keep] = deal(NaN);
k = 1;
for i=1:size(a, 1)
    for j=1:numel(a{i, 2})
        s(k).type = a{i, 1};
        s(k).name = a{i, 2}(j).name;
        s(k).num = str2double(regexp(s(k).name, '[^\d](?<num>\d+)$', 'names').num);
        s(k).alt_name = [a{i, 1}, '_' num2str(j)];
        s(k).alt_name2 = regexprep(s(k).name, 'M1A(.*)', '1MA$1');
        if isfield(a{i, 2}, 'L_cor')
            v = a{i, 2}(j).L_cor;
        else
            v = a{i, 2}(j).R_cor;
        end
        s(k).keep = v == 0 && ( ...
            isfile(fullfile(cache_dir, 'data', [s(k).name '.mat'])) ...
            || isfolder(fullfile(data_dir, 'Spiking Data', s(k).alt_name2))...
        );
        k = k + 1;
    end
end
% these animals have cleaned LFP data (in the "Chronic Stroke" directory)
% that doesn't align properly with our ephys data (in the "control" or
% "dMCAO" directories)
misaligned = {'2WA12', 'AEE01', 'AEE06'};
s = s([s.keep]);
animal_info = s(~cellfun(@(c) ismember(c, misaligned), {s.name}));
animal_info = rmfield(animal_info, 'keep');
end