%% Set preferences, configuration and load list of subjects.
clear; clc; close all

addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
eeglab

%restoredefaultpath
%savepath
%prefs = el_get_prefs('eeglab_all', 1);
load('/data4/nbusch/Corenats_2022/Elena/buschlab-eeg-pipeline-main/code/el_cfg_file_corenats.mat')

% cfg   = el_get_cfg;

subjects = dir(['/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_epoched/', '*.set'])

%% Run across subjects.
%nthreads = min([prefs.max_threads, length(subjects)]);
parfor isub = 1:length(subjects) % set nthreads to 0 for normal for loop.
% for isub = 1%:length(subjects)    
    
    % ----------------------------------------------------------
    % Load the dataset.
    % ----------------------------------------------------------
    EEG = pop_loadset('filename', subjects(isub).name, 'filepath', subjects(isub).folder);
    
    % ----------------------------------------------------------
    % Artifact rejection.
    % ----------------------------------------------------------
    
    % I do a temorary baseline correction, otherwise the rejection by
    % extreme amplitudes gets confused if there are still some DC
    % shifts in the raw data. However, we apply the trial rejection to
    % the un-baseline corrected data, because ICA likes that better.
    tmpeeg = pop_rmbase(EEG, [], []); % uses all epoch as baseline
    
    % Elena: define threshod
    conEEG = eeg_epoch2continuous(tmpeeg)
    conEEG = pop_select(conEEG, 'nochannel', {'VEOG', 'Fp1', 'Fp2', 'AF7', 'AF3', 'F1', 'F3', 'HEOG'})

    meanAllChan = mean(conEEG.data(:,:));
    stdAllChan  = std( conEEG.data(:,:),0,1);
    posi2SDChan = meanAllChan + 3*stdAllChan;
    nega2SDChan = meanAllChan - 3*stdAllChan;
    newThre = max(max(abs(nega2SDChan), posi2SDChan));

    % Reject trials with extreme amplitude values.
    [tmpeeg, ~] = pop_eegthresh(tmpeeg, 1, [1:67], ...
        -newThre, newThre, EEG.xmin, EEG.xmax, 1, 0);

    %% Elena visually check excluded events
    indx_rej_epoch = tmpeeg.reject.rejthresh;
    testEEG = pop_selectevent(tmpeeg, 'event', find(indx_rej_epoch))
    %pop_eegplot(testEEG, 1,1,1)

    %% Elena visually check retained events
    retainedEEG = pop_selectevent(tmpeeg, 'event', find(~indx_rej_epoch))
   % pop_eegplot(retainedEEG, 1,1,1)

    meansd = mean(stdAllChan) %mean std 8
      % INputs: EEG, 1-raw data , channel index to include, activity probability limit(s) (in std. dev.), global limit(s) (all activities grouped) (in std. dev.)
      % Here they use 5 as a common SD: https://nigelrogasch.gitbook.io/tesa-user-manual/example_pipelines
    tmpeeg = pop_jointprob(tmpeeg, 1, [1:67], ...
        4, 6, 1, 0, 1); %Elena:  does not reject but stores marked trials. Another checkup for bad marks. 
    
    rejinds = find(tmpeeg.reject.rejthresh | tmpeeg.reject.rejjp); %combined, isnt overlap better?
    %find(tmpeeg.reject.rejthresh == tmpeeg.reject.rejjp)

    % Reject those bad trials from the raw data.
    EEGbad = pop_select( EEG, 'trial',   rejinds);
   % pop_eegplot(EEG,1,1,1)
    EEG    = pop_select( EEG, 'notrial', rejinds);
    EEG.rejected_trials = rejinds;
        
    % ----------------------------------------------------------
    % Change the EEG.setname and save the data to disk under a new name.
    % ----------------------------------------------------------
    EEG = func_saveset(EEG, subjects(isub));

%     EEGbad = pop_editset(EEGbad, 'setname', [subjects(isub).namestr ' prep1 BAD TRIALS']);
%     pop_saveset(EEGbad, 'filename', ['bad' subjects(isub).outfile], 'filepath', subjects(isub).outdir);
    
end

disp('Done.')
