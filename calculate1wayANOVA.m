function [stats] = calculate1wayANOVA(data)
labels = {'Ctrl','2WS','1MS'};
l_max = max([length(data{1,1}),length(data{3,1}),length(data{4,1})]);
r_max = max([length(data{1,2}),length(data{3,2}),length(data{4,2})]);

lData = NaN(l_max,3);
rData = NaN(r_max,3);

lData(1:length(data{1,1}),1) = data{1,1};
lData(1:length(data{3,1}),2) = data{3,1};
lData(1:length(data{4,1}),3) = data{4,1};

rData(1:length(data{1,2}),1) = data{1,2};
rData(1:length(data{3,2}),2) = data{3,2};
rData(1:length(data{4,2}),3) = data{4,2};

[stats.R_P,~,stats.R_S] = anova1(rData,labels,'off');
[stats.L_P,~,stats.L_S] = anova1(lData,labels,'off');

[stats.L_Comp,stats.L_Means,~,stats.L_Names] = multcompare(stats.L_S,'CType','bonferroni'); %,'Display','off');
[stats.R_Comp,stats.R_Means,~,stats.R_Names] = multcompare(stats.R_S,'CType','bonferroni'); %,'Display','off');
a = 1+1;
end