function [ppc, freq] = calculatePPC(ft_data, l_or_r)
% This function calculates the phase-pairing consistency (PPC) for a given dataset.
% The dataset should be in FieldTrip format and contain both spike and
% continuous data. The PPC is calculated using the multitaper method (MTM) in
% the frequency range specified in the input dataset.
%
% Input:
%   ft_data: FieldTrip dataset containing both spike and continuous data
%   l_or_r: a string indicating whether to use the left or right side of the
%           data, should be either 'l' or 'r'
%
% Output:
%   ppc: matrix of PPC values, size (num_frequencies x num_channels)
%   freq: vector of frequencies, size (num_frequencies x 1)


% Calculate the spike-triggered spectrum for the specified side
spec_out = calculateSpikeTriggeredSpectrum(ft_data, l_or_r);

% Extract the Fourier transform of the spectrum and calculate the PPC
fourier_transform = spec_out.fourierspctrm{1};
ppc = ft_connectivity_ppc(fourier_transform);

% Extract the frequencies
freq = spec_out.freq;
end