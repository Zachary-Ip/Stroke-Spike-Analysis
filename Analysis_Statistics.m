% Analysis_Stats
mFR = cell(5,2);
mISI = cell(5,2);
mSFC = cell(5,2);
mSFC_a = cell(5,2);
mSFC_b = cell(5,2);
mSFC_d = cell(5,2);
mSFC_hg = cell(5,2);
mSFC_g = cell(5,2);
mSFC_t = cell(5,2);
%mSpec = cell(5,2);

mSTA_a = cell(5,2);
mSTA_b = cell(5,2);
mSTA_d = cell(5,2);
mSTA_g = cell(5,2);
mSTA_hg = cell(5,2);
mSTA = cell(5,2);
mSTA_t = cell(5,2);

mSTAmean_a = cell(5,2);
mSTAmean_b = cell(5,2);
mSTAmean_d = cell(5,2);
mSTAmean_g = cell(5,2);
mSTAmean_hg = cell(5,2);
mSTAmean = cell(5,2);
mSTAmean_t = cell(5,2);

sFR = cell(5,2);
sISI = cell(5,2);
sSFC = cell(5,2);
sSFC_a = cell(5,2);
sSFC_b = cell(5,2);
sSFC_d = cell(5,2);
sSFC_g = cell(5,2);
sSFC_hg = cell(5,2);
sSFC_t = cell(5,2);

% sSpec = cell(5,2);

sSTA_a = cell(5,2);
sSTA_b = cell(5,2);
sSTA_d = cell(5,2);
sSTA_g = cell(5,2);
sSTA_hg = cell(5,2);
sSTA = cell(5,2);
sSTA_t = cell(5,2);

sSTAmean_a = cell(5,2);
sSTAmean_b = cell(5,2);
sSTAmean_d = cell(5,2);
sSTAmean_g = cell(5,2);
sSTAmean_hg = cell(5,2);
sSTAmean = cell(5,2);
sSTAmean_t = cell(5,2);

for i = 1:5
    switch i
        case 1
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\Control_multiunit_measures.mat')
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\Control_singleunit_measures.mat')
        case 2
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEControl_multiunit_measures.mat')
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEControl_singleunit_measures.mat')
        case 3
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\TwoWeek_multiunit_measures.mat')
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\TwoWeek_singleunit_measures.mat')
        case 4
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\OneMonth_multiunit_measures.mat')
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\OneMonth_singleunit_measures.mat')
        case 5
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEOneMonth_multiunit_measures.mat')
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEOneMonth_singleunit_measures.mat')
    end
    %Multi unit aggregator
    mFR{i,1}         = mFR_storage{1,1};                    mFR{i,2} = mFR_storage{1,2};
    mISI{i,1}        = mISI_storage{1,1};                  mISI{i,2} = mISI_storage{1,2};
    mSFC{i,1}        = mSFC_storage{1,1};                  mSFC{i,2} = mSFC_storage{1,2};
    
    mSTA_a{i,1}      = mSTA_a_storage{1,1};              mSTA_a{i,2} = mSTA_a_storage{1,2};
    mSTA_b{i,1}      = mSTA_b_storage{1,1};              mSTA_b{i,2} = mSTA_b_storage{1,2};
    mSTA_d{i,1}      = mSTA_d_storage{1,1};              mSTA_d{i,2} = mSTA_d_storage{1,2};
    mSTA_g{i,1}      = mSTA_g_storage{1,1};              mSTA_g{i,2} = mSTA_g_storage{1,2};
    mSTA_hg{i,1}     = mSTA_hg_storage{1,1};            mSTA_hg{i,2} = mSTA_hg_storage{1,2};
    mSTA{i,1}        = mSTA_storage{1,1};                  mSTA{i,2} = mSTA_storage{1,2};
    mSTA_t{i,1}      = mSTA_t_storage{1,1};              mSTA_t{i,2} = mSTA_t_storage{1,2};
    
    mSTAmean_a{i,1}  = mSTAmean_a_storage{1,1};     mSTAmean_a{i,2} =  mSTAmean_a_storage{1,2};
    mSTAmean_b{i,1}  = mSTAmean_b_storage{1,1};      mSTAmean_b{i,2} = mSTAmean_b_storage{1,2};
    mSTAmean_d{i,1}  = mSTAmean_d_storage{1,1};      mSTAmean_b{i,2} = mSTAmean_b_storage{1,2};
    mSTAmean_g{i,1}  = mSTAmean_g_storage{1,1};     mSTAmean_b{i,2} = mSTAmean_b_storage{1,2};
    mSTAmean_hg{i,1} = mSTAmean_hg_storage{1,1};    mSTAmean_hg{i,2} = mSTAmean_hg_storage{1,2};
    mSTAmean{i,1}    = mSTAmean_storage{1,1};          mSTAmean{i,2} = mSTAmean_storage{1,2};
    mSTAmean_t{i,1}  = mSTAmean_t_storage{1,1};      mSTAmean_t{i,2} = mSTAmean_t_storage{1,2};
    
    % Single unit aggregator
    sFR{i,1}         = sFR_storage{1,1};                   sFR{i,2} = sFR_storage{1,2};
    sISI{i,1}        = sISI_storage{1,1};                  sISI{i,2} = sISI_storage{1,2};
    sSFC{i,1}        = sSFC_storage{1,1};                  sSFC{i,2} = sSFC_storage{1,2};
    
    sSTA_a{i,1}      = sSTA_a_storage{1,1};              sSTA_a{i,2} = sSTA_a_storage{1,2};
    sSTA_b{i,1}      = sSTA_b_storage{1,1};              sSTA_b{i,2} = sSTA_b_storage{1,2};
    sSTA_d{i,1}      = sSTA_d_storage{1,1};              sSTA_d{i,2} = sSTA_d_storage{1,2};
    sSTA_g{i,1}      = sSTA_g_storage{1,1};              sSTA_g{i,2} = sSTA_g_storage{1,2};
    sSTA_hg{i,1}     = sSTA_hg_storage{1,1};             sSTA_hg{i,2} = sSTA_hg_storage{1,2};
    sSTA{i,1}        = sSTA_storage{1,1};                sSTA{i,2} = sSTA_storage{1,2};
    sSTA_t{i,1}      = sSTA_t_storage{1,1};              sSTA_t{i,2} = sSTA_t_storage{1,2};
    
    sSTAmean_a{i,1}  = sSTAmean_a_storage{1,1};     sSTAmean_a{i,2} =  sSTAmean_a_storage{1,2};
    sSTAmean_b{i,1}  = sSTAmean_b_storage{1,1};      sSTAmean_b{i,2} = sSTAmean_b_storage{1,2};
    sSTAmean_d{i,1}  = sSTAmean_d_storage{1,1};      sSTAmean_b{i,2} = sSTAmean_b_storage{1,2};
    sSTAmean_g{i,1}  = sSTAmean_g_storage{1,1};     sSTAmean_b{i,2} = sSTAmean_b_storage{1,2};
    sSTAmean_hg{i,1} = sSTAmean_hg_storage{1,1};    sSTAmean_hg{i,2} = sSTAmean_hg_storage{1,2};
    sSTAmean{i,1}    = sSTAmean_storage{1,1};          sSTAmean{i,2} = sSTAmean_storage{1,2};
    sSTAmean_t{i,1}  = sSTAmean_t_storage{1,1};      sSTAmean_t{i,2} = sSTAmean_t_storage{1,2};
end
%% Separate SFC frequency bands
low = [0.1,4,7,13,30,62];
hi    = [3,7,13,30,58,200];
cellfun(@(v) mean(v(:,idxs),2), sSFC, 'UniformOutput',false)
for j = 1:6
    idxs = find(SFC_freq >= low(j) & SFC_freq <= hi(j));
    switch j
        case 1
            sSFC_d = cellfun(@(v) mean(v(:,idxs),2), sSFC, 'UniformOutput',false);
            mSFC_d = cellfun(@(v) mean(v(:,idxs),2), mSFC, 'UniformOutput',false);
        case 2
            sSFC_t = cellfun(@(v) mean(v(:,idxs),2), sSFC, 'UniformOutput',false);
            mSFC_t = cellfun(@(v) mean(v(:,idxs),2), mSFC, 'UniformOutput',false);
        case 3
            sSFC_a = cellfun(@(v) mean(v(:,idxs),2), sSFC, 'UniformOutput',false);
            mSFC_a = cellfun(@(v) mean(v(:,idxs),2), mSFC, 'UniformOutput',false);
        case 4
            sSFC_b = cellfun(@(v) mean(v(:,idxs),2), sSFC, 'UniformOutput',false);
            mSFC_b = cellfun(@(v) mean(v(:,idxs),2), mSFC, 'UniformOutput',false);
        case 5
            sSFC_g = cellfun(@(v) mean(v(:,idxs),2), sSFC, 'UniformOutput',false);
            mSFC_g = cellfun(@(v) mean(v(:,idxs),2), mSFC, 'UniformOutput',false);
        case 6
            sSFC_hg = cellfun(@(v) mean(v(:,idxs),2), sSFC, 'UniformOutput',false);
            mSFC_hg = cellfun(@(v) mean(v(:,idxs),2), mSFC, 'UniformOutput',false);
    end
end
%% multi unit 1way ANOVA Stats
% Non frequency delineated
disp('FR')
mFR_stats1 = calculate1wayANOVA(mFR);
disp('ISI')
mISI_stats1 = calculate1wayANOVA(mISI);
disp('Spec')
mSpec_stats1 = calculate1wayANOVA(mSpec);
% STA
disp('STA')
STA_stats1 = calculate1wayANOVA(mSTA);
disp('Alpha')
STA_a_stats1 = calculate1wayANOVA(mSTA_a);
disp('Beta')
STA_b_stats1 = calculate1wayANOVA(mSTA_b);
disp('Delta')
STA_d_stats1 = calculate1wayANOVA(mSTA_d);
disp('Theta')
STA_t_stats1 = calculate1wayANOVA(mSTA_t);
disp('Gamma')
STA_g_stats1 = calculate1wayANOVA(mSTA_g);
disp('High Gamma')
STA_hg_stats1 = calculate1wayANOVA(mSTA_hg);

% SFC
disp('Alpha')
mSFC_a_stats1 = calculate1wayANOVA(mSFC_a);
disp('Beta')
mSFC_b_stats1 = calculate1wayANOVA(mSFC_b);
disp('Delta')
mSFC_d_stats1 = calculate1wayANOVA(mSFC_d);
disp('Theta')
mSFC_t_stats1 = calculate1wayANOVA(mSFC_t);
disp('Gamma')
mSFC_g_stats1 = calculate1wayANOVA(mSFC_g);
disp('High Gamma')
mSFC_hg_stats1 = calculate1wayANOVA(mSFC_hg);

%% multi unit 2way ANOVA stats
% Non frequency delineated
disp('FR')
mFR_stats2    = calculate2wayANOVA(mFR);
disp('ISI')
mISI_stats2   = calculate2wayANOVA(mISI);
disp('Spec')
mSpec_stats2  =calculate2wayANOVA(mSpec);
% STA
disp('STA')
mSTA_stats2   = calculate2wayANOVA(mSTA);
disp('Alpha')
mSTA_a_stats2 = calculate2wayANOVA(mSTA_a);
disp('Beta')
mSTA_b_stats2 = calculate2wayANOVA(mSTA_b);
disp('Delta')
mSTA_d_stats2 = calculate2wayANOVA(mSTA_d);
disp('Theta')
mSTA_t_stats2 = calculate2wayANOVA(mSTA_t);
disp('Gamma')
mSTA_g_stats2 = calculate2wayANOVA(mSTA_g);
disp('High Gamma')
mSTA_hg_stats2 = calculate2wayANOVA(mSTA_hg);
% SFC
disp('Alpha')
mSFC_a_stats1 = calculate2wayANOVA(mSFC_a);
disp('Beta')
mSFC_b_stats1 = calculate2wayANOVA(mSFC_b);
disp('Delta')
mSFC_d_stats1 = calculate2wayANOVA(mSFC_d);
disp('Theta')
mSFC_t_stats1 = calculate2wayANOVA(mSFC_t);
disp('Gamma')
mSFC_g_stats1 = calculate2wayANOVA(mSFC_g);
disp('High Gamma')
mSFC_hg_stats1 = calculate2wayANOVA(mSFC_hg);
%% single unit 1way ANOVA Stats
% Non frequency delineated
disp('FR')
sFR_stats1 = calculate1wayANOVA(sFR);
disp('ISI')
sISI_stats1 = calculate1wayANOVA(sISI);
disp('Spec')
sSpec_stats1 = calculate1wayANOVA(sSpec);
% STA
disp('STA')
sSTA_stats1 = calculate1wayANOVA(sSTA);
disp('Alpha')
sSTA_a_stats1 = calculate1wayANOVA(sSTA_a);
disp('Beta')
sSTA_b_stats1 = calculate1wayANOVA(sSTA_b);
disp('Delta')
sSTA_d_stats1 = calculate1wayANOVA(sSTA_d);
disp('Theta')
sSTA_t_stats1 = calculate1wayANOVA(sSTA_t);
disp('Gamma')
sSTA_g_stats1 = calculate1wayANOVA(sSTA_g);
disp('High Gamma')
sSTA_hg_stats1 = calculate1wayANOVA(sSTA_hg);

% SFC
disp('Alpha')
sSFC_a_stats1 = calculate1wayANOVA(sSFC_a);
disp('Beta')
sSFC_b_stats1 = calculate1wayANOVA(sSFC_b);
disp('Delta')
sSFC_d_stats1 = calculate1wayANOVA(sSFC_d);
disp('Theta')
sSFC_t_stats1 = calculate1wayANOVA(sSFC_t);
disp('Gamma')
sSFC_g_stats1 = calculate1wayANOVA(sSFC_g);
disp('High Gamma')
sSFC_hg_stats1 = calculate1wayANOVA(sSFC_hg);

%% single unit 2way ANOVA stats
% Non frequency delineated
disp('FR')
sFR_stats2    = calculate2wayANOVA(sFR);
disp('ISI')
sISI_stats2   = calculate2wayANOVA(sISI);
disp('Spec')
sSpec_stats2  =calculate2wayANOVA(sSpec);
% STA
disp('STA')
sSTA_stats2   = calculate2wayANOVA(sSTA);
disp('Alpha')
sSTA_a_stats2 = calculate2wayANOVA(sSTA_a);
disp('Beta')
sSTA_b_stats2 = calculate2wayANOVA(sSTA_b);
disp('Delta')
sSTA_d_stats2 = calculate2wayANOVA(sSTA_d);
disp('Theta')
sSTA_t_stats2 = calculate2wayANOVA(sSTA_t);
disp('Gamma')
sSTA_g_stats2 = calculate2wayANOVA(sSTA_g);
disp('High Gamma')
sSTA_hg_stats2 = calculate2wayANOVA(sSTA_hg);
% SFC
disp('Alpha')
sSFC_a_stats1 = calculate2wayANOVA(sSFC_a);
disp('Beta')
sSFC_b_stats1 = calculate2wayANOVA(sSFC_b);
disp('Delta')
sSFC_d_stats1 = calculate2wayANOVA(sSFC_d);
disp('Theta')
sSFC_t_stats1 = calculate2wayANOVA(sSFC_t);
disp('Gamma')
sSFC_g_stats1 = calculate2wayANOVA(sSFC_g);
disp('High Gamma')
sSFC_hg_stats1 = calculate2wayANOVA(sSFC_hg);
%%
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



