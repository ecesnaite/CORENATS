clear all, close all
addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
addpath /data4/Elena/LIFE/preprocessing_scripts/life_preprocess/Main_codes/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/trimOutlier-master/trimOutlier-master/
eeglab

dataDir = dir(['/data4/nbusch/Corenats_2022/data/EEG/', 'C*'])
saveDir = '/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_continuous/'

for f = 1:length(dataDir)

    setDir = dir(['/data4/nbusch/Corenats_2022/data/EEG/',dataDir(f).name, '/', '*.set'])%find set file
    addpath (['/data4/nbusch/Corenats_2022/data/EEG/',dataDir(f).name, '/']) % needs to see the fdt file
    EEG = pop_loadset(setDir.name)

    % remove unwanted channels
    EEG = pop_select(EEG, 'nochannel', {'VEOG', 'HEOG'})

    %% Band-pass filter combined with the notch %%
    [b1,a1] = butter(2,[0.1 45]/(EEG.srate/2));
    [b2,a2] = butter(2,[49 51]/(EEG.srate/2),'stop');

    EEG.data = filtfilt(conv(b1,b2),conv(a1,a2),double(EEG.data)')';
    
     % select data from the first event - 1s to the last event + 2s 
    EEG = pop_select(EEG, 'point', [EEG.event(1).latency - EEG.srate : EEG.event(end).latency + EEG.srate*2]); %cut data from the first marker to the last

     %% Re-reference data to average reference%%
    EEG = pop_reref(EEG, [])

 %% Automatically remove bad segmetns %%
    EEG_mfront = pop_select(EEG, 'nochannel', {'IO1', 'Fp1', 'Fp2', 'AF7', 'AF3', 'F1', 'F3', 'IO2', 'Afp9' , 'Afp10', 'Fpz', 'AF8'}); %temporarily reject front channels to avoid blinks

    [EEGclean badPointsInSec] = el_trimOutlier(EEG_mfront,200, EEG.srate*2) % EEG, channelSdLowerBound, channelSdUpperBound, amplitudeThreshold, pointSpreadWidth
    badSec(f) = badPointsInSec;

    addEvents = EEGclean.event({EEGclean.event.type} == "auto_start" | {EEGclean.event.type} == "auto_end");
    EEG.event(end+1:length(EEG.event)+length(addEvents)) = addEvents; % add bad segment marks to the dataset
    EEG.trimOutlier.rejectDataIntervals = EEGclean.trimOutlier.rejectDataIntervals;

    % plot spectra to see how data looks like
    %[X_spec,F] = pwelch(EEG.data',1*EEG.srate,0,4*EEG.srate,EEG.srate);
    %X_spec = X_spec(F<=45,:);
    %F = F(F<=45);
    %figure,plot(F,10*log10(X_spec),'linewidth',1.5)

   
    %pop_eegplot_adjust(EEGclean, 1, 1, 1)

    % Manually mark bad time segments
    %waitfor( findobj('parent', gcf, 'string', 'MARK'), 'userdata');
    %input('continue?')

    EEG = pop_saveset(EEG, 'filename', [setDir.name(1:4), '_preICA'],'filepath',saveDir);
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    clearvars -except dataDir saveDir eeglab f badSec

end
save('bad_points_in_sec_all22022023','badSec')
