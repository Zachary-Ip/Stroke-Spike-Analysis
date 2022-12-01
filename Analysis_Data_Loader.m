%% initalize Parameters
tic
filepath = 'C:\Users\ipzach\Documents\MATLAB\Data\Spiking Data';
addpath(genpath('C:\Users\ipzach\Documents\MATLAB\utils-toolbox'),...
genpath('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts'))

animallist = dir;
recording_freq = 32000;
ds_factor = 32;
ds_freq = 1000;
animal_names = [];
preload = 1;
% Start loading
for group = 1:5 % number of groups
    cd(filepath)
    % Create variables which can be fed to stats later
    % temp variables to load each group because the data is too large
    % otherwise
    FR_storage  = cell(1,2);
    ISI_storage = cell(1,2);
    SFC_storage = cell(1,2);
    %Spec_storage = cell(1,2);
    
    STA_storage    = cell(1,2);
    STA_d_storage  = cell(1,2);
    STA_t_storage  = cell(1,2);
    STA_a_storage  = cell(1,2);
    STA_b_storage  = cell(1,2);
    STA_g_storage  = cell(1,2);
    STA_hg_storage = cell(1,2);
    
    STAmean_storage = cell(1,2);
    STAmean_d_storage  = cell(1,2);
    STAmean_t_storage  = cell(1,2);
    STAmean_a_storage  = cell(1,2);
    STAmean_b_storage  = cell(1,2);
    STAmean_g_storage  = cell(1,2);
    STAmean_hg_storage  = cell(1,2);
    
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
    % Find files with relevant file name
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
            % Inialize storage variables for each recording. 
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
                
                % multi_unit = [multi_unit; spike.neurons{1,1}.timestamps + time_adjust];
                for kk = 1:length(spike.neurons)
                    ind_units{kk,k} = spike.neurons{kk,1}.timestamps + time_adjust;
                end % kk
                
                full_ephys = [full_ephys reshape(ephys.dat, 1, [])];
                time_adjust = length(full_ephys)./recording_freq;
                cd ..
            end % k recording folders
            
            % now with full data preprocess ephys 
            ds_ephys = downsample(full_ephys, ds_factor);
            norm_ephys = normalize(ds_ephys); % why am I normalizing? 
            delta = BPfilter(norm_ephys,1000,0.1,3);
            theta = BPfilter(norm_ephys,1000,3,7);
            alpha = BPfilter(norm_ephys,1000,7,13);
            beta = BPfilter(norm_ephys,1000,13,30);
            gamma = BPfilter(norm_ephys,1000,30,58);
            hgamma = BPfilter(norm_ephys,1000,62,200);
            
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
                [FR] = calculateFiringRate(single_unit, total_time, ds_freq);
                [ISI] = calculateISI(single_unit);
                [~,SFC,~,~,~,~,SFC_freq] = getCoherence(single_unit,ds_ephys,ds_freq,1,0,0);
                
                [A, STA] = calculateSTA(single_unit, norm_ephys, ds_freq);
                [dA, dSTA] = calculateSTA(single_unit, delta, ds_freq);
                [tA, tSTA] = calculateSTA(single_unit, theta, ds_freq);
                [aA, aSTA] = calculateSTA(single_unit, alpha, ds_freq);
                [bA, bSTA] = calculateSTA(single_unit, beta, ds_freq);
                [gA, gSTA] = calculateSTA(single_unit, gamma, ds_freq);
                [hgA, hgSTA] = calculateSTA(single_unit, hgamma, ds_freq);
                %[Spec, f, t] = spectrogram(STA,24,1,60,1000);
                % Save Analysis
                FR_storage{1,j}    = [FR_storage{1,j}; FR];
                ISI_storage{1,j}  = [ISI_storage{1,j}; ISI];
                SFC_storage{1,j}  = [SFC_storage{1,j}; SFC];
                %Spec_storage{1,j} = cat(3,Spec_storage{1,j}, Spec);
                
                STAmean_storage{1,j}  = [STAmean_storage{1,j}; STA];
                STAmean_d_storage{1,j}  = [STAmean_d_storage{1,j}; dSTA];
                STAmean_t_storage{1,j}  = [STAmean_t_storage{1,j}; tSTA];
                STAmean_a_storage{1,j}  = [STAmean_a_storage{1,j}; aSTA];
                STAmean_b_storage{1,j}  = [STAmean_b_storage{1,j}; bSTA];
                STAmean_g_storage{1,j}  = [STAmean_g_storage{1,j}; gSTA];
                STAmean_hg_storage{1,j}  = [STAmean_hg_storage{1,j}; hgSTA];
                
                STA_storage{1,j}  = [STA_storage{1,j}; A];
                STA_d_storage{1,j}  = [STA_d_storage{1,j}; dA];
                STA_t_storage{1,j}  = [STA_t_storage{1,j}; tA];
                STA_a_storage{1,j}  = [STA_a_storage{1,j}; aA];
                STA_b_storage{1,j}  = [STA_b_storage{1,j}; bA];
                STA_g_storage{1,j}  = [STA_g_storage{1,j}; gA];
                STA_hg_storage{1,j}  = [STA_hg_storage{1,j}; hgA];
            end % num units
            cd ..
            cd ..
        end % hemispheres
        cd .. % step out of each animals folder
    end
    
    %% save data
    cd 'C:\Users\ipzach\Documents\MATLAB\output\Spike Sorting Scripts'  
    % removed: 'Spec_storage'
    save([save_name '_singleunit_measures'],'FR_storage','ISI_storage','SFC_storage','SFC_freq','f','t',...
        'STAmean_storage','STAmean_d_storage','STAmean_t_storage','STAmean_a_storage','STAmean_b_storage','STAmean_g_storage','STAmean_hg_storage',...
        'STA_storage','STA_d_storage','STA_t_storage','STA_a_storage','STA_b_storage','STA_g_storage','STA_hg_storage', '-v7.3')
    toc
end