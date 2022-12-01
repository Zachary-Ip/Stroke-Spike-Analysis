%%
clear
addpath fieldtrip
ft_defaults
spk_info = get_spk_info;
animal_info = create_animal_info(spk_info);
root_dir = '/mnt/cifs/tower.wanprc.org/Azadeh/DATA/Spike Data Cog Impairment Stroke';
%%
differences = zeros(numel(animal_info), 1);
for i=1:numel(animal_info)
    disp(['i = ' num2str(i) ' Reading ' animal_info(i).name])
    ephys_durations = get_raw_ephys_durations(root_dir, animal_info(i));
    cleaned_rec_duration = get_cleaned_recording_duration(root_dir, animal_info(i));
    differences(i) = min(abs(cleaned_rec_duration/1250/60 - cumsum(ephys_durations)/32000/60));
end
%%
for i=[38, 39, 44]
    ephys_durations = get_raw_ephys_durations(root_dir, animal_info(i));
    cleaned_rec_duration = get_cleaned_recording_duration(root_dir, animal_info(i));
    difference = cleaned_rec_duration/1250/60 - cumsum(ephys_durations)/32000/60;
    disp(difference)
end
%%
function [ephys] = get_raw_ephys_durations(root_dir, animal_info)
if ismember(animal_info.type, {'Control', 'EE Sham'})
    sub_dir = 'control';
else
    sub_dir = 'dMCAO';
end
ex_dir = fullfile(root_dir, sub_dir, animal_info.name);
date_dir_names = {dir(ex_dir).name};
date_dir_names = date_dir_names(~ismember(date_dir_names, {'.', '..'}));
ephys = zeros(numel(date_dir_names), 1);
for i=1:numel(date_dir_names)
    date_dir = fullfile(ex_dir, date_dir_names{i});
    ephys(i) = ft_read_header(fullfile(date_dir, 'CSC1.ncs')).nSamples;
end
end

function [t] = get_cleaned_recording_duration(root_dir, animal_info)
file = matfile(fullfile(root_dir, 'Chronic Stroke', animal_info.alt_name, 'concatenatedLFP.mat'));
if ismember('LFP', who(file))
    var = 'LFP';
else
    var = 'cLFP';
end
t = size(file, var, 1);
end