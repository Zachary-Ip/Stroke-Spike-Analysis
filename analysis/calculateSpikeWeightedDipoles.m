function [mean_dipole, stderr_dipole, types] = calculateSpikeWeightedDipoles(matrices, num_spikes, animal_info)
    dipoles = cellfun(@(c) max(c, [], 'all') - min(c, [], 'all'), matrices);
    [grouped_dipoles, types] = groupByAnimalType(dipoles, animal_info);
    [grouped_spike_counts, types_spike] = groupByAnimalType(num_spikes, animal_info);
    [mean_dipole, stderr_dipole] = deal(NaN(numel(types), size(matrices, 2)));
    for i=1:numel(types)
        dipoles = grouped_dipoles{i};
        spike_counts = grouped_spike_counts{strcmp(types{i}, types_spike)};
        n = sum(spike_counts, 1);
        weights = spike_counts ./ n;
        % matlab's weighted std function is too limited to handle this very
        % basic use case
        mu = sum(dipoles .* weights, 1);
        mean_dipole(i, :) = mu;
        stderr_dipole(i, :) = sum((dipoles - mu) .^ 2, 1) ./ sqrt(n);  % assume it's normal (for now)
    end
end
