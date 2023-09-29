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

% Set defaults for ICA rejection fields in case they are not set in the
% cfg. This makes processing easier in the main loop.
% ------------------------------------------------------------------------
%icareject_fields = {'do_correlate_eog', 'do_iclabel'};
cfg.EEGchans = [1: size(EEG.chanlocs,2)]
cfg.max_chan_std = 2
cfg.nbadchans_deletetrial = 10
cfg.nbadtrials_deletechan = 0.25%percentage
cfg.channel_interp_method = 'spherical'

for p = 1:length(dataDir)
    addpath([dataDir(p).folder, '/']) % needs to see the fdt file
    EEG = pop_loadset(dataDir(p).name)

    EEG = pop_select(EEG, 'nochannel', {'M1', 'M2', 'IO2', 'IO1', 'Afp10', 'Afp9'})

     [EEGclean badPointsInSec] = el_trimOutlier(EEG,125, EEG.srate*2) % EEG, channelSdLowerBound, channelSdUpperBound, amplitudeThreshold, pointSpreadWidth
    badSec(p) = badPointsInSec;

    addEvents = EEGclean.event({EEGclean.event.type} == "auto_start" | {EEGclean.event.type} == "auto_end");
    EEG.event(end+1:length(EEG.event)+length(addEvents)) = addEvents; % add bad segment marks to the dataset
    EEG.trimOutlier.rejectDataIntervals = EEGclean.trimOutlier.rejectDataIntervals;

   
 % reject bar segments
    EEG = pop_select(EEG, 'nopoint', [EEG.trimOutlier.rejectDataIntervals])
    pop_eegplot_adjust(EEG,1,1,1)

     cat = categorical({EEG.event.type})
    catAll = join(join([string(categories(cat)), repelem({'='}, length(countcats(cat)))', string(countcats(cat))']), ';');

    EEG = pop_epoch(EEG, {}, [-1, 1.7], 'epochinfo', 'yes') % removes boundary events and epochs that had them

    %pop_eegplot_adjust(EEG,1,1,1)

%     tmpeeg = pop_rmbase(EEG, [], []); % uses all epoch as baseline

    %% NIko's channel interpolation function %%
    EEG = func_prep_channelinterp(EEG, cfg) % put a limit to the number of channels or trials to inpsect in case something goes wrong?
    
    % Reject trials with extreme amplitude values.
   % [tmpeeg, ~] = pop_eegthresh(tmpeeg, 1, [1:size(EEG.chanlocs,2)], ... %uses pop_rejepoch
    %    -200, 200, EEG.xmin, EEG.xmax, 1, 0);

%     %% Elena visually check excluded events
%     indx_rej_epoch = tmpeeg.reject.rejthresh;
%     if ~isempty(find(indx_rej_epoch))
%         testEEG = pop_selectevent(EEG, 'event', find(indx_rej_epoch))
%         pop_eegplot(testEEG, 1,1,1)
%     end

    %% Elena visually check retained events
 %   retainedEEG = pop_selectevent(EEG, 'event', find(~indx_rej_epoch))
   % pop_eegplot(EEG, 1,1,1)

    EEG = pop_select( EEG, 'notrial', find(indx_rej_epoch));

    EEG = pop_saveset(EEG, 'filename', [dataDir(p).name(1:4), '_epoched'],'filepath',saveDir);

end