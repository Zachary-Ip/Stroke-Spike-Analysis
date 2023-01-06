restoredefaultpath;
clear RESTOREDEFAULTPATH_EXECUTED

config
data_dir = fullfile(root_dir, 'DATA/Spike Data Cog Impairment Stroke');
addpath analysis/ plots/ external/
addpath(genpath('utils'))
ft_defaults;

Fs = 1250;
voltScalar = 0.000000015624999960550667;
spk_info = getSpkInfo;
animal_info = createAnimalInfo(spk_info, data_dir, cache_dir);
