close all, clear all, clc;
dataPath = 'C:\Users\ipzach\Documents\Spiking Data\1MA01\R_Chan';

%% Load in Spike timings
sorted1 = importdata('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\multitest_000.txt');
sorted2 = importdata('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\multitest_001.txt');
sorted3 = importdata('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\multitest_002.txt');
nx_hdr1 = ft_read_header('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\2014-07-25_12-08-44.ncs');
nx_hdr2 = ft_read_header('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\2014-07-25_12-41-04.ncs');
nx_hdr3 = ft_read_header('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\2014-07-25_13-44-07.ncs');
% 
% 
% % units = sorted.data(:,1);
% timestamps1 = sorted1.data(:,3);
% timestamps2 = sorted2.data(:,3);
% timestamps3 = sorted3.data(:,3);
% 
% 
% % Get First time stamp correction from header
% % hdr = ft_read_header('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\multitest.plx');
% 
% FirstTimeStamp1 = double(nx_hdr1.FirstTimeStamp) / 1000000;
% FirstTimeStamp2 = double(nx_hdr2.FirstTimeStamp) / 1000000;
% FirstTimeStamp3 = double(nx_hdr3.FirstTimeStamp) / 1000000;
% 
% adj_timestamps1 = timestamps1 - FirstTimeStamp1;
% adj_timestamps2 = timestamps2 - FirstTimeStamp2;
% adj_timestamps3 = timestamps3 - FirstTimeStamp3;
% 
% unit1 = [adj_timestamps1 zeros(size(adj_timestamps1))];
% unit1(:,2) = 1;
% 
% unit2 = [adj_timestamps2 zeros(size(adj_timestamps2))];
% unit2(:,2) = 2;
% 
% unit3 = [adj_timestamps3 zeros(size(adj_timestamps3))];
% unit3(:,2) = 3;

%% Load in ephys data
nx_data1 = ft_read_data('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\2014-07-25_12-08-44.ncs');
nx_data2 = ft_read_data('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\2014-07-25_12-41-04.ncs');
nx_data3 = ft_read_data('C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\2014-07-25_13-44-07.ncs');
% Concatenate it
% nx_data1 = ft_read_data(nx_file1);
% nx_data2 = ft_read_data(nx_file2);
nx_data = [nx_data1, nx_data2, nx_data3];
% nx_lfp1 = downsample(nx_data1,32);
% nx_lfp2 = downsample(nx_data2,32);
% nx_lfp3 = downsample(nx_data3,32);
% 
% nx_time1 = linspace(0, length(nx_lfp1)/1000,length(nx_lfp1));
% nx_time2 = linspace(0, length(nx_lfp2)/1000,length(nx_lfp2));
% nx_time3 = linspace(0, length(nx_lfp3)/1000,length(nx_lfp3));
% 
% nx_scale1 = rescale(nx_lfp1,-1,1);
% nx_scale2 = rescale(nx_lfp2,-1,1);
% nx_scale3 = rescale(nx_lfp3,-1,1);
% 
% plot(nx_time1, nx_scale1);
% hold on
% scatter(unit1(:,1),unit1(:,2))
% 
% figure, plot(nx_time2, nx_scale2);
% hold on
% scatter(unit2(:,1),unit2(:,2))
% 
% figure, plot(nx_time3, nx_scale3);
% hold on
% scatter(unit3(:,1),unit3(:,2))
%% 
fileID = fopen('test.bin','w');
fwrite(fileID,nx_data);
fclose(fileID);
% %
%   nex.hdr.FileHeader.Frequency  = 32000;
%   nex.hdr.VarHeader.Type       = 5;
%   nex.hdr.VarHeader.Name       = 'test                                                            ';
%   nex.hdr.VarHeader.WFrequency = 32000;
%   nex.var.dat                  = nx_data;
%   nex.var.ts                   = [];
% 
% write_plexon_nex('test.nex',nex);

% %% 
% ncs.dat = nx_data;
% ncs.TimeStamp = [];
% write_neuralynx_ncs('test.ncs',ncs);

