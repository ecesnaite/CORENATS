clear all; close all

addpath /nobackup/schwalm2/tools/k1_tools/export_fig_master/
addpath /data/p_02035/Matlab_codes/toolboxes/eeglab14_1_1b/
eeglab

% Load data %
dataDir = '/data/pt_02035/Data/eeg_data/ruhe/'
saveDir = '/data/p_02035/Preprocessed/Before_ICA/Not_matched_bad_seg/'
saveDirSpec = '/data/p_02035/Matlab_codes/life_preprocess/spectograms/'
textDir = '/data/p_02035/Preprocessed/Before_ICA/Text_files/'
probDir = '/data/p_02035/Matlab_codes/life_preprocess/'

files = dir([dataDir, '*.vhdr']);

addpath /data/p_02035/Matlab_codes/life_preprocess/donotshare/
load final_names_elena % load under your name
specName = 'spectogram_elena';

for p = 199:length(names)
    
    EEG = pop_loadbv(dataDir, [char(names(p)), '.vhdr']);
    
    % Inspect data for sampling rate and store the outcome if it's other than 1000 Hz%
    if EEG.srate~=1000
        % personalized txt file
        fileID = fopen(fullfile(textDir,[char(names(p)),'.txt']),'a+'); %do not overwrite
        fprintf(fileID,'\n %s %s %s %12s %s','ERROR ', datestr(datetime), strcat(' iteration_', num2str(p)),'; Sampling rate is not 1000 Hz! It is: ', num2str(EEG.srate));
        fclose(fileID);
        
        fileID = fopen(fullfile(probDir,'EEG_problems_detected.txt'),'a+'); %do not overwrite
        fprintf(fileID,'\n %s %6s %s %12s %s',datestr(datetime),EEG.comments, strcat(' iteration_', num2str(p)),'; Sampling rate is not 1000 Hz! It is: ', num2str(EEG.srate));
        fclose(fileID);
        EEG = pop_saveset(EEG, 'filename', [char(names(p)), '_samplingrate_manualInspection_', num2str(p)],'filepath', inspectDir);
        continue
    end
    
    % Band-pass filter combined with the notch
    [b1,a1] = butter(2,[1 45]/(EEG.srate/2));
    [b2,a2] = butter(2,[49 51]/(EEG.srate/2),'stop');
    
    EEG.data = filtfilt(conv(b1,b2),conv(a1,a2),double(EEG.data)')';
    
    % Downsample data to 500 Hz %
    EEG = pop_resample(EEG,EEG.srate/2);% what is the filter
    
    if length(EEG.data)/(EEG.srate*60) < 20 %inspect if resting state is less than 20min
        
        fileID = fopen(fullfile(probDir,'EEG_problems_detected.txt'),'a+'); %do not overwrite
        fprintf(fileID,'\n %s %6s %s %12s %s',datestr(datetime), EEG.comments, strcat(' iteration_', num2str(p)),'; Resting state data is less than 20 min! It is: ', num2str(length(EEG.data)/(EEG.srate*60)));
        fclose(fileID);
        
        fileID = fopen(fullfile(textDir,[char(names(p)),'.txt']),'a+'); %do not overwrite
        fprintf(fileID,'\n %s %s %s %12s %s %s', 'ERROR ',datestr(datetime), strcat(' iteration_', num2str(p)),';  Resting state data is: ', num2str(length(EEG.data)/(EEG.srate*60)), ' min');
        fclose(fileID);
        
        EEG = pop_saveset(EEG, 'filename', ['visually_inspect_', char(names(p)), '_duration_manualInspection_', num2str(p)],'filepath', saveDir);
    else
        % personalized txt file
        fileID = fopen(fullfile(textDir,[char(names(p)),'.txt']),'a+'); %do not overwrite
        fprintf(fileID,'\n %s %s %12s %s %s', datestr(datetime), strcat(' iteration_', num2str(p)),';  Resting state data is: ', num2str(length(EEG.data)/(EEG.srate*60)), ' min');
        fclose(fileID);
    end
    
    % Load Channel locations
    EEG = pop_chanedit(EEG, 'lookup','/data/p_02035/Matlab_codes/toolboxes/eeglab14_1_1b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
    
    
    % Exclude EKG and eye movement channels before rejecting bad channels.
    indx_chan = ismember({EEG.chanlocs.labels}, {'EKG', 'HEOG', 'VEOG'});
    
    % Excluded channels should be saved
    if sum(indx_chan)~= 3
        
        fileID = fopen(fullfile(probDir,'EEG_problems_detected.txt'),'a+'); %do not overwrite
        fprintf(fileID,'\n %s %6s %s %12s %s',datestr(datetime), EEG.comments, strcat(' iteration_', num2str(p)), '; No EKG, HEOG and/or VEOG were found.');
        fclose(fileID);
        
        EEG = pop_saveset(EEG, 'filename', [char(names(p)), '_EKG_HEOG_VEOG_manualInspection_', num2str(p)],'filepath', inspectDir); %include 3 channel data
        continue
    else
        EEG_31ch = pop_select(EEG, 'nochannel', {'EKG', 'HEOG', 'VEOG'});
        EEG_31ch.EOG_EKG = pop_select(EEG, 'channel', {'EKG', 'HEOG', 'VEOG'});
    end
    
    % Mark artifacts that exceed 80 microvolts
    
    [EEG_31ch rejData] = trimOutlier_adjust_new(EEG_31ch, 80, 40, 500);   %trimOutlier_adjust also marks 2s at the beginning of recording
    auto_seg = EEG_31ch.event(:,(ismember({EEG_31ch.event.type}, {'auto_start'})),:);
    
    if sum([auto_seg.duration])/EEG.srate < 180 % if more than three minutes are marked, do not proceed
        EEG_rej = pop_select(EEG_31ch, 'nopoint', [rejData(:,1) rejData(:,2)]); %reject data for ICA.
        EEG_31ch.rejData = rejData;
        EEG_31ch = pop_saveset(EEG_31ch, 'filename', [char(names(p)), '_preICA_no_weights_no_match'],'filepath', saveDir); %include 3 channel data
        
    else
        
        EEG_31ch = pop_saveset(EEG_31ch, 'filename', ['visually_inspect_',char(names(p)), '_preICA_no_weights_no_match'],'filepath', saveDir); %include 3 channel data
        
        EEG_rej = pop_select(EEG_31ch, 'nopoint', [rejData(:,1) rejData(:,2)]); %reject data for ICA. TO DO: for manual artifact detection
        
        fig = figure; 
        pop_spectopo(EEG_rej, 1, [0 length(EEG_rej.data)], 'EEG' , 'freqrange',[1 45], 'title', char(names(p))),set(fig, 'Visible', 'off');
        % This part changes the color of frontal channels to red
        colors = hot(64);
        axhandle = gca;
        lines = findobj(axhandle,'type','line');
        
        set(lines(length(lines)-1:length(lines)),'color',colors(37,:));
        export_fig([saveDirSpec, specName], '-pdf', '-append', fig); % h is
        
        close Figure 2
        continue
        
    end
    
    fig = figure; 
    pop_spectopo(EEG_rej, 1, [0 length(EEG_rej.data)], 'EEG' , 'freqrange',[1 45], 'title', char(names(p))), set(fig, 'Visible', 'off');
    
    % This part changes the color of frontal channels to red
    colors = hot(64);
    axhandle = gca;
    lines = findobj(axhandle,'type','line');
    
    set(lines(length(lines)-1:length(lines)),'color',colors(37,:));
    %savefigure
    export_fig([saveDirSpec, specName], '-pdf', '-append', fig); % h is
    
    close Figure 2
end

