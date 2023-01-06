function [out, types] = sortDataAndTypes(data, types)
assert(size(data, 1) == numel(types));
type_order = {'Control', '1M Strk', '2W Strk', 'EE Sham', 'EE Strk'};
type_order = type_order(ismember(type_order, types));  % maintain order, can't use intersect()
types = categorical(types, type_order, 'Ordinal', true);
[types, sortperm] = sort(types);

args = repmat({':'}, 1, ndims(data)-1);
out = data(sortperm, args{:});
end