function [stats] = calculate2wayANOVA(data)
% data = 5x2 cell
% Need to output two results, left hemisphere and right hemisphere
% compare across all 5 groups
l_vals = [data{1,1}; data{4,1}; data{2,1}; data{5,1}];
r_vals = [data{1,2}; data{4,2}; data{2,2}; data{5,2}];

l_group_labels = [repmat({'Control'}, length(data{1,1}),1); repmat({'Stroke'}, length(data{4,1}),1);
    repmat({'Control'}, length(data{2,1}),1); repmat({'Stroke'}, length(data{5,1}),1)];
l_treat_labels = [repmat({'Standard'}, length(data{1,1})+length(data{4,1}),1);
    repmat({'Enriched'}, length(data{2,1})+length(data{5,1}),1)];

r_group_labels = [repmat({'Control'}, length(data{1,2}),1); repmat({'Stroke'}, length(data{4,2}),1);
    repmat({'Control'}, length(data{2,2}),1); repmat({'Stroke'}, length(data{5,2}),1)];
r_treat_labels = [repmat({'Standard'}, length(data{1,2})+length(data{4,2}),1);
    repmat({'Enriched'}, length(data{2,2})+length(data{5,2}),1)];

[~,stats.L_Table,stats.L_S] = anovan(l_vals, {l_treat_labels, l_group_labels},'model','interaction','display','off');
[~,stats.R_Table,stats.R_S] = anovan(r_vals, {r_treat_labels, r_group_labels},'model','interaction','display','off');

[stats.L_Comp,stats.L_Means,~,stats.L_Names] = multcompare(stats.L_S,'Dimension',[1 2],'CType','bonferroni','Display','off');
[stats.R_Comp,stats.R_Means,~,stats.R_Names] = multcompare(stats.R_S,'Dimension',[1 2],'CType','bonferroni','Display','off');
a = 1+1;
end