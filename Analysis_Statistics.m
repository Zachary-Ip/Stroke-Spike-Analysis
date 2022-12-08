% Analysis_Stats
addpath('C:\Users\ipzach\Documents\MATLAB\spectral-analysis-tools')
FR = cell(5,2);
ISI = cell(5,2);
SFC = cell(5,2);
SFC_a = cell(5,2);
SFC_b = cell(5,2);
SFC_d = cell(5,2);
SFC_g = cell(5,2);
SFC_hg = cell(5,2);
SFC_t = cell(5,2);

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
            load('C:\Users\ipzach\Documents\MATLAB\output\Spike Sorting Scripts\Control_singleunit_measures.mat')
        case 2
            load('C:\Users\ipzach\Documents\MATLAB\output\Spike Sorting Scripts\EEControl_singleunit_measures.mat')
        case 3
            load('C:\Users\ipzach\Documents\MATLAB\output\Spike Sorting Scripts\TwoWeek_singleunit_measures.mat')
        case 4
            load('C:\Users\ipzach\Documents\MATLAB\output\Spike Sorting Scripts\OneMonth_singleunit_measures.mat')
        case 5
            load('C:\Users\ipzach\Documents\MATLAB\output\Spike Sorting Scripts\EEOneMonth_singleunit_measures.mat')
    end

    FR{i,1}         = FR_storage{1,1};                   FR{i,2} = FR_storage{1,2};
    ISI{i,1}        = ISI_storage{1,1};                  ISI{i,2} = ISI_storage{1,2};
    SFC{i,1}        = SFC_storage{1,1};                  SFC{i,2} = SFC_storage{1,2};
    %Spec{i,1}       = Spec_storage{1,1};                Spec{i,2} = Spec_storage{1,2};
    
    STA_a{i,1}      = STA_a_storage{1,1};              STA_a{i,2} = STA_a_storage{1,2};
    STA_b{i,1}      = STA_b_storage{1,1};              STA_b{i,2} = STA_b_storage{1,2};
    STA_d{i,1}      = STA_d_storage{1,1};              STA_d{i,2} = STA_d_storage{1,2};
    STA_g{i,1}      = STA_g_storage{1,1};              STA_g{i,2} = STA_g_storage{1,2};
    STA_hg{i,1}     = STA_hg_storage{1,1};             STA_hg{i,2} = STA_hg_storage{1,2};
    STA{i,1}        = STA_storage{1,1};                STA{i,2} = STA_storage{1,2};
    STA_t{i,1}      = STA_t_storage{1,1};              STA_t{i,2} = STA_t_storage{1,2};
    
    STAmean_a{i,1}  = STAmean_a_storage{1,1};     STAmean_a{i,2} =  STAmean_a_storage{1,2};
    STAmean_b{i,1}  = STAmean_b_storage{1,1};      STAmean_b{i,2} = STAmean_b_storage{1,2};
    STAmean_d{i,1}  = STAmean_d_storage{1,1};      STAmean_b{i,2} = STAmean_b_storage{1,2};
    STAmean_g{i,1}  = STAmean_g_storage{1,1};     STAmean_b{i,2} = STAmean_b_storage{1,2};
    STAmean_hg{i,1} = STAmean_hg_storage{1,1};    STAmean_hg{i,2} = STAmean_hg_storage{1,2};
    STAmean{i,1}    = STAmean_storage{1,1};          STAmean{i,2} = STAmean_storage{1,2};
    STAmean_t{i,1}  = STAmean_t_storage{1,1};      STAmean_t{i,2} = STAmean_t_storage{1,2};
end
%% Separate SFC frequency bands
low = [0.1,4,7,13,30,62];
hi    = [3,7,13,30,58,200];
for j = 1:6
    idxs = find(SFC_freq >= low(j) & SFC_freq <= hi(j));
    switch j
        case 1
            SFC_d = cellfun(@(v) mean(v(:,idxs),2), SFC, 'UniformOutput',false);
        case 2
            SFC_t = cellfun(@(v) mean(v(:,idxs),2), SFC, 'UniformOutput',false);
        case 3
            SFC_a = cellfun(@(v) mean(v(:,idxs),2), SFC, 'UniformOutput',false);
        case 4
            SFC_b = cellfun(@(v) mean(v(:,idxs),2), SFC, 'UniformOutput',false);
        case 5
            SFC_g = cellfun(@(v) mean(v(:,idxs),2), SFC, 'UniformOutput',false);
        case 6
            SFC_hg = cellfun(@(v) mean(v(:,idxs),2), SFC, 'UniformOutput',false);
    end
end

%% 1way ANOVA Stats
disp('single unit 1way')
% Non frequency delineated
disp('FR')
sFR_stats1 = calculate1wayANOVA(FR);
sFR_vals1 = vals4plot(FR, '1way');
figure
subplot(1,2,1)
plot_box(sFR_vals1.L_vals, sFR_stats1.L_Comp, 1)
title('Ipsi Firing Rate')

subplot(1,2,2)
plot_box(sFR_vals1.R_vals, sFR_stats1.R_Comp, 1)
title('Contra Firing Rate')

%%
disp('ISI')
sISI_stats1 = calculate1wayANOVA(ISI);
sISI_vals1 = vals4plot(ISI, '1way');
figure
subplot(1,2,1)
plot_box(sISI_vals1.L_vals, sISI_stats1.L_Comp, 1)
title('Ipsi ISI')

subplot(1,2,2)
plot_box(sISI_vals1.R_vals, sISI_stats1.R_Comp, 1)
title('Contra ISI')
%%
disp('STA')
sSTA_stats1 = calculate1wayANOVA(STA);
sSTA_vals1 = vals4plot(STA, '1way');

figure
subplot(1,2,1)
plot_box(sSTA_vals1.L_vals, sSTA_stats1.L_Comp, 1)
title('Ipsi STA')

subplot(1,2,2)
plot_box(sSTA_vals1.R_vals, sSTA_stats1.R_Comp, 1)
title('Contra STA')
%%
disp('Alpha')
sSTA_a_stats1 = calculate1wayANOVA(STA_a);
sSTA_a_vals1 = vals4plot(STA_a, '1way');

figure
subplot(1,2,1)
plot_box(sSTA_a_vals1.L_vals, sSTA_a_stats1.L_Comp, 1)
title('Ipsi Alpha STA')

subplot(1,2,2)
plot_box(sSTA_a_vals1.R_vals, sSTA_a_stats1.R_Comp, 1)
title('Contra Alpha STA')
%%
disp('Beta')
sSTA_b_stats1 = calculate1wayANOVA(STA_b);
sSTA_b_vals1 = vals4plot(STA_b, '1way');
figure
subplot(1,2,1)
plot_box(sSTA_b_vals1.L_vals, sSTA_b_stats1.L_Comp, 1)
title('Ipsi Beta STA')

subplot(1,2,2)
plot_box(sSTA_b_vals1.R_vals, sSTA_b_stats1.R_Comp, 1)
title('Contra Beta STA')
%%
disp('Delta')
sSTA_d_stats1 = calculate1wayANOVA(STA_d);
sSTA_d_vals1 = vals4plot(STA_d, '1way');
figure
subplot(1,2,1)
plot_box(sSTA_d_vals1.L_vals, sSTA_d_stats1.L_Comp, 1)
title('Ipsi Delta STA')

subplot(1,2,2)
plot_box(sSTA_b_vals1.R_vals, sSTA_b_stats1.R_Comp, 1)
title('Contra Delta STA')
%%
disp('Theta')
sSTA_t_stats1 = calculate1wayANOVA(STA_t);
sSTA_t_vals1 = vals4plot(STA_t, '1way');
figure
subplot(1,2,1)
plot_box(sSTA_t_vals1.L_vals, sSTA_t_stats1.L_Comp, 1)
title('Ipsi Theta STA')

subplot(1,2,2)
plot_box(sSTA_t_vals1.R_vals, sSTA_t_stats1.R_Comp, 1)
title('Contra Theta STA')
%%
disp('Gamma')
sSTA_g_stats1 = calculate1wayANOVA(STA_g);
sSTA_g_vals1 = vals4plot(STA_g, '1way');
figure
subplot(1,2,1)
plot_box(sSTA_g_vals1.L_vals, sSTA_g_stats1.L_Comp, 1)
title('Ipsi Gamma STA')

subplot(1,2,2)
plot_box(sSTA_g_vals1.R_vals, sSTA_g_stats1.R_Comp, 1)
title('Contra Gamma STA')
%%
disp('High Gamma')
sSTA_hg_stats1 = calculate1wayANOVA(STA_hg);
sSTA_hg_vals1 = vals4plot(STA_hg, '1way');
figure
subplot(1,2,1)
plot_box(sSTA_hg_vals1.L_vals, sSTA_hg_stats1.L_Comp, 1)
title('Ipsi High Gamma STA')

subplot(1,2,2)
plot_box(sSTA_hg_vals1.R_vals, sSTA_hg_stats1.R_Comp, 1)
title('Contra High Gamma STA')
%%
% SFC
disp('SFC')
disp('Alpha')
sSFC_a_stats1 = calculate1wayANOVA(SFC_a);
sSFC_a_vals1 = vals4plot(SFC_a, '1way');
figure
subplot(1,2,1)
plot_box(sSFC_a_vals1.L_vals, sSFC_a_stats1.L_Comp, 1)
title('Ipsi Alpha SFC')

subplot(1,2,2)
plot_box(sSFC_a_vals1.R_vals, sSFC_a_stats1.R_Comp, 1)
title('Contra Alpha SFC')
%%
disp('Beta')
sSFC_b_stats1 = calculate1wayANOVA(SFC_b);
sSFC_b_vals1 = vals4plot(SFC_b, '1way');
figure
subplot(1,2,1)
plot_box(sSFC_b_vals1.L_vals, sSFC_b_stats1.L_Comp, 1)
title('Ipsi Beta SFC')

subplot(1,2,2)
plot_box(sSFC_b_vals1.R_vals, sSFC_b_stats1.R_Comp, 1)
title('Contra Beta SFC')
%%
disp('Delta')
sSFC_d_stats1 = calculate1wayANOVA(SFC_d);
sSFC_d_vals1 = vals4plot(SFC_d, '1way');
figure
subplot(1,2,1)
plot_box(sSFC_d_vals1.L_vals, sSFC_d_stats1.L_Comp, 1)
title('Ipsi Delta SFC')

subplot(1,2,2)
plot_box(sSFC_d_vals1.R_vals, sSFC_d_stats1.R_Comp, 1)
title('Contra Delta SFC')
%%
disp('Theta')
sSFC_t_stats1 = calculate1wayANOVA(SFC_t);
sSFC_t_vals1 = vals4plot(SFC_t, '1way');
figure
subplot(1,2,1)
plot_box(sSFC_t_vals1.L_vals, sSFC_t_stats1.L_Comp, 1)
title('Ipsi Theta SFC')

subplot(1,2,2)
plot_box(sSFC_t_vals1.R_vals, sSFC_t_stats1.R_Comp, 1)
title('Contra Theta SFC')
%%
disp('Gamma')
sSFC_g_stats1 = calculate1wayANOVA(SFC_g);
sSFC_g_vals1 = vals4plot(SFC_g, '1way');
figure
subplot(1,2,1)
plot_box(sSFC_g_vals1.L_vals, sSFC_g_stats1.L_Comp, 1)
title('Ipsi Gamma SFC')

subplot(1,2,2)
plot_box(sSFC_g_vals1.R_vals, sSFC_g_stats1.R_Comp, 1)
title('Contra Gamma SFC')
%%
disp('High Gamma')
sSFC_hg_stats1 = calculate1wayANOVA(SFC_hg);
sSFC_hg_vals1 = vals4plot(SFC_hg, '1way');
figure
subplot(1,2,1)
plot_box(sSFC_hg_vals1.L_vals, sSFC_hg_stats1.L_Comp, 1)
title('Ipsi High Gamma SFC')

subplot(1,2,2)
plot_box(sSFC_hg_vals1.R_vals, sSFC_hg_stats1.R_Comp, 1)
title('Contra High Gamma SFC')

%% single unit 2way ANOVA stats
disp('single unit 2way')
% Non frequency delineated
disp('FR')
sFR_stats2 = calculate2wayANOVA(FR);
sFR_vals2 = vals4plot(FR, '2way');
figure
subplot(1,2,1)
plot_box(sFR_vals2.L_vals, sFR_stats2.L_Comp, 2)
title('Ipsi Firing Rate')
% set(gca, 'Color',{'b','k','r','m'});
subplot(1,2,2)
plot_box(sFR_vals2.R_vals, sFR_stats2.R_Comp, 2)
title('Contra Firing Rate')
%%
disp('ISI')
sISI_stats2   = calculate2wayANOVA(ISI);
sISI_vals2 = vals4plot(ISI, '2way');
figure
subplot(1,2,1)
plot_box(sISI_vals2.L_vals, sISI_stats2.L_Comp, 2);
title('Ipsi ISI')
subplot(1,2,2)
plot_box(sISI_vals2.R_vals, sISI_stats2.R_Comp, 2);
title('Contra ISI')
% sSpec_stats2  =calculate2wayANOVA(sSpec);
%%  STA
disp('STA')
sSTA_stats2   = calculate2wayANOVA(STA);
sSTA_vals2 = vals4plot(STA, '2way');

%%
disp('Alpha')
sSTA_a_stats2 = calculate2wayANOVA(STA_a);
sSTA_a_vals2 = vals4plot(STA_a, '2way');
figure
subplot(1,2,1)
plot_box(sSTA_a_vals2.L_vals, sSTA_a_stats2.L_Comp, 2);
title('Ipsi Alpha STA')
subplot(1,2,2)
plot_box(sSTA_a_vals2.R_vals, sSTA_a_stats2.R_Comp, 2);
title('Contra Alpha STA')
%%
disp('Beta')
sSTA_b_stats2 = calculate2wayANOVA(STA_b);
sSTA_b_vals2 = vals4plot(STA_b, '2way');
figure
subplot(1,2,1)
plot_box(sSTA_b_vals2.L_vals, sSTA_b_stats2.L_Comp, 2);
title('Ipsi Beta STA')
subplot(1,2,2)
plot_box(sSTA_b_vals2.R_vals, sSTA_b_stats2.R_Comp, 2);
title('Contra Beta STA')
%%
disp('Delta')
sSTA_d_stats2 = calculate2wayANOVA(STA_d);
sSTA_d_vals2 = vals4plot(STA_d, '2way');
figure
subplot(1,2,1)
plot_box(sSTA_d_vals2.L_vals, sSTA_d_stats2.L_Comp, 2);
title('Ipsi Delta STA')
subplot(1,2,2)
plot_box(sSTA_d_vals2.R_vals, sSTA_d_stats2.R_Comp, 2);
title('Contra Delta STA')
%%
disp('Theta')
sSTA_t_stats2 = calculate2wayANOVA(STA_t);
sSTA_t_vals2 = vals4plot(STA_t, '2way');
figure
subplot(1,2,1)
plot_box(sSTA_t_vals2.L_vals, sSTA_t_stats2.L_Comp, 2);
title('Ipsi Theta STA')
subplot(1,2,2)
plot_box(sSTA_t_vals2.R_vals, sSTA_t_stats2.R_Comp, 2);
title('Contra Theta STA')
%%
disp('Gamma')
sSTA_g_stats2 = calculate2wayANOVA(STA_g);
sSTA_g_vals2 = vals4plot(STA_g, '2way');

figure
subplot(1,2,1)
plot_box(sSTA_g_vals2.L_vals, sSTA_g_stats2.L_Comp, 2);
title('Ipsi Gamma STA')
subplot(1,2,2)
plot_box(sSTA_g_vals2.R_vals, sSTA_g_stats2.R_Comp, 2);
title('Contra Gamma STA')
%%
disp('High Gamma')
sSTA_hg_stats2 = calculate2wayANOVA(STA_hg);
sSTA_hg_vals2 = vals4plot(STA_hg, '2way');
figure
subplot(1,2,1)
plot_box(sSTA_hg_vals2.L_vals, sSTA_hg_stats2.L_Comp, 2);
title('Ipsi High Gamma STA')
subplot(1,2,2)
plot_box(sSTA_hg_vals2.R_vals, sSTA_hg_stats2.R_Comp, 2);
title('Contra High Gamma STA')
%% SFC
disp('SFC')
disp('Alpha')
sSFC_a_stats2 = calculate2wayANOVA(SFC_a);
sSFC_a_vals2 = vals4plot(SFC_a, '2way');
figure
subplot(1,2,1)
plot_box(sSFC_a_vals2.L_vals, sSFC_a_stats2.L_Comp, 2);
title('Ipsi Alpha SFC')
subplot(1,2,2)
plot_box(sSFC_a_vals2.R_vals, sSFC_a_stats2.R_Comp, 2);
title('Contra Alpha SFC')
%%
disp('Beta')
sSFC_b_stats2 = calculate2wayANOVA(SFC_b);
sSFC_b_vals2 = vals4plot(SFC_b, '2way');
figure
subplot(1,2,1)
plot_box(sSFC_b_vals2.L_vals, sSFC_b_stats2.L_Comp, 2);
title('Ipsi Beta SFC')
subplot(1,2,2)
plot_box(sSFC_b_vals2.R_vals, sSFC_b_stats2.R_Comp, 2);
title('Contra Beta SFC')
%%
disp('Delta')
sSFC_d_stats2 = calculate2wayANOVA(SFC_d);
sSFC_d_vals2 = vals4plot(SFC_d, '2way');
figure
subplot(1,2,1)
plot_box(sSFC_d_vals2.L_vals, sSFC_d_stats2.L_Comp, 2);
title('Ipsi Delta SFC')
subplot(1,2,2)
plot_box(sSFC_d_vals2.R_vals, sSFC_d_stats2.R_Comp, 2);
title('Contra Delta SFC')
%%
disp('Theta')
sSFC_t_stats2 = calculate2wayANOVA(SFC_t);
sSFC_t_vals2 = vals4plot(SFC_t, '2way');
figure
subplot(1,2,1)
plot_box(sSFC_t_vals2.L_vals, sSFC_t_stats2.L_Comp, 2);
title('Ipsi Theta SFC')
subplot(1,2,2)
plot_box(sSFC_t_vals2.R_vals, sSFC_t_stats2.R_Comp, 2);
title('Contra Theta SFC')
%%
disp('Gamma')
sSFC_g_stats2 = calculate2wayANOVA(SFC_g);
sSFC_g_vals2 = vals4plot(SFC_g, '2way');
figure
subplot(1,2,1)
plot_box(sSFC_g_vals2.L_vals, sSFC_g_stats2.L_Comp, 2);
title('Ipsi Gamma SFC')
subplot(1,2,2)
plot_box(sSFC_g_vals2.R_vals, sSFC_g_stats2.R_Comp, 2);
title('Contra Gamma SFC')
%%
disp('High Gamma')
sSFC_hg_stats2 = calculate2wayANOVA(SFC_hg);
sSFC_hg_vals2 = vals4plot(SFC_hg, '2way');
figure
subplot(1,2,1)
plot_box(sSFC_hg_vals2.L_vals, sSFC_hg_stats2.L_Comp, 2);
title('Ipsi High Gamma SFC')
subplot(1,2,2)
plot_box(sSFC_hg_vals2.R_vals, sSFC_hg_stats2.R_Comp, 2);
title('Contra High Gamma SFC')
%% View spectrogram summaries
% precalc
% 
% LC = nanmean(sSpec{1,1},3);
% L2W = nanmean(sSpec{3,1},3);
% L1M = nanmean(sSpec{4,1},3);
% LEC = nanmean(sSpec{2,1},3);
% LE1M = nanmean(sSpec{5,1},3);
% 
% RC = nanmean(sSpec{1,2},3);
% R2W = nanmean(sSpec{3,2},3);
% R1M = nanmean(sSpec{4,2},3);
% REC = nanmean(sSpec{2,2},3);
% RE1M = nanmean(sSpec{5,2},3);
% %%
% highest = max([
%     max(LC), max(RC),...
%     max(L2W), max(R2W),...
%     max(L1M), max(R1M),...
%     max(LEC), max(REC),...
%     max(LE1M), max(RE1M)
%     ]);
% limits = [0 highest];
% 
% %%
% figure
% % 1 2 3 4 5 6
% % 7   9 10 12
% % 1
% subplot(2,6,1)
% h = pcolor(t,f,LC);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('L Control')
% caxis(limits)
% %2
% subplot(2,6,2)
% h = pcolor(t,f,L2W);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('L 2W')
% caxis(limits)
% %3
% subplot(2,6,3)
% h = pcolor(t,f,L1M);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('L 1M')
% caxis(limits)
% %7
% subplot(2,6,7)
% h = pcolor(t,f,LEC);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('L EEC')
% caxis(limits)
% %9
% subplot(2,6,9)
% h = pcolor(t,f,LE1M);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('L EE1M')
% caxis(limits)
% % 4
% subplot(2,6,4)
% h = pcolor(t,f,RC);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('R Control')
% caxis(limits)
% % %5
% subplot(2,6,5)
% h = pcolor(t,f,R2W);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('R 2W')
% caxis(limits)
% %6
% subplot(2,6,6)
% h = pcolor(t,f,R1M);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('R 1M')
% caxis(limits)
% %10
% subplot(2,6,10)
% h = pcolor(t,f,REC);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('R EEC')
% caxis(limits)
% %12
% subplot(2,6,12)
% h = pcolor(t,f,RE1M);
% set(h, 'EdgeColor', 'none');
% shading interp
% title('R EE1M')
% caxis(limits)
