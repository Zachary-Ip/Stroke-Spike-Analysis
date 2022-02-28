function [stats] = calculate1wayANOVA(data)
labels = {'Ctrl','2WS','1MS'};
rData1 = NaN(max('largest group'),3);
lData1 = NaN(max('largest group'),3);

rData1(1:length(data{1,2}),1) = data{1,2};
rData1(1:length(data{3,2}),2) = data{3,2};
rData1(1:length(data{4,2}),3) = data{4,2};

lData1(1:length(data{1,1}),1) = data{1,1};
lData1(1:length(data{3,1}),2) = data{3,1};
lData1(1:length(data{4,1}),3) = data{4,1};

[stats.R_P,~,stats.R_S] = anova1(rData1,labels,'off');
[stats.L_P,~,stats.L_S] = anova1(lData1,labels,'off');

[stats.L_Comps,stats.L_Means,~,stats.L_Names] = multcompare(stats.L_S,'CType','bonferroni'); %,'Display','off');
[stats.R_Comps,stats.R_Means,~,stats.R_Names] = multcompare(stats.R_S,'CType','bonferroni'); %,'Display','off');

% means_r = stats_r{:,2};
% std_errs_r = stats_r{:,3};
% 
% means_l = stats_l{:,2};
% std_errs_l = stats_l{:,3};

end