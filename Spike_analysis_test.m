% Spike 
%initalize values
filepath = 'C:\Users\ipzach\Documents\Spiking Data\1MA01\L_Chan\CSC9\REC1';
cd(filepath)
Fs = 1000;
firing_rates = [];
inter_spike_intervals = [];
animal_names = [];

ephys_dat = ft_read_data('REC1.nex');
ephys_dat_flat = reshape(ephys_dat, 1, []);
downsample_ephys = downsample(ephys_dat_flat, 32);  % take only every 32nd entry, 1 x 3681360
downsample_ephys_theta = bandpass(downsample_ephys, [3, 7], recording_frequency);  % bandpass filter
ephys_time = length(downsample_ephys)./ Fs;  % get time period of this recording
spikes = readtable(strcat('sorted_00', num2str(k-1)));  % 985x35. we only care about columns 1-3
spike_timings = spikes(:,3); % 985x1, get the spike timing column
adjusted_spikes = [adjusted_spikes; (table2array(spike_timings) + time_adjust)]; 
time_adjust = time_adjust + ephys_time;
%{
%loop through all animals
for i = 4:length(animallist)
    animal_storage_variable = [];
    cd(animallist(i).name);
    animal_names = [animal_names animallist(i).name];
    % for grou p1:4
    % switch case
    dir('1ma*'
    
    for j = 1 % :2
        if j == 1
            cd L_chan;
        end
        if j == 2
            cd R_chan;
        end
%         recording_names = dir('*.ncs');
%         recording_names_arr = struct2table(recording_names);
%         recording_names_arr_sorted = sortrows(recording_names_arr.name);  % all .ncs files in alphabetical sorted order
%         num_recordings = length(recording_names_arr_sorted);
        channel_names = dir('CSC*');
        %%% ZACH NOTE: We will actually need to create a "best channel file
        %%% that only notes one of the folders, we're probably not going to
        %%% use every channel that we sorted. so for now we'll just use the
        %%% first channel for convenience
        cd(channel_names(1).name)
        full_ephys = [];
        adjusted_spikes = [];
        time_adjust = 0;
       %for k = 1:num_recordings
            % ephys = read_neuralynx_ncs(char(recording_names_arr_sorted(k)));  % struct with fields -- timestamp (1x230085), ... , dat (512x230085)
            % ephys_dat = ephys.dat;  % 512x230085
            % ephys_dat_flat = reshape(ephys_dat, 1, []);  % 1x117803520
            %%% NOTE: Ephys Data here is 6xN, but as far as I can tell its
            %completely duplicated, so just take one row
            %%% NOTE: I wrote .nex here bc it turns out its 450x faster to
            %%% load than .plx files which are an outdated file type.
            %%% Luckily, we can open the .plx files and re-export them to
            %%% .nex and its super fast.
            ephys_dat = ft_read_data('REC1.nex');
            
            % The spike data is separated by recording, so we need to
            % concatenate, and then separate by unit, but its all linear so
            % should be pretty easy to manipulate
            spike_dat = ft_read_spike('REC1.plx');
            
            downsample_ephys = downsample(ephys_dat_flat, 32);  % take only every 32nd entry, 1 x 3681360
            downsample_ephys_theta = bandpass(downsample_ephys, [3, 7], recording_frequency);  % bandpass filter
            ephys_time = length(downsample_ephys)./ recording_frequency;  % get time period of this recording
            full_ephys = [full_ephys downsample_ephys_theta];  % append ephys to full_ephys list
            spikes = readtable(strcat('sorted_00', num2str(k-1)));  % 985x35. we only care about columns 1-3
            spike_timings = spikes(:,3); % 985x1, get the spike timing column
            adjusted_spikes = [adjusted_spikes; (table2array(spike_timings) + time_adjust)]; 
            time_adjust = time_adjust + ephys_time;
        end % recording loop
        
        % Analysis
        
        % firing rate
        num_spikes = length(adjusted_spikes);
        firing_rate = num_spikes ./ (time_adjust./1000);
        firing_rates = [firing_rates firing_rate];
            
        % inter spike interval
        inter_spike_intervals = [inter_spike_intervals diff(adjusted_spikes)];
        figure(fig_num);
        plot(linspace(1, length(adjusted_spikes), length(adjusted_spikes)-1), inter_spike_intervals);
        xlabel('Spike Interval Number'); 
        ylabel('Interspike Interval (seconds)');
        fig_num = fig_num + 1;
        
        % spike triggered average
        time_range = 1000;
        time_range_voltage_arr = NaN(length(adjusted_spikes), time_range); % nanmean(data)
        for i = 1:length(adjusted_spikes)
            curr_time = adjusted_spikes(i) * 1000;
            if curr_time >= 500
                lower_index = curr_time - (time_range / 2);
            else
                continue;
            end
            
            if (curr_time + 500) <= length(full_ephys)
                upper_index = curr_time + (time_range / 2) - 1;
            else
                continue;
            end
            time_range_voltage_arr(i, :) = full_ephys(lower_index:upper_index);
        end
        time_range_voltage_arr_avg = mean(time_range_voltage_arr, 1);
        figure(fig_num);
        plot(linspace(-500, 500, 1000), time_range_voltage_arr_avg);
        xlabel('Time Relative to Time of Spike Occurrence (seconds)'); 
        ylabel('Voltage (V)');
        fig_num = fig_num + 1;
                
        %spike phase coherence
        %{
        ephys_data = ephys.dat;
        bp_delta = bandpass(ephys_data, [0.1, 3], recording_frequency);
        bp_theta = bandpass(ephys_data, [3, 7], recording_frequency);
        bp_alpha = bandpass(ephys_data, [7, 12], recording_frequency);
        bp_beta = bandpass(ephys_data, [12, 30], recording_frequency);
        bp_gamma = bandpass(ephys_data, [32, 58], recording_frequency);
        bp_highgamma = bandpass(ephys_data, [62, 150], recording_frequency);
        
        hilbert_ephys_data_angle_delta = angle(hilbert(bp_delta));
        hilbert_ephys_data_angle_theta = angle(hilbert(bp_theta));
        hilbert_ephys_data_angle_alpha = angle(hilbert(bp_alpha));
        hilbert_ephys_data_angle_beta = angle(hilbert(bp_beta));
        hilbert_ephys_data_angle_gamma = angle(hilbert(bp_gamma));
        hilbert_ephys_data_angle_highgamma = angle(hilbert(bp_highgamma));
        %}
        
            
    end   
        
end

figure(fig_num);
bar(firing_rates);
xticklabels(animal_names);
xlabel('Animal Number'); 
ylabel('Firing Rate (spikes/second)');
fig_num = fig_num + 1;

cd ..
%}
        
        