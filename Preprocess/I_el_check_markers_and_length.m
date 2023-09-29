addpath /data4/nbusch/Corenats_2022/code/tools/eeglab2021.0/
eeglab
dataDir = dir(['/data4/nbusch/Corenats_2022/data/EEG/', 'C*'])
eventType=[18:29];
events(:,1)=eventType;

for f = 1:length(dataDir)
    setDir = dir(['/data4/nbusch/Corenats_2022/data/EEG/',dataDir(f).name, '/', '*.set'])%find set file
    addpath (['/data4/nbusch/Corenats_2022/data/EEG/',dataDir(f).name, '/']) % needs to see the fdt file
    EEG = pop_loadset(setDir.name)

    if EEG.srate ~= 512%check sampling rate
        error('The sampling rate is not 512')
    end
    rec_length(f)=size(EEG.data,2)/EEG.srate/60 % length of recoding in minutes
    % u = unique([EEG.event.type])
    events(:,f+1)=histc([EEG.event.type],eventType);% how many events of each type
    
    %% remove unwanted channels
    %EEG = pop_select(EEG, 'nochannel', {'M1', 'M2', 'IO1', 'IO2', 'Iz'})
    %% re-reference to average reference
    %EEG = pop_reref( EEG, []);
end
bar(rec_length), xlabel('Participants', 'FontSize', 14), ylabel('Length of recording', 'FontSize', 14)
saveas(gcf, '/data4/nbusch/Corenats_2022/Elena/Figures/Preprocess/recording length.png')

bar(events(:,1),events(:,2:end)), xlabel('Events', 'FontSize', 12), ylabel('Number of occurances', 'FontSize', 12), legend(string([1:33]), 'Location','southoutside',...
    'Orientation','horizontal','NumColumns',6, 'FontSize',5)
saveas(gcf, '/data4/nbusch/Corenats_2022/Elena/Figures/Preprocess/events per participant.png')