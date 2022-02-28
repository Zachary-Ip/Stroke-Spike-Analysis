%% initalize Parameters
tic
filepath = 'C:\Users\ipzach\Documents\Spiking Data';
animallist = dir;
recording_freq = 32000;
ds_factor = 32;
ds_freq = 1000;
animal_names = [];
preload = 1;

for group = 2:5
cd(filepath)
    % Create variables which can be fed to stats later
    mFR_storage  = cell(1,2);
    mISI_storage = cell(1,2);
    mSFC_storage = cell(1,2);
    mSFC_freq_storage = cell(1,2);
    mSpec_storage = cell(1,2);
    
    mSTA_storage    = cell(1,2);
    mSTA_d_storage  = cell(1,2);
    mSTA_t_storage  = cell(1,2);
    mSTA_a_storage  = cell(1,2);
    mSTA_b_storage  = cell(1,2);
    mSTA_g_storage  = cell(1,2);
    mSTA_hg_storage = cell(1,2);
    
    mSTAmean_storage = cell(1,2);
    mSTAmean_d_storage  = cell(1,2);
    mSTAmean_t_storage  = cell(1,2);
    mSTAmean_a_storage  = cell(1,2);
    mSTAmean_b_storage  = cell(1,2);
    mSTAmean_g_storage  = cell(1,2);
    mSTAmean_hg_storage  = cell(1,2);

    sFR_storage  = cell(1,2);
    sISI_storage = cell(1,2);
    sSFC_storage = cell(1,2);
    sSFC_freq_storage = cell(1,2);
    sSpec_storage = cell(1,2);
    
    sSTA_storage    = cell(1,2);
    sSTA_d_storage  = cell(1,2);
    sSTA_t_storage  = cell(1,2);
    sSTA_a_storage  = cell(1,2);
    sSTA_b_storage  = cell(1,2);
    sSTA_g_storage  = cell(1,2);
    sSTA_hg_storage = cell(1,2);
    
    sSTAmean_storage = cell(1,2);
    sSTAmean_d_storage  = cell(1,2);
    sSTAmean_t_storage  = cell(1,2);
    sSTAmean_a_storage  = cell(1,2);
    sSTAmean_b_storage  = cell(1,2);
    sSTAmean_g_storage  = cell(1,2);
    sSTAmean_hg_storage  = cell(1,2);
    
    % Split animals into treatment groups
    switch group
        case 1
            group_name = 'C*'; % Control
            save_name = 'Control';
        case 2
            group_name = '2WA*'; % 2WA
            save_name = 'TwoWeek';
        case 3
            group_name = '1MA*'; % 1 Month
            save_name = 'OneMonth';
        case 4
            group_name = 'SE*'; % EE Control
            save_name = 'EEControl';
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
                
                multi_unit = [multi_unit; spike.neurons{1,1}.timestamps + time_adjust];
                for kk = 2:length(spike.neurons)
                    ind_units{kk-1,k} = spike.neurons{kk-1,1}.timestamps + time_adjust;
                end % kk
                
                full_ephys = [full_ephys reshape(ephys.dat, 1, [])];
                time_adjust = length(full_ephys)./recording_freq;
                cd ..
            end % k recording folders
            ds_ephys = downsample(full_ephys, ds_factor);
            delta = BPfilter(ds_ephys,1000,0.1,3);
            theta = BPfilter(ds_ephys,1000,3,7);
            alpha = BPfilter(ds_ephys,1000,7,13);
            beta = BPfilter(ds_ephys,1000,13,30);
            gamma = BPfilter(ds_ephys,1000,30,58);
            hgamma = BPfilter(ds_ephys,1000,62,200);
            
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
            % multi unit
            [mFR] = calculateFiringRate(multi_unit, total_time, ds_freq);
            [mISI] = calculateISI(multi_unit);
            [~,mSFC,~,~,~,~,mSFC_freq] = getCoherence(multi_unit,ds_ephys,ds_freq,1,0,0);
            
            
            [mA, mSTA] = calculateSTA(multi_unit, ds_ephys, ds_freq);
            [mdA, mdSTA] = calculateSTA(multi_unit, delta, ds_freq);
            [mtA, mtSTA] = calculateSTA(multi_unit, theta, ds_freq);
            [maA, maSTA] = calculateSTA(multi_unit, alpha, ds_freq);
            [mbA, mbSTA] = calculateSTA(multi_unit, beta, ds_freq);
            [mgA, mgSTA] = calculateSTA(multi_unit, gamma, ds_freq);
            [mhgA, mhgSTA] = calculateSTA(multi_unit, hgamma, ds_freq);

            [mSpec] = spectrogram(mSTA);
            % Save Analysis
            mFR_storage{1,j}       = [mFR_storage{1,j}; mFR];
            mISI_storage{1,j}      = [mISI_storage{1,j}; mISI];
            mSFC_storage{1,j}      = [mSFC_storage{1,j}; mSFC];
            mSFC_freq_storage{1,j} = [mSFC_freq_storage{1,j}; mSFC_freq];
            mSpec_storage{1,j}     = cat(3,mSpec_storage{1,j}, mSpec);
            mSTAmean_storage{1,j}  = [mSTAmean_storage{1,j}; mSTA];
            mSTAmean_d_storage{1,j}  = [mSTAmean_d_storage{1,j}; mdSTA];
            mSTAmean_t_storage{1,j}  = [mSTAmean_t_storage{1,j}; mtSTA];
            mSTAmean_a_storage{1,j}  = [mSTAmean_a_storage{1,j}; maSTA];
            mSTAmean_b_storage{1,j}  = [mSTAmean_b_storage{1,j}; mbSTA];
            mSTAmean_g_storage{1,j}  = [mSTAmean_g_storage{1,j}; mgSTA];
            mSTAmean_hg_storage{1,j} = [mSTAmean_hg_storage{1,j}; mhgSTA];
            
            mSTA_storage{1,j}    = [mSTA_storage{1,j}; mA];
            mSTA_d_storage{1,j}  = [mSTA_d_storage{1,j}; mdA];
            mSTA_t_storage{1,j}  = [mSTA_t_storage{1,j}; mtA];
            mSTA_a_storage{1,j}  = [mSTA_a_storage{1,j}; maA];
            mSTA_b_storage{1,j}  = [mSTA_b_storage{1,j}; mbA];
            mSTA_g_storage{1,j}  = [mSTA_g_storage{1,j}; mgA];
            mSTA_hg_storage{1,j} = [mSTA_hg_storage{1,j}; mhgA];
            
            %% single units
            num_units = max(sum(~cellfun(@isempty, ind_units), 1));
            
            for ii = 1:num_units
                single_unit = [ind_units{ii,1}; ind_units{ii,2}; ind_units{ii,3}];
                [sFR] = calculateFiringRate(single_unit, total_time, ds_freq);
                [sISI] = calculateISI(single_unit);
                [~,sSFC,~,~,~,~,sSFC_freq] = getCoherence(single_unit,ds_ephys,ds_freq,1,0,0);
                [sA, sSTA] = calculateSTA(single_unit, ds_ephys, ds_freq);
                [sdA, sdSTA] = calculateSTA(single_unit, delta, ds_freq);
                [stA, stSTA] = calculateSTA(single_unit, theta, ds_freq);
                [saA, saSTA] = calculateSTA(single_unit, alpha, ds_freq);
                [sbA, sbSTA] = calculateSTA(single_unit, beta, ds_freq);
                [sgA, sgSTA] = calculateSTA(single_unit, gamma, ds_freq);
                [shgA, shgSTA] = calculateSTA(single_unit, hgamma, ds_freq);
                [sSpec] = spectrogram(sSTA);
                % Save Analysis
                sFR_storage{1,j}    = [sFR_storage{1,j}; sFR];
                sISI_storage{1,j}  = [sISI_storage{1,j}; sISI];
                sSFC_storage{1,j}  = [sSFC_storage{1,j}; sSFC];
                sSFC_freq_storage{1,j} = [sSFC_freq_storage{1,j}; sSFC_freq];
                sSpec_storage{1,j} = cat(3,sSpec_storage{1,j}, sSpec);
                sSTAmean_storage{1,j}  = [sSTAmean_storage{1,j}; sSTA];
                sSTAmean_d_storage{1,j}  = [sSTAmean_d_storage{1,j}; sdSTA];
                sSTAmean_t_storage{1,j}  = [sSTAmean_t_storage{1,j}; stSTA];
                sSTAmean_a_storage{1,j}  = [sSTAmean_a_storage{1,j}; saSTA];
                sSTAmean_b_storage{1,j}  = [sSTAmean_b_storage{1,j}; sbSTA];
                sSTAmean_g_storage{1,j}  = [sSTAmean_g_storage{1,j}; sgSTA];
                sSTAmean_hg_storage{1,j}  = [sSTAmean_hg_storage{1,j}; shgSTA];
                
                sSTA_storage{1,j}  = [sSTA_storage{1,j}; sA];
                sSTA_d_storage{1,j}  = [sSTA_d_storage{1,j}; sdA];
                sSTA_t_storage{1,j}  = [sSTA_t_storage{1,j}; stA];
                sSTA_a_storage{1,j}  = [sSTA_a_storage{1,j}; saA];
                sSTA_b_storage{1,j}  = [sSTA_b_storage{1,j}; sbA];
                sSTA_g_storage{1,j}  = [sSTA_g_storage{1,j}; sgA];
                sSTA_hg_storage{1,j}  = [sSTA_hg_storage{1,j}; shgA];
            end % num units
            cd ..
            cd ..
        end % hemispheres
        cd .. % step out of each animals folder
    end
    
    %% save data
    cd 'C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts'
    save([save_name unit_name '_measures'],'FR_storage','ISI_storage','SFC_storage',...
        'STAmean_storage','STAmean_d_storage','STAmean_t_storage','STAmean_a_storage','STAmean_b_storage','STAmean_g_storage','STAmean_hg_storage',...
        'STA_storage','STA_d_storage','STA_t_storage','STA_a_storage','STA_b_storage','STA_g_storage','STA_hg_storage')
    toc
end
beep