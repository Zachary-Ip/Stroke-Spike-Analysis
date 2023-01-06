function spec_out = calculateSpikeTriggeredSpectrum(ft_data, l_or_r)
is_unit = startsWith(ft_data.label, 'unit');
unit_labels = ft_data.label(is_unit);
electrode_labels = ft_data.label(~is_unit);

spec_cfg = [];
spec_cfg.method = 'mtmfft';
spec_cfg.foilim = [0, 15];
spec_cfg.timwin = [-1, 1]; % around each spike
spec_cfg.taper = 'dpss';
spec_cfg.feedback = 'no';
spec_cfg.spikechannel = unit_labels(l_or_r);  % assume left is first
spec_cfg.channel = electrode_labels(side2idxs(l_or_r));
spec_out = ft_spiketriggeredspectrum(spec_cfg, ft_data);
end