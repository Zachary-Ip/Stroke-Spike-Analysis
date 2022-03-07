% Analysis_Stats
FR = cell(5,2);
ISI = cell(5,2);
PSD = cell(5,2);
SFC_a = cell(5,2);
SFC_b = cell(5,2);
SFC_d = cell(5,2);
SFC_g = cell(5,2);
SFC_hg = cell(5,2);
SFC_t = cell(5,2);

STA_a = cell(5,2);
STA_b = cell(5,2);
STA_d = cell(5,2);
STA_g = cell(5,2);
STA_hg = cell(5,2);
STA = cell(5,2);
STA_t = cell(5,2);

STAmean_a = cell(5,2);
STAmean_b = cell(5,2);
STAmean_d = cell(5,2);
STAmean_g = cell(5,2);
STAmean_hg = cell(5,2);
STAmean = cell(5,2);
STAmean_t = cell(5,2);

for i = 1:5
    switch i
        case 1
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\Control_PSD.mat')
        case 2
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEControl_PSD.mat')
        case 3
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\TwoWeek_PSD.mat')
        case 4
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\OneMonth_PSD.mat')
        case 5
            load('C:\Users\ipzach\Documents\MATLAB\Spike Sorting Scripts\EEOneMonth_PSD.mat')
    end
    PSD{i,1} = PSD_storage{1,1}; PSD{i,2} = PSD_storage{1,2};
end

%% 1way ANOVA Stats
PSD_stats1 = calculate1wayANOVA(PSD);

%% single unit 2way ANOVA stats
PSD_stats2    = calculate2wayANOVA(PSD);

