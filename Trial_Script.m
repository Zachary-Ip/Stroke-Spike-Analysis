% This will be a testing platform to read neuralynx data and feed it into
% kilosort
close all, clear all, clc;
voltScale = 0.000000091555527603759401;

%test data dir
testDataPath = 'C:\Users\ipzach\Documents\Spiking Data\1MA01\R_Chan';

%%
nx_file1 = 'C:\Users\ipzach\Documents\Spiking Data\1MA02\L_Chan\2014-12-20_16-00-27.ncs';
nx_file2 = 'C:\Users\ipzach\Documents\Spiking Data\1MA02\L_Chan\2014-12-20_14-54-13.ncs';

nx_data1 = ft_read_data(nx_file1);
nx_data2 = ft_read_data(nx_file2);
nx_data = [nx_data1, nx_data2];
% nx_lfp1 = downsample(nx_data1,32);
% nx_lfp2 = downsample(nx_data2,32);

nx_filt = BPfilter(nx_data,32000,250,16000);
nx_scale = rescale(nx_filt,-1,1);
nx_lfp_time = linspace(0, length(nx_lfp)/1000,length(nx_lfp));
%%
chan1 = importdata('C:\Users\ipzach\Documents\Spiking Data\1MA02\L_Chan\sorted.txt');
chan2 = importdata('C:\Users\ipzach\Documents\Spiking Data\1MA03\L_Chan\sorted.txt');
chan3 = importdata('C:\Users\ipzach\Documents\Spiking Data\1MA04\L_Chan\sorted.txt');

compare = [chan1.data(1,2) chan2.data(1,2) chan3.data(1,2)];


hdr = ft_read_header('C:\Users\ipzach\Documents\Spiking Data\1MA02\L_Chan\sorted.plx');
nx_hdr = ft_read_header('C:\Users\ipzach\Documents\Spiking Data\1MA02\L_Chan\2014-12-20_16-00-27.ncs');


units = chan1.data(:,1);
timestamps = chan1.data(:,2);
waveforms = chan1.data(:,3:end);
wv_scale = rescale(waveforms,-1,1);
unit1 = timestamps(units == 1);
unit2 = timestamps(units == 2);
unit3 = timestamps(units == 3);

unit1 = [unit1 zeros(size(unit1))];
unit1(:,2) = 1;

unit2 = [unit2 zeros(size(unit2))];
unit2(:,2) = 2;

unit3 = [unit3 zeros(size(unit3))];
unit3(:,2) = 3;

scatter(unit1(:,1),unit1(:,2))
hold on
scatter(unit2(:,1),unit2(:,2))
scatter(unit3(:,1),unit3(:,2))

hold on
plot(nx_lfp_time,nx_lfp);


%%
for i = 1:length(SpkInfo{13,2})
   SpkInfo{13,2}(i).R_chn{1,2}(1)
end
disp('break')

for i = 2:length(SpkInfo{14,2})
   SpkInfo{14,2}(i).R_chn{1,2}(1)
end
