# Spike and Spike-Field Analysis for Rat EE/Stroke Data

1. Create an untracked `config.m` file in the root directory of the project which defines the following variables: `root_dir`, `cache_dir`, and `plot_dir`. `root_dir` should be the location of the Z drive, so on the lab Windows computers, it should be "Z:". `cache_dir` will be where data copies from the file server are stored for faster access, and so it should be local to the computer and user-specific. `plot_dir` is where plots are saved. Finally, this file should add Fieldtrip to the Matlab path if it isn't already. An example file might look like this:
   ```matlab
   root_dir = "Z:";
   cache_dir = "~/Documents/cache/Stroke-Spike-Analysis";
   plot_dir = "~/Documents/plots/Stroke-Spike-Analysis";
   addpath(fullfile(matlabroot, 'toolbox/fieldtrip'));
   ```
2. Run the init script
3. Run the data caching function, `cacheData` as `cacheData(data_dir, cache_dir)` (only necessary to do this once).
4. You should be able to run any notebook in the `notebooks` directory now.
