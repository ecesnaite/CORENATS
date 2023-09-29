clear all, close all
addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
addpath /data4/Elena/LIFE/preprocessing_scripts/life_preprocess/Main_codes/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/export_fig-master/export_fig-master/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/trimOutlier-master/trimOutlier-master/
eeglab

dataDir = dir(['/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_continuous/', '*.set'])

for p = 1:length(dataDir)
   
    setDir = dir(['/data4/nbusch/Corenats_2022/data/EEG/',dataDir(p+2).name, '/', '*.set'])%find set file
    addpath (['/data4/nbusch/Corenats_2022/data/EEG/',dataDir(p+2).name, '/']) % needs to see the fdt file
    EEGclean = pop_loadset(setDir.name)
    % reject bar segments
   % EEGclean = pop_select(EEG, 'nopoint', [EEG.trimOutlier.rejectDataIntervals])
   % close
    fig = figure; 
    
   % plot_spec(EEG.data', EEG.srate, 45)
    pop_spectopo(EEGclean, 1, [0 length(EEGclean.data)], 'EEG' , 'freqrange',[1 45], 'title', char(dataDir(p).name))

    EEG = pop_select(EEG, 'nochannel', {})
    EEG.interpchannels = 

    EEG = pop_saveset(EEG, 'filename', [setDir.name(1:4), '_preICA'],'filepath',saveDir);
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    clearvars -except dataDir saveDir eeglab p
end