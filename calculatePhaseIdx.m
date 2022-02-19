function [PI] = calculatePhaseIdx(phase)
winsize = 2*pi/18;
position = 18*winsize-pi;
for i = 1:nbin
    find(phase <position(i)+winsize & phase >= position(i))



end