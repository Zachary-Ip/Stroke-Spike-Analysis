%% initalize Parameters
tic
filepath = 'C:\Users\ipzach\Documents\Spiking Data';
animallist = dir;
recording_freq = 32000;
ds_factor = 32;
ds_freq = 1000;
animal_names = [];
preload = 1;

for group = 1:5
    cd(filepath)
    % Create variables which can be fed to stats later
    PSD_storage = cell(1,2);
    % Split animals into treatment groups
    switch group
        case 1
            group_name = 'C*'; % Control
            save_name = 'Control';
        case 2
            group_name = 'SE*'; % EE Control
            save_name = 'EEControl';
        case 3
            group_name = '2WA*'; % 2WA
            save_name = 'TwoWeek';
        case 4
            group_name = '1MA*'; % 1 Month
            save_name = 'OneMonth';
        case 5
            group_name = 'AEE*'; % EE Stroke
            save_name = 'EEOneMonth';
    end
    
    animals_in_group = dir(group_name);
    
    % Run through each animal
    for i = 1:length(animals_in_group)
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
                for kk = 1:length(spike.neurons)
                    ind_units{kk,k} = spike.neurons{kk,1}.timestamps + time_adjust;
                end % kk
                full_ephys = [full_ephys reshape(ephys.dat, 1, [])];
                time_adjust = length(full_ephys)./recording_freq;
                cd ..
            end % k recording folders
            ds_ephys = downsample(full_ephys, ds_factor);
            norm_ephys = normalize(ds_ephys);
          
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
            %% single units
            num_units = max(sum(~cellfun(@isempty, ind_units), 1));
            
            for ii = 1:num_units
                single_unit = [ind_units{ii,1}; ind_units{ii,2}; ind_units{ii,3}];
                [PSD,f] = calculatePSD(single_unit, ds_ephys, ds_freq);
                % Save Analysis
               PSD_storage{1,j}  = [PSD_storage{1,j}; PSD];
            end % num units
            cd ..
            cd ..
        end % hemispheres
        cd .. % step out of each animals folder
    end
    
    %% save data
    cd 'C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts'   
    save([save_name '_PSD'],'PSD_storage','f')
end