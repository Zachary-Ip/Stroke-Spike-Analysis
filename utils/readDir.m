function out = readDir(s)
out = dir(s);
out = out(~cellfun(@(f) any(strcmp(f, {'.', '..'})), {out.name}));
end