function [out, types] = groupByAnimalType(data, animal_info)
assert(size(data, 1) == numel(animal_info))
types = sort(unique({animal_info.type}));
out = cell(numel(types), 1);
for i=1:numel(types)
    out{i} = data(strcmp(types{i}, {animal_info.type}), :);
end
[out, types] = sortDataAndTypes(out, types);
end