function [ISI] = calculateISI(spikes)
ISI = diff(spikes);
end

