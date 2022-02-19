function [something, here] = calculate1wayANOVA(inputs)
% This code is super incomplete, but hopefully makes enough sense to turn
% into functioning code
labels = {'Ctrl','1MS','2WS'};
    rData1 = NaN(max('largest group'),3);
    lData1 = NaN(max('largest group'),3);
    
    rData1(1:n,1)  = data{1,2};
    rData1(1:n,2)  = data{2,2};
    rData1(1:n,3) = data{3,2};
    
       
    lData1(1:8,1)  = data{1,1};
    lData1(1:7,2)  = data{1,2};
    lData1(1:10,3) = data{1,3}

    
    [~,rT1,rS1] = anova1(rData1,labels,'off');
    [~,lT1,lS1] = anova1(lData1,labels,'off');
    
    [rC1,rM1,~,rNames1] = multcompare(rS1,'CType','bonferroni','Display','off');
    
    
    [lC1,lM1,~,lNames1] = multcompare(lS1,'CType','bonferroni','Display','off');
end