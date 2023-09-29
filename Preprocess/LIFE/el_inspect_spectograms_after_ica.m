clc; clear all; close all

addpath /nobackup/schwalm2/tools/k1_tools/export_fig_master/
addpath /data/p_02035/Matlab_codes/life_preprocess/Inspect_ICA/
addpath /data/p_02035/Matlab_codes/toolboxes/eeglab14_1_1b/
eeglab

%dataDir = '/data/p_02035/Preprocessed/After_ICA/Inspect_spectrum/';
befDir = '/data/p_02035/Preprocessed/Before_ICA/'
aftDir = '/data/p_02035/Preprocessed/After_ICA/'
saveDirSpec = '/data/p_02035/Matlab_codes/life_preprocess/spectograms/'
Specname = 'inspect_spectograms_afterICA_Simon_new'

filesA = dir([aftDir, '*.set']);
filesB = dir([befDir, '*.set']);

for isb = 2899:length(filesA)% 1048
    name = extractBetween(filesA(isb).name,"","_prep.set") %name for the plot
    nameA = strcat(name, '_prep');
    nameB = strcat(name, '_preICA');
      
    EEG_aft = pop_loadset([char(nameA), '.set'], aftDir);
    
    EEG_before = pop_loadset([char(nameB), '.set'], befDir);
    
    if isfield(EEG_aft, 'rejData')
        
        if isempty(EEG_aft.rejData)
            events = EEG_aft.event(:,(ismember({EEG_aft.event.type}, [{'auto_start'},{'manual_start'}])),:);
            rejData(:,1) = [events.latency];
            rejData(:,2) = [events.latency] + [events.duration];
            rejData = sort(rejData,1);
            
            EEG_aft.rejData = rejData;
            EEG_aft = pop_saveset(EEG_aft, 'filename', char(nameA),'filepath', aftDir);
            
            EEG_before.rejData = rejData;
            EEG_before = pop_saveset(EEG_before, 'filename', char(nameB),'filepath', befDir);
        elseif length(EEG_aft.data) < EEG_aft.rejData(end,1)
            rejData = EEG_aft.rejData
            rejData(end,:)=[]
            EEG_aft.rejData = rejData;
            EEG_aft = pop_saveset(EEG_aft, 'filename', char(nameA),'filepath', aftDir);
            
            EEG_before.rejData = rejData;
            EEG_before = pop_saveset(EEG_before, 'filename', char(nameB),'filepath', befDir);
            
        elseif length(EEG_aft.data) < EEG_aft.rejData(end,2)
            rejData = EEG_aft.rejData
            rejData(end,2)=length(EEG_aft.data)
            EEG_aft.rejData = rejData;
           
            EEG_aft = pop_saveset(EEG_aft, 'filename', char(nameA),'filepath', aftDir);
            
            EEG_before.rejData = rejData;
            EEG_before = pop_saveset(EEG_before, 'filename', char(nameB),'filepath', befDir);
        else
            rejData = EEG_aft.rejData;
        end
    else
        events = EEG_aft.event(:,(ismember({EEG_aft.event.type}, [{'auto_start'},{'manual_start'}])),:);
        rejData(:,1) = [events.latency];
        rejData(:,2) = [events.latency] + [events.duration];
        rejData = sort(rejData,1);
        EEG_aft.rejData = rejData;
        EEG_aft = pop_saveset(EEG_aft, 'filename', char(nameA),'filepath', aftDir);
        
        EEG_before.rejData = rejData;
        EEG_before = pop_saveset(EEG_before, 'filename', char(nameB),'filepath', befDir);
    end
    
    EEG_rej_before = pop_select(EEG_before, 'nopoint', [rejData(:,1) rejData(:,2)]); %reject data for ICA.
    
    EEG_rej_aft = pop_select(EEG_aft, 'nopoint', [rejData(:,1) rejData(:,2)]); %reject data for ICA.
    
    if isfield (EEG_aft.reject, 'icamusclecomp')
        if numel(EEG_aft.reject.icamusclecomp)
            %apply passive comp
            if numel(EEG_aft.reject.icarejedcomp)
                
                act = EEG_aft.reject.icarejedcomp; %active components
                pas = EEG_aft.reject.icamusclecomp ;%passive componente
                sim_gco = zeros(1,length(EEG_aft.icaweights)); %reconstruct EEG.reject.gcompreject
                
                sim_gco(pas) = 1; %for pasive
                sim_gco(act)=[]; %remove active components
                
                new_passive = find(sim_gco == 1); %real numbers resembling passive components after active are removed
                
                if length(new_passive) == length(EEG_aft.reject.icamusclecomp)
                    
                    EEG_rej_aft_pas = pop_subcomp(EEG_rej_aft, [new_passive], 0);
                else
                    error('New passive components do not match with the original!')
                end
            else
                EEG_rej_aft_pas = pop_subcomp(EEG_rej_aft, [EEG_aft.reject.icamusclecomp], 0);
            end
            Fig4 = figure('Name',char(name)); set(gcf,'position',[10,10,1600,500]);
            set(0, 'CurrentFigure', Fig4);
            
            subplot(1,3,1), plot_spec(EEG_rej_before.data',EEG_rej_before.srate,45), title(strcat(name,' Before ICA')),
            yLimit_spec = get(gca,'YLim');
            
            subplot(1,3,2), plot_spec(EEG_rej_aft.data',EEG_rej_aft.srate,45), title(['After ICA ACTIVE = ', num2str(length(EEG_aft.reject.icarejedcomp))]),ylim(yLimit_spec);%PRINT NUMBER OF COMPONENTS
            
            subplot(1,3,3), plot_spec(EEG_rej_aft_pas.data',EEG_rej_aft_pas.srate,45), title(['After ICA PASSIVE = ', num2str(length(EEG_aft.reject.icamusclecomp))]),ylim(yLimit_spec), set(Fig4, 'Visible', 'off');
            
        else
            Fig4 = figure('Name',char(name)); set(gcf,'position',[10,10,1200,500]);
            set(0, 'CurrentFigure', Fig4);
            subplot(1,2,1), plot_spec(EEG_rej_before.data',EEG_rej_before.srate,45), title(strcat(name,' Before ICA')),
            yLimit_spec = get(gca,'YLim');
            subplot(1,2,2), plot_spec(EEG_rej_aft.data',EEG_rej_aft.srate,45), title(['After ICA active = ', num2str(length(EEG_aft.reject.icarejedcomp))]),ylim(yLimit_spec),set(Fig4, 'Visible', 'off');
        end
    else
        Fig4 = figure('Name',char(name)); set(gcf,'position',[10,10,1200,500]);
        set(0, 'CurrentFigure', Fig4);
        subplot(1,2,1), plot_spec(EEG_rej_before.data',EEG_rej_before.srate,45), title(strcat(name,' Before ICA')),
        yLimit_spec = get(gca,'YLim');
        subplot(1,2,2), plot_spec(EEG_rej_aft.data',EEG_rej_aft.srate,45), title(['After ICA active = ', num2str(size(EEG_aft.data,1) - size(EEG_aft.icaweights,1))]),ylim(yLimit_spec),set(Fig4, 'Visible', 'off');
    end
    export_fig([saveDirSpec, Specname], '-pdf', '-append', Fig4); % h is
    clear rejData EEG_aft EEG_before EEG_rej_aft EEG_rej_before EEG_rej_aft_pas Fig4 name
end












