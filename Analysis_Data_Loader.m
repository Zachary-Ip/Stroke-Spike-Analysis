% Spike

%% testing?
test = 1;
%% initalize values
filepath = 'C:\Users\ipzach\Documents\Spiking Data';
cd(filepath)
animallist = dir;
recording_freq = 32000;
ds_freq = 1000;
animal_names = [];
if test
    disp('Reading Ephys')
    test_ephys = read_neuralynx_ncs('test.ncs');
    disp('Reading Spikes')
    test_spike = readNexFile('test.nex');
end
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
            full_spikes = [];
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
                
                multi_unit = [full_spikes spike.neurons{1,1}.timestamps + time_adjust;];
                for kk = 2:length(spike.neurons)
                    single_unit{kk-1,1} = [single_unit{kk-1} spike.neurons{kk-1,1}.timestamps + time_adjust;];
                end
                
                full_ephys = [full_ephys reshape(ephys.dat, 1, [])];
                time_adjust = time_adjust + length(full_ephys)./recording_freq;
                
            end % k recording folders
            
            % Analysis
            output = function_draft(spikes, ephys,timeline);
            
        end % hemispheres
        
        cd .. % step out of each animals folder
    end
    
end


