function EEG = func_prep_channelinterp(EEG, cfg)
% Interpolate bad channels.
% Definition of bad channels is: a channel with larger variability across
% time compared to all other EEG channels.



% itrial = 157;
% figure;stem(eeg_std(:,itrial));
% set(gca, 'XTick', cfg.EEGchans, 'XTickLabel', {EEG.chanlocs(cfg.EEGchans).labels})

%% Old idea based on inter-channel correlation
% Idea is that a bad channel is a channel that is not correlated with other
% channels. But this did not work well because even bad channels have some
% correlation with good channels.
% rmax = zeros(length(cfg.EEGchans), EEG.trials);
% dat = EEG.data(cfg.EEGchans, :, :);
% for iep = 1:EEG.trials
%     r = corr(squeeze(dat(:,:,iep))');
%     r(r==1) = nan;
%     rmax(:,iep)  = nanmax(abs(r));
% end
% bad = rmax < cfg.thresh_maxcorr;

fprintf('**********************\n')
fprintf('Channel interpolation.\n')
fprintf('**********************\n')

% .........................................................................
%% Reject trials that have more than N bad channels at once.
% .........................................................................
bad = find_bad_data(EEG, cfg);
very_bad_trials = find(sum(bad,1) > cfg.nbadchans_deletetrial);
n_very_bad_trials = length(very_bad_trials);

fprintf('*** Rejecting %d very bad trials with at least %d bad channels:\n', ...
    n_very_bad_trials, cfg.nbadchans_deletetrial)
fprintf('%g ', very_bad_trials)
fprintf('\n')

%   testEEG = pop_selectevent(EEG, 'event', very_bad_trials)
%   pop_eegplot(testEEG, 1,1,1)

if n_very_bad_trials > 0
    EEG = pop_select( EEG, 'notrial', very_bad_trials);
    bad(:,very_bad_trials) = 0;
end


% .........................................................................
%% Interpolate channels with more than p bad trials for all trials.
% .........................................................................
bad = find_bad_data(EEG, cfg);
very_bad_chans  = find(sum(bad,2) > EEG.trials * cfg.nbadtrials_deletechan);
n_very_bad_chans = length(very_bad_chans);

fprintf('*** Interpolating %d very bad channels with more than %2.2f bad epochs:\n', ...
    n_very_bad_chans, cfg.nbadtrials_deletechan)
fprintf('%g ', very_bad_chans)
fprintf('\n')



if n_very_bad_chans > 0
    fprintf('Bad channels: ', EEG.chanlocs(very_bad_chans).labels)
    fprintf('%g ', very_bad_chans)
    fprintf('\n')

    the_chan = cfg.EEGchans(very_bad_chans);
    EEG = eeg_interp(EEG, the_chan, cfg.channel_interp_method);
    bad(very_bad_chans,:) = 0;
end


% .........................................................................
%% Interpolate channels with fewer bad epochs on a trial by trial basis.
% .........................................................................
bad = find_bad_data(EEG, cfg);
little_bad_chans = find(any(bad,2));

for ichan = 1:size(little_bad_chans,1)
    the_chan = cfg.EEGchans(little_bad_chans(ichan));

    the_trials = find(bad(the_chan,:));

    fprintf('*** Interpolating channel %s on %d trials:\n', ...
        EEG.chanlocs(the_chan).labels, length(the_trials))

%   testEEG = pop_selectevent(EEG, 'event', the_trials)
%      pop_eegplot(testEEG, 1,1,1)

    % only on bad trials
    EEGtmp = pop_select(EEG, 'trial', the_trials);
    if isempty(EEG.chanlocs(the_chan).theta)
        disp(['Warning: No location information for channel ' the_chan '. Channel NOT interpolated.'])
        continue
    end
    % interpolate that channel
    EEGtmp = eeg_interp(EEGtmp, the_chan, cfg.channel_interp_method);

    % and paste back into the data.
    EEG.data(the_chan,:, the_trials) = EEGtmp.data(the_chan,:,:);
end

EEG.interpol_bad = bad;

fprintf('**********************\n')

%% ---------------------
function bad = find_bad_data(EEG, cfg)

% z-score the EEG data according to mean and std of all data from all
% channels concatenated. This preserves differences in variability between
% channels.
dat = EEG.data(cfg.EEGchans,:,:);

mdat = mean(dat(:));
sdat = std(dat(:));
zdat = (dat(:) - mdat) ./ sdat;
zdat = reshape(zdat, size(dat));

% Compute standard deviation for each channel and find channels with too
% large std.
eeg_std = squeeze(std(zdat, [], 2)); %takes the standard deviation along the dimension 2 (which is channels)
bad = eeg_std > cfg.max_chan_std;% >= ?
find(bad)
