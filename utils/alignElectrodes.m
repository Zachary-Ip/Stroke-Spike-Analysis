function out = alignElectrodes(data, animal_info, varargin)
assert(iscell(data))
assert(size(data, 1) == numel(animal_info))

p = inputParser;
f = fieldnames(animal_info);
f = f(startsWith(f, {'L', 'R'}));
addParameter(p, 'to', 'L_pyramidal_chan', @(x) any(validatestring(x, f)))
parse(p, varargin{:});

offset = cat(1, animal_info.(p.Results.to));
s = cellfun(@(c) size(c, 1), data);
idxs = (1+max(offset)):min(s+offset, [], 'all');
out = cell(size(data));
for i=1:size(data, 2)
    for j=1:size(data, 1)
        out{j,i} = data{j,i}(idxs - offset(j), :);
    end
end
end