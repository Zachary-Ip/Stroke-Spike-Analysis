function [ppc, freq] = calculatePPC(ft_data, l_or_r)
spec_out = calculateSpikeTriggeredSpectrum(ft_data, l_or_r);
ppc = ft_connectivity_ppc(spec_out.fourierspctrm{1});
freq = spec_out.freq;
end