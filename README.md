
# Spike and Spike-Field Analysis for Rat EE/Stroke Data
Las edited by Zachary Ip (ip.zachary.t@gmail.com) 3/7/23.

This repository is expected to be used in conjunction with [spectral-analysis-tools](https://github.com/Zachary-Ip/spectral-analysis-tools), and [utils-toolbox](https://github.com/Zachary-Ip/utils-toolbox). Code will not run without those repositories on path. This repository was developed in MATLAB, and requires a license with Signal processing toolbox among others.
This code was developed to process a dataset collected by Jialing Liu (Jialing.liu@ucsf.edu). Data was collected using 16-site and occasionally 32-site linear depth electrodes bilaterally in rats after distal middle cerebral artery stroke (dMCAO) in the ipsilesional (left) hemisphere. 

Code was developed independently by by Zachary Ip (ip.zachary.t@gmail.com) and Ilse Dippenaar (ilsedipp@uw.edu). There is some overlap in analysis done, but the most up to date code was performed by Ilse. 

#### For Zach's code:
Code is run from the main script `Analysis_Data_Loader`, which saves outputs to file in `/Documents\MATLAB\output\Spike Sorting Scripts/`. From there, `Analysis_Statistics` takes over and runs statistical comparisons between groups. Subfunctions are called for both scripts using the naming scheme `calculate_variable`. 
#### For Ilse's code:
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
