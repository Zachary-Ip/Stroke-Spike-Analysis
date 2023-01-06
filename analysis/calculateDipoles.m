function [mean_dipole, stderr_dipole, types] = calculateDipoles(matrices, animal_info)
    dipoles = cellfun(@(c) max(c, [], 'all') - min(c, [], 'all'), matrices);
    [grouped_dipoles, types] = groupByAnimalType(dipoles, animal_info);
    [mean_dipole, stderr_dipole] = deal(NaN(numel(types), size(matrices, 2)));
    for i=1:numel(types)
        dipoles = grouped_dipoles{i};
        n = size(dipoles, 1);
        mean_dipole(i, :) = mean(dipoles, 1);
        stderr_dipole(i, :) = std(dipoles, 1) ./ sqrt(n-1);  % assume noramlity
    end
end
