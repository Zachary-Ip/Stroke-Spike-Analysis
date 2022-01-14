% Spike
%initalize values
filepath = 'C:\Users\ipzach\Documents\Spiking Data';
cd(filepath)
animallist = dir;
recording_frequency = 1000;

animal_names = [];
% Split animals into treatment groups
for groups = 1:5
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
            channel_names = dir('CSC*');
            cd(channel_names(1).name)
           
            ephys_dat_full = ft_read_data('REC1.nex');
            ephys_dat_crop = ephys_dat_full(1,:);
            clear ephys_dat_full % save on memory
            downsample_ephys = downsample(ephys_dat_crop, 32);  % take only every 32nd entry
            
            spike_dat = ft_read_spike('REC1.plx');
            
            downsample_ephys_theta = bandpass(downsample_ephys, [3, 7], recording_frequency);  % bandpass filter
            ephys_time = length(downsample_ephys)./ recording_frequency;  % get time period of this recording
            full_ephys = [full_ephys downsample_ephys_theta];  % append ephys to full_ephys list
            spikes = readtable(strcat('sorted_00', num2str(k-1)));  % 985x35. we only care about columns 1-3
            spike_timings = spikes(:,3); % 985x1, get the spike timing column
            adjusted_spikes = [adjusted_spikes; (table2array(spike_timings) + time_adjust)];
            time_adjust = time_adjust + ephys_time;
        end % hemispheres
        
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
        
        cd .. % step out of each animals folder
    end
    
end

figure(fig_num);
bar(firing_rates);
xticklabels(animal_names);
xlabel('Animal Number');
ylabel('Firing Rate (spikes/second)');
fig_num = fig_num + 1;

cd ..


