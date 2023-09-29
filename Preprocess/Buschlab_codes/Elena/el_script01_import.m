%% Set preferences, configuration and load list of subjects.
clear; clc; close all
% ADJUSTMENTS TO CORENATS DATA: Data is minimally pre-processed already in
% set files. It is referenced to common average, but not epoched and not downsampled. That is
% what we will do here

addpath /data4/nbusch/Corenats_2022/Elena/buschlab-eeg-pipeline-main/code/functions/
addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
eeglab

% restoredefaultpath
%prefs = el_get_prefs('eeglab_all', 1);
% cfg   = el_get_cfg;
load('/data4/nbusch/Corenats_2022/Elena/buschlab-eeg-pipeline-main/code/el_cfg_file_corenats.mat')

% ------------------------------------------------------------------------
% **Important**: these variables determine which data files are used as
% input and output.
% suffix_in  = '';
% suffix_out = 'import';
% do_overwrite = false;

% Elena: get_prefs function really kicks out Matlab's inuilt functions and
% confuses it - skip it if you can

% restoredefaultpath
% savepath

% ------------------------------------------------------------------------
% subjects = get_list_of_subjects(cfg.dir, do_overwrite, suffix_in, suffix_out);
dataDir = dir(['/data4/nbusch/Corenats_2022/data/EEG/', 'CN*'])

%% Run across subjects.
%nthreads = min([prefs.max_threads, length(subjects)]);
for isub = 1:length(dataDir) % set nthreads to 0 for normal for loop.
    % for isub = 1:length(subjects)

    % --------------------------------------------------------------
    % Import EEGLAB data.
    % --------------------------------------------------------------
    setname = dir([dataDir(isub).folder, '/', dataDir(isub).name, '/', '*.set']);
    addpath(setname.folder)
    EEG = pop_loadset([setname.folder, '/', setname.name]);
    % remove unwanted channels
    EEG = pop_select(EEG, 'nochannel', {'M1', 'M2', 'IO1', 'IO2', 'Iz'})
    % --------------------------------------------------------------
    % Filter the data.
    % --------------------------------------------------------------

    % Band-pass filter combined with the notch
    [b1,a1] = butter(2,[0.1 45]/(EEG.srate/2));
    EEG.data = filtfilt(b1,a1,double(EEG.data)')';

    %---------------------------------------------------------------
    % ELENA: NOT SURE IF NECESSARY: Remove all events from non-configured trigger devices
    %---------------------------------------------------------------
    %EEG = func_import_remove_triggers(EEG, cfg.epoch);

    % -------------------------------------------------------------
    % Epoch data.
    % --------------------------------------------------------------
    % Elena: summarize the types of events we have in the data and save in a variable:
    cat = categorical({EEG.event.category_name})
    catAll = join(join([string(categories(cat)), repelem({'='}, length(countcats(cat)))', string(countcats(cat))']), ';');

    fileID = fopen('/data4/nbusch/Corenats_2022/Elena/Preprocessed data/categories_all_subjects.txt','a');
    fprintf(fileID,'%s\n',catAll);
    fclose(fileID);

    EEG = pop_epoch(EEG, {}, [-1, 1.7], 'epochinfo', 'yes')
    %     EEG = pop_rmbase(EEG, [], []);


    % --------------------------------------------------------------
    % Save the new EEG file in EEGLAB format.
    % --------------------------------------------------------------
    EEG = pop_saveset(EEG, 'filename', strcat('EMP', dataDir(isub).name, '_epoched_noICA'),'filepath','/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_epoched/');
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    clearvars -except dataDir cfg isub eeglab
end

disp('Done.')
