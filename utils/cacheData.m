function cacheData(data_dir, cache_dir)
spk_info = getSpkInfo;
animal_info = createAnimalInfo(spk_info, data_dir, cache_dir);
for i=1:numel(animal_info)
    out_file = fullfile(cache_dir, "data", [animal_info(i).name '.mat']);
    fprintf("%d/%d: Caching %s\n", i, numel(animal_info), animal_info(i).name);
    if isfile(out_file)
        continue
    end
    animal_struct = [];
    
    try
        % load cleaned lfp
        file = matfile(fullfile(data_dir, 'Chronic Stroke', animal_info(i).alt_name, 'concatenatedLFP.mat'));
        if ismember('LFP', who(file))
            var = 'LFP';
        else
            var = 'cLFP';
        end
        fprintf("\tReading LFP\n")
        animal_struct.lfp = single(file.(var));  % let's save on the space, yes?
    
        % load spikes
        animal_struct.spikes = [];
        animal_struct.spikes.chan = [];
        animal_struct.spikes.spikes = cell(0);
        animal_dir = fullfile(data_dir, 'Spiking Data', animal_info(i).alt_name2);
        for lr=["L_chan", "R_chan"]
            lr_dir = fullfile(animal_dir, lr);
            chan_dirs = {dir(lr_dir).name};
            matches = cellfun(@(c) ~isempty(regexp(c, "^CSC\d+", 'once')), chan_dirs);
            chan_dirs = chan_dirs(matches);
            chan_dir = fullfile(lr_dir, chan_dirs{1});
            recs = {readDir(chan_dir).name};
            time_start = 0;
            spikes = cell(1, numel(recs));
            for j=1:numel(recs)
                fprintf("\tReading %s rec %d/%d\n", lr, j, numel(recs));
                data = load(fullfile(chan_dir, recs(j), 'data.mat'));
                spikes{j} = data.spike.neurons{1}.timestamps + time_start;
                time_start = time_start + numel(data.ephys.dat) / 32000;
            end
            chan_num = str2double(regexp(chan_dirs{1}, '[^\d](?<num>\d+)$', 'names').num);
            animal_struct.spikes.chan(end+1) = chan_num;
            animal_struct.spikes.spikes{end+1} = cat(1, spikes{:});
        end
        save(out_file, '-struct', 'animal_struct');
    catch ME
        fprintf("Failed reading, skipping for now\n");
        warning(ME.message);
    end
end
end