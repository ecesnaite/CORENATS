clear all, close all
addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
addpath /data4/Elena/LIFE/preprocessing_scripts/life_preprocess/Main_codes/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/export_fig-master/export_fig-master/
addpath /data4/nbusch/Corenats_2022/Elena/Matlab codes/toolboxes/trimOutlier-master/trimOutlier-master/
eeglab

dataDir = dir(['/data4/nbusch/Corenats_2022/Elena/Preprocessed data/BeforeICA_continuous_ww/', '*.set'])
saveDir = '/data4/nbusch/Corenats_2022/Elena/Preprocessed data/AfterICA_contnuous/'

% Set defaults for ICA rejection fields in case they are not set in the
% cfg. This makes processing easier in the main loop.
% ------------------------------------------------------------------------
%icareject_fields = {'do_correlate_eog', 'do_iclabel'};

for p = 2:length(dataDir)

    addpath([dataDir(p).folder, '/']) % needs to see the fdt file
    EEG = pop_loadset(dataDir(p).name)

    %     [bad_ics_eog, bad_ics_iclabel] = deal(zeros(length(EEG.reject.gcompreject), 1));
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

    % Detect bad ICs with IC label.
    % --------------------------------------------------------------
    fprintf('Detecting ICs with IClabel.\n')
    EEG = iclabel(EEG);% The 6 categories are (in order): Brain, Muscle, Eye, Heart, Line Noise, Channel Noise, Other.


    % Detect artifactual components. Example:
    % the threshold below will only select component if they are in the
    % eye category with at least 90% confidence. it's a range for all
    % artifacts and classification confidence
    threshold = [0 0;0.9 1; 0.85 1; 0.9 1; 0.9 1; 0.9 1; 0 0];
    EEG = pop_icflag(EEG, threshold)

    % Number of artifactual components found:
    sum(EEG.reject.gcompreject)

    % --------------------------------------------------------------
    % Manual inspection.
    % --------------------------------------------------------------

    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
    [EEG] = pop_selectcomps(EEG,[1:30]);
    % wait for decision
%     comp_handles = findobj('-regexp', 'tag', '^selcomp.*');
%     while true %
%         try
%             waitforbuttonpress
%         catch
%             if ~any(isgraphics(comp_handles))
%                 break
%             end
%         end
%     end
    %EEG = func_icareject_manualinspect(EEG);
        f = gcf; %handle of the Figure
        while size(findobj(f))>0
            'me' %some action
            pause %some input
        end

    remove_ics = find(EEG.reject.gcompreject);
    fprintf('Removing %d components:\n', length(remove_ics))
    fprintf(' %g', remove_ics)
    fprintf('.\n')

    EEG = pop_subcomp(EEG, remove_ics, 0);
    EEG.reject.gcompreject = evalin('base', 'ALLEEG(end).reject.gcompreject');


    EEG = pop_saveset(EEG, 'filename', [dataDir(p).name(1:4), '_wICA'],'filepath',saveDir);
   % clearvars -except p dataDirline saveDir ALLEEG eeglab
        STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

end