function spec_out = calculateSpikeTriggeredSpectrum(ft_data, l_or_r)
% This function calculates the spike-triggered spectrum for a given dataset.
% The dataset should be in FieldTrip format and contain both spike and
% continuous data. The spike-triggered spectrum is calculated using the
% multitaper method (MTM) in the frequency range [0, 15] Hz. The time window
% for each spectrum is set to [-1, 1] seconds around each spike. A DPSS
% (discrete prolate spheroidal sequence) taper is used. Feedback is turned
% off.
%
% Input:
%   ft_data: FieldTrip dataset containing both spike and continuous data
%   l_or_r: a string indicating whether to use the left or right side of the
%           data, should be either 'l' or 'r'
%
% Output:
%   spec_out: structure containing the spike-triggered spectrum, with fields
%             freq, label, and fftspctrm

% Find labels for the units (spike channels) and electrodes (continuous channels)
is_unit = startsWith(ft_data.label, 'unit');
unit_labels = ft_data.label(is_unit);
electrode_labels = ft_data.label(~is_unit);

% Set up configuration structure for ft_spiketriggeredspectrum
spec_cfg = [];
spec_cfg.method = 'mtmfft';
spec_cfg.foilim = [0, 15];
spec_cfg.timwin = [-1, 1]; % around each spike
spec_cfg.taper = 'dpss';
spec_cfg.feedback = 'no';

% Set the spike channel and continuous channels to use based on the input 'l_or_r'
spec_cfg.spikechannel = unit_labels(l_or_r);  % assume left is first
spec_cfg.channel = electrode_labels(side2idxs(l_or_r));

% Calculate the spike-triggered spectrum
spec_out = ft_spiketriggeredspectrum(spec_cfg, ft_data);
end