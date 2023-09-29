clear all, close all
addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
addpath /data4/Elena/LIFE/preprocessing_scripts/life_preprocess/Main_codes/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab_codes/toolboxes/export_fig-master/export_fig-master/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab_codes/Preprocess/Buschlab_codes/Elena/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab_codes/Preprocess/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab_codes/toolboxes/trimOutlier-master/trimOutlier-master/
eeglab

dataDir = dir(['/data4/nbusch/Corenats_2022/Elena/Preprocessed data/AfterICA_contnuous/', '*.set'])
saveDir = '/data4/nbusch/Corenats_2022/Elena/Preprocessed data/AfterICA_epoched/'

for p = 1:length(dataDir)
    addpath([dataDir(p).folder, '/']) % needs to see the fdt file
    EEG = pop_loadset(dataDir(p).name)

    EEG = pop_select(EEG, 'nochannel', {'M1', 'M2', 'IO2', 'IO1', 'Afp10', 'Afp9'})

    testEEG = clean_rawdata(EEG,-1,-1,-1,-1,10,0.25)%with 3 SD number of points is the same. All of the data had been changed

    %how much of data had been changed
    sample_mask = testEEG.etc.clean_sample_mask
    %find latency of regions
    retain_data_intervals = reshape(find(diff([false sample_mask false])),2,[])';
    retain_data_intervals(:,2) = retain_data_intervals(:,2)-1;
    %% How deos the PSD look like? %%
    % plot_spec(EEG.data', EEG.srate, 45)
    figure, pop_spectopo(testEEG, 1, [0 length(testEEG.data)], 'EEG' , 'freqrange',[1 45], 'title', char(dataDir(p).name))

    pop_eegplot_adjust(testEEG,1,1,1)
end