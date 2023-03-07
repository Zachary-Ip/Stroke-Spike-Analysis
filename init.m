%restoredefaultpath;
%clear RESTOREDEFAULTPATH_EXECUTED

<<<<<<< Updated upstream
config
data_dir = fullfile(root_dir, 'DATA/Spike Data Cog Impairment Stroke');
addpath analysis/ plots/ external/
addpath(genpath('utils'))
=======
%config
data_dir = fullfile('R:\DATA\Spike Data Cog Impairment Stroke');
addpath analysis/ utils/
>>>>>>> Stashed changes
ft_defaults;

Fs = 1250;
voltScalar = 0.000000015624999960550667;
spk_info = getSpkInfo;
animal_info = createAnimalInfo(spk_info, data_dir, cache_dir);
