restoredefaultpath;
clear RESTOREDEFAULTPATH_EXECUTED

config
data_dir = fullfile(root_dir, 'DATA/Spike Data Cog Impairment Stroke');
addpath analysis/ utils/
ft_defaults;

Fs = 1250;
voltScalar = 0.000000015624999960550667;