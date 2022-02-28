function [p,mean,std_err] = run2WayAnova(dist1,dist2)
%RUN2WAYANOVA Summary of this function goes here
%   Detailed explanation goes here
% QUESTIONS:
% Is this for a single stat? So we would be passing in stats for two
% different groups for the same stat? (i.e. std 1week SFC and std 2week
% SFC?)
% What do mean and std_err mean in this case?
p = anovan(dist1, dist2);
mean = ;
std_err = ;
end

