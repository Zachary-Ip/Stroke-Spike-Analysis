% Analysis_Stat
load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\spike_measures.mat')
lim = 15000;
%calculate1wayANOVA(ISI)
close all

figure
subplot(2,3,1)
polarhistogram(SFC_storage_m{1,1})
title('Control')
rlim([0 lim])
subplot(2,3,2)
polarhistogram(SFC_storage_m{2,1})
title('2 Week')
rlim([0 lim])
subplot(2,3,3)
polarhistogram(SFC_storage_m{3,1})
title('1 Month')
rlim([0 lim])
subplot(2,3,4)
polarhistogram(SFC_storage_m{4,1})
title('EE Control')
rlim([0 lim])
subplot(2,3,6)
polarhistogram(SFC_storage_m{5,1})
title('EE Stroke')
rlim([0 lim])

load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\SpikeAnalysis\STA_storage_m.mat')
whos
figure
subplot(2,3,1)
mean_STA = mean(STA_storage_m{1,1});
x = linspace(-500, 500, length(mean_STA));
plot(x, mean_STA)
title('Control')
xlabel('Time relative to spike (ms)')
ylabel('Voltage (mV)')
ylim([-60 40])
subplot(2,3,2)
mean_STA = mean(STA_storage_m{2,1});
x = linspace(-500, 500, length(mean_STA));
plot(x, mean_STA)
title('2 Week')
xlabel('Time relative to spike (ms)')
ylabel('Voltage (mV)')
ylim([-60 40])
subplot(2,3,3)
mean_STA = mean(STA_storage_m{3,1});
x = linspace(-500, 500, length(mean_STA));
plot(x, mean_STA)
title('1 Month')
xlabel('Time relative to spike (ms)')
ylabel('Voltage (mV)')
ylim([-60 40])
subplot(2,3,4)
mean_STA = mean(STA_storage_m{4,1});
x = linspace(-500, 500, length(mean_STA));
plot(x, mean_STA)
title('EE Control')
xlabel('Time relative to spike (ms)')
ylabel('Voltage (mV)')
ylim([-60 40])
subplot(2,3,6)
mean_STA = mean(STA_storage_m{5,1});
x = linspace(-500, 500, length(mean_STA));
plot(x, mean_STA)
title('EE Stroke')
xlabel('Time relative to spike (ms)')
ylabel('Voltage (mV)')
ylim([-60 40])



