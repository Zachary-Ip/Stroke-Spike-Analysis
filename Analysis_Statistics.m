% Analysis_Stats
FR = cell(5,2);
ISI = cell(5,2);
SFC = cell(5,2);

STA_a = cell(5,2);
STA_b = cell(5,2);
STA_d = cell(5,2);
STA_g = cell(5,2);
STA_hg = cell(5,2);
STA = cell(5,2);
STA_t = cell(5,2);

STAmean_a = cell(5,2);
STAmean_b = cell(5,2);
STAmean_d = cell(5,2);
STAmean_g = cell(5,2);
STAmean_hg = cell(5,2);
STAmean = cell(5,2);
STAmean_t = cell(5,2);
for i = 1:5
    switch i
        case 1
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\Control_multiunit_measures.mat')
        case 2
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEControl_multiunit_measures.mat')
        case 3
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\TwoWeek_multiunit_measures.mat')
        case 4
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\OneMonth_multiunit_measures.mat')
        case 5
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEOneMonth_multiunit_measures.mat')
    end
   
        FR{i,1} = FR_storage{1,1};         FR{i,2} = FR_storage{1,2};
        ISI{i,1} = ISI_storage{1,1};       ISI{i,2} = ISI_storage{1,2};
        SFC{i,1} = SFC_storage{1,1};       SFC{i,2} = SFC_storage{1,2};
        
        STA_a{i,1} = STA_a_storage{1,1};   STA_a{i,2} = STA_a_storage{1,2};
        STA_b{i,1} = STA_b_storage{1,1};   STA_b{i,2} = STA_b_storage{1,2};
        STA_d{i,1} = STA_d_storage{1,1};   STA_d{i,2} = STA_d_storage{1,2};
        STA_g{i,1} = STA_g_storage{1,1};   STA_g{i,2} = STA_g_storage{1,2};
        STA_hg{i,1} = STA_hg_storage{1,1}; STA_hg{i,2} = STA_hg_storage{1,2};
        STA{i,1} = STA_storage{1,1};       STA{i,2} = STA_storage{1,2};
        STA_t{i,1} = STA_t_storage{1,1};   STA_t{i,2} = STA_t_storage{1,2};
        
        STAmean_a{i,1} =  STAmean_a_storage{1,1};  STAmean_a{i,2} =  STAmean_a_storage{1,2};
        STAmean_b{i,1} = STAmean_b_storage{1,1};   STAmean_b{i,2} = STAmean_b_storage{1,2};
        STAmean_d{i,1} = STAmean_d_storage{1,1};   STAmean_b{i,2} = STAmean_b_storage{1,2};
        STAmean_g{i,1} =  STAmean_g_storage{1,1};  STAmean_b{i,2} = STAmean_b_storage{1,2};
        STAmean_hg{i,1} = STAmean_hg_storage{1,1}; STAmean_hg{i,2} = STAmean_hg_storage{1,2};
        STAmean{i,1} = STAmean_storage{1,1};       STAmean_hg{i,2} = STAmean_hg_storage{1,2};
        STAmean_t{i,1} = STAmean_t_storage{1,1};   STAmean_t{i,2} = STAmean_t_storage{1,2};
 
end

%% 1way ANOVA Stats
disp('FR')
FR_stats1 = calculate1wayANOVA(FR);
disp('ISI')
ISI_stats1 = calculate1wayANOVA(ISI);
disp('STA')
STA_stats1 = calculate1wayANOVA(STA);
disp('Alpha')
STA_a_stats1 = calculate1wayANOVA(STA_a);
disp('Beta')
STA_b_stats1 = calculate1wayANOVA(STA_b);
disp('Delta')
STA_d_stats1 = calculate1wayANOVA(STA_d);
disp('Theta')
STA_t_stats1 = calculate1wayANOVA(STA_t);
disp('Gamma')
STA_g_stats1 = calculate1wayANOVA(STA_g);
disp('High Gamma')
STA_hg_stats1 = calculate1wayANOVA(STA_hg);

%% 2way ANOVA stats
disp('FR')
FR_stats2    = calculate2wayANOVA(FR);
disp('ISI')
ISI_stats2   = calculate2wayANOVA(ISI);
disp('STA')
STA_stats2   = calculate2wayANOVA(STA);
disp('Alpha')
STA_a_stats2 = calculate2wayANOVA(STA_a);
disp('Beta')
STA_b_stats2 = calculate2wayANOVA(STA_b);
disp('Delta')
STA_d_stats2 = calculate2wayANOVA(STA_d);
disp('Theta')
STA_t_stats2 = calculate2wayANOVA(STA_t);
disp('Gamma')
STA_g_stats2 = calculate2wayANOVA(STA_g);
disp('High Gamma')
STA_hg_stats2 = calculate2wayANOVA(STA_hg);

%%
calculate2wayANOVA
lim = 80000;
%calculate1wayANOVA(ISI)
close all

figure
subplot(2,3,1)
polarhistogram(SFC_storage_m{1,1}, 18)
title('Control')
rlim([0 lim])
subplot(2,3,2)
polarhistogram(SFC_storage_m{2,1}, 18)
title('2 Week')
rlim([0 lim])
subplot(2,3,3)
polarhistogram(SFC_storage_m{3,1}, 18)
title('1 Month')
rlim([0 lim])
subplot(2,3,4)
polarhistogram(SFC_storage_m{4,1}, 18)
title('EE Control')
rlim([0 lim])
subplot(2,3,6)
polarhistogram(SFC_storage_m{5,1}, 18)
title('EE Stroke')
rlim([0 lim])
%%
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



