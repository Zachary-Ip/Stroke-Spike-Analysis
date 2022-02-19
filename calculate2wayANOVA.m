function [something, here] = calculate2wayANOVA(data)
% data = 5x2 cell
% Need to output two results, left hemisphere and right hemisphere
% compare across all 5 groups
l_vals = [data{1,1} data{3,1} data{4,1} data{5,1}];
l_group_labels = {};
l_treat_labels = {};

r_vals = [data{1,2} data{3,2} data{4,2} data{5,2}];
r_group_labels = {};
r_treat_labels = {};
r_idx = 0;
l_idx = 
for i = [1 2:5]
    switch i
        case 1
            group = 'Control'; % Control
            treat = 'Standard';
        case 3
            group = 'Stroke'; %1MA
            treat = 'Standard';
        case 4
            group = 'Control'; % EE Control
            treat = 'Enriched';
        case 5
            group = 'Stroke'; % EE Stroke
            treat = 'Enriched';
    end
    
    l_group_labels = [l_group_labels repmat(group, length(data{i,1})];
    l_treat_labels = [l_group_labels repmat(treat, length(data{i,1})];
    
    r_group_labels = [r_group_labels repmat(group, length(data{i,2})];
    r_treat_labels = [r_group_labels repmat(treat, length(data{i,2})];
end
[~,L_T,L_S] = anovan(l_vals, {l_treat_labels, l_group_labels},'model','interaction','display','off');
[~,R_T,R_S] = anovan(r_vals, {r_treat_labels, r_group_labels},'model','interaction','display','off');

[L_C,L_M,~,L_N] = multcompare(L_S,'Dimension',[1 2],'CType','bonferroni','Display','off');
[R_C,R_M,~,R_N] = multcompare(R_S,'Dimension',[1 2],'CType','bonferroni','Display','off');
end