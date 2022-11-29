function aligned = align(data, idxs, window_size)
delta = floor(window_size / 2);
offset = 1-mod(window_size, 2);
s = size(data);
idxs = int64(round(idxs));
idxs = idxs(and(delta < idxs, idxs < s(1)-delta+offset));  % drop idxs outside of range
data = reshape(data, s(1), []);
aligned = zeros(window_size, prod(s(2:end)), numel(idxs), class(data));
for i=1:numel(idxs)
    idx = idxs(i);
    aligned(:, :, i) = data(idx-delta:idx+delta-offset, :);
end
s(1) = window_size;
s(end+1) = numel(idxs);
aligned = reshape(aligned, s);
end