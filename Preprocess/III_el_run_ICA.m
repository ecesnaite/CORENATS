clear all, close all
addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
addpath /data4/Elena/LIFE/preprocessing_scripts/life_preprocess/Main_codes/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/export_fig-master/export_fig-master/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/trimOutlier-master/trimOutlier-master/
eeglab

dataDir = dir(['/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_continuous/', '*.set'])
saveDir = '/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_continuous_ww/'

parfor p = 1:length(dataDir)

    addpath([dataDir(p).folder, '/']) % needs to see the fdt file
    EEG = pop_loadset(dataDir(p).name)

    % reject bar segments
    EEG = pop_select(EEG, 'nopoint', [EEG.trimOutlier.rejectDataIntervals])

    % apply a 0.5Hz filter for better results
    EEGhigh  = pop_basicfilter( EEG, [1:68], 'Cutoff',  0.5, 'Design', 'butter', 'Filter', 'highpass', 'Order',  2 );
    
    %run ICA
    [EEGhigh, com] = pop_runica(EEGhigh, 'icatype', 'runica', 'extended', 1, 'chanind', [1:68], 'pca', 30);

    % apply weights to 0.1 Hz fitlered data
    EEG.icaweights  = EEGhigh.icaweights;
    EEG.icasphere   = EEGhigh.icasphere;
    EEG.icachansind = EEGhigh.icachansind;
    %EEG = eeg_checkset(EEG); %let EEGLAB re-compute EEG.icaact & EEG.icawinv

    %save
    EEG = pop_saveset(EEG, 'filename', [dataDir(p).name(1:4), '_preICA'],'filepath',saveDir);
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    %clearvars -except dataDir saveDir eeglab p

end