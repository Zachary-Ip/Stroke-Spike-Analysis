% Spike

%% testing?
test = 0;
%% initalize values
filepath = 'C:\Users\ipzach\Documents\Spiking Data';
if test
    disp('Reading Ephys')
    test_ephys = read_neuralynx_ncs('test.ncs');
    disp('Reading Spikes')
    test_spike = readNexFile('test.nex');
end
cd(filepath)
animallist = dir;
recording_freq = 32000;
ds_factor = 32;
ds_freq = 1000;
animal_names = [];

% Split animals into treatment groups
for groups = 3 % 1:5
    switch groups
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
        animal_storage_variable = [];
        % Step into each animals folder
        cd(animals_in_group(i).name);
        % Run through each hemisphere
        for j = 1 % :2
            if j == 1
                cd L_chan;
            end
            if j == 2
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
                if test
                    ephys = test_ephys;
                    spike = test_spike;
                else
                    cd(recording_folders(k).name)
                    disp('Reading Ephys')
                    ephys = read_neuralynx_ncs(dir('*.ncs').name);
                    disp('Reading Spikes')
                    spike = readNexFile(dir('*.nex').name);
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
            
            % Analysis
            % Relevant variables for functions are:
            % ds_ephys - ephys downsampled to 1kHz
            % ephys_time_idx - ephys samples in seconds
            % (potentially) full_ephys - raw ephys at 32kHz
            
            % multi_unit - most consistent data we have
            % single_unit# - may be empty depending on the animal, handles
            % up to 3 units
            
            total_time = length(ds_ephys)./ recording_freq;
            [firing_rate] = calculateFiringRate(spikes, total_time, recording_freq);
            [ISI] = calculateISI(spikes);
            [time_range_voltage_arr_avg] = calculateSTA(spikes, total_time, recording_freq);
            bp_theta = bandpass(ds_ephys, [3, 7], recording_frequency);
            [spike_phases] = calculateSFC(spike, ds_ephys, recording_freq);
            
        end % hemispheres
        
        cd .. % step out of each animals folder
    end
    
end


