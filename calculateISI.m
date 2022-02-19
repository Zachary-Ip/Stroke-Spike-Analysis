function [ISI] = calculateISI(spikes)
% disp(['spikes size 1 ' size(spikes, 1) side])
% disp(['spikes size 2 ' size(spikes, 2) side])
ISI = diff(spikes);
% disp(['ISI size 1 ' size(ISI, 1) side])
% disp(['ISI size 2 ' size(ISI, 2) side])
end

