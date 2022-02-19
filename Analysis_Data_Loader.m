% Spike
tic
%% testing?
preload = 1;
%% initalize values
filepath = 'C:\Users\ipzach\Documents\Spiking Data';

cd(filepath)
animallist = dir;
recording_freq = 32000;
ds_factor = 32;
ds_freq = 1000;
animal_names = [];

% Create variables which can be fed to stats later

FR_storage_m   = cell(5,2);
ISI_storage_m  = cell(5,2);
STA_storage_m  = cell(5,2);
SFC_storage_m  = cell(5,2);
% spec_storage_m = cell(5,2);

% FR_storage_s   = cell(5,2);
% ISI_storage_s  = cell(5,2);
% STA_storage_s  = cell(5,2);
% SFC_storage_s  = cell(5,2);
% spec_storage_s = cell(5,2);

% Split animals into treatment groups
for group = 1:5
    switch group
        case 1
            group_name = 'C*'; % Control
        case 2
            group_name = '2WA*'; % 2WA
        case 3
            group_name = '1MA*'; % 1 Month
        case 4
            group_name = 'SE*'; % EE Control
        case 5
            group_name = 'AEE*'; % EE Stroke
    end
    animals_in_group = dir(group_name);
    % Run through each animal
    for i = 1:length(animals_in_group)
%         FR_current_m   = cell(1,2);
%         ISI_current_m  = cell(1,2);
%         STA_current_m  = cell(1,2);
%         SFC_current_m  = cell(1,2);
%         spec_current_m = cell(1,2);
        
%         FR_current_s   = cell(1,2);
%         ISI_current_s  = cell(1,2);
%         STA_current_s  = cell(1,2);
%         SFC_current_s  = cell(1,2);
        % spec_current_s = cell(1,2);
        
        % Step into each animals folder
        cd(animals_in_group(i).name);
        % Run through each hemisphere
        for j = 1:2
            if j == 1
                side = ' L';
                cd L_chan;
            end
            if j == 2
                side = ' R';
                cd R_chan;
            end
            channel_names = dir('CSC*').name;
            cd(channel_names)
            recording_folders = dir('REC*');
            full_ephys = [];
            multi_unit = [];
            ind_units = cell(3,3);
            time_adjust = 0;
            for k = 1:length(recording_folders)
                 cd(recording_folders(k).name)
                if preload
                    disp('Loading .mat data')
                    load('data.mat')
                else
                    disp('Reading Ephys')
                    ephys = read_neuralynx_ncs(dir('*.ncs').name);
                    disp('Reading Spikes')
                    spike = readNexFile(dir('*.nex').name);
                    save('data','ephys','spike')
                    toc
                end % if for data import
                multi_unit = [multi_unit; spike.neurons{1,1}.timestamps + time_adjust];
                for kk = 2:length(spike.neurons)
                    ind_units{kk-1,k} = spike.neurons{kk-1,1}.timestamps + time_adjust;
                end % kk
                
                full_ephys = [full_ephys reshape(ephys.dat, 1, [])];
                time_adjust = length(full_ephys)./recording_freq;
               cd ..
            end % k recording folders
            single_unit1 = [ind_units{1,1}; ind_units{1,2}; ind_units{1,3}];
            single_unit2 = [ind_units{2,1}; ind_units{2,2}; ind_units{2,3}];
            single_unit3 = [ind_units{3,1}; ind_units{3,2}; ind_units{3,3}];
            
            ds_ephys = downsample(full_ephys, ds_factor);
            ephys_time_idx = 1:length(ds_ephys);
            ephys_time_idx = ephys_time_idx./ds_freq;
            total_time = length(ds_ephys)./ ds_freq;
            % Analysis
            % Relevant variables for functions are:
            % ds_ephys - ephys downsampled to 1kHz
            % ephys_time_idx - ephys samples in seconds
            % (potentially) full_ephys - raw ephys at 32kHz
            
            % multi_unit - most consistent data we have
            % single_unit# - may be empty depending on the animal, handles
            % up to 3 units
            disp(['Analyzing ' animals_in_group(i).name side])
            multi-unit analysis
            [FR] = calculateFiringRate(multi_unit, total_time, ds_freq);
            [ISI] = calculateISI(multi_unit);
            [STA] = calculateSTA(multi_unit, ds_ephys, ds_freq);
            [spec] = calculateSpec(multi_unit,ds_ephys, ds_freq);
            bp_theta = bandpass(ds_ephys, [3, 7], recording_frequency);
            [SFC] = calculateSFC(multi_unit, ds_ephys, ds_freq);
            FR_current_m{1,j}    = [FR_current_m{1,j}; FR];
            ISI_current_m{1,j}  = [ISI_current_m{1,j}; ISI];
            STA_current_m{1,j}  = [STA_current_m{1,j}; STA];
%             spec_current_m{1,j} = cat(3,spec_current_m{1,j}, spec);
            SFC_current_m{1,j}  = [SFC_current_m{1,j}; SFC'];
            
%             toc
            % single unit analysis
            
           cd ..  
           cd ..
        end % hemispheres
        FR_storage_m{group,1} = [FR_storage_m{group,1}; FR_current_m{1,1}];
        FR_storage_m{group,2} = [FR_storage_m{group,2}; FR_current_m{1,2}];
        
        ISI_storage_m{group,1} = [ISI_storage_m{group,1}; ISI_current_m{1,1}];
        ISI_storage_m{group,2} = [ISI_storage_m{group,2}; ISI_current_m{1,2}];
        
        STA_storage_m{group,1} = [STA_storage_m{group,1}; STA_current_m{1,1}];
        STA_storage_m{group,2} = [STA_storage_m{group,2}; STA_current_m{1,2}];
        
        SFC_storage_m{group,1} = [SFC_storage_m{group,1}; SFC_current_m{1,1}];
        SFC_storage_m{group,2} = [SFC_storage_m{group,2}; SFC_current_m{1,2}];
        
        spec_storage_m{group,1} = cat(3,spec_storage_m{group,1}, spec_current_m{1,1});
        spec_storage_m{group,2} = cat(3,spec_storage_m{group,2}, spec_current_m{1,2});
        cd .. % step out of each animals folder
    end
    
end
%% save data
% cd 'C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts'
% save('spike_measures','FR_storage_m', 'ISI_storage_m','STA_storage_m','SFC_storage_m')
