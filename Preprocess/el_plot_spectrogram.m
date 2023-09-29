clear all, close all
addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
addpath /data4/Elena/LIFE/preprocessing_scripts/life_preprocess/Main_codes/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/export_fig-master/export_fig-master/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/trimOutlier-master/trimOutlier-master/
eeglab

dataDir = dir(['/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_continuous/', '*.set'])
saveDir = '/data4/nbusch/Corenats_2022/Elena/Preprocessed data/'

specName = 'spectogram_preICA18022023';

for p = 2:length(dataDir)
   
    addpath([dataDir(p).folder, '/']) % needs to see the fdt file
    EEG = pop_loadset(dataDir(p).name)
    
    % reject bar segments
    EEGclean = pop_select(EEG, 'nopoint', [EEG.trimOutlier.rejectDataIntervals])
   % close
    fig = figure; 
    
   % plot_spec(EEG.data', EEG.srate, 45)
    pop_spectopo(EEGclean, 1, [0 length(EEGclean.data)], 'EEG' , 'freqrange',[1 45], 'title', char(dataDir(p).name)), set(fig, 'Visible', 'off');
    
    % This part changes the color of frontal channels to red
    colors = hot(64);
    axhandle = gca;
    lines = findobj(axhandle,'type','line');
    
    set(lines(length(lines)-1:length(lines)),'color',colors(37,:));
    %savefigure

    export_fig([saveDir, specName], '-pdf', '-append', fig); % h is
    
    close 
    clearvars EEG EEGclean fig
end

