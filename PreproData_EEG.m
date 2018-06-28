pathin='/media/Work/Data_RhythmProject/SbjectData/EEG/2months/New/';
pathout='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/';
ssPath=dir([pathin '*months']);
for t=1:length(ssPath)
    ssList=dir([pathin '*.raw']); %dir([pathin  ssPath(t).name '/*.raw']);
    pathoutsegment=[pathout  ssPath(t).name '/SegmentFor_ICA/'];
    pathoutset=[pathout  ssPath(t).name '/Event_Filtered/'];
    
    
    for i = 1:length(ssList)
        i
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        subjectName = [pathin  ssList(i).name] %[pathin  ssPath(t).name '/' ssList(i).name]
        subjectNamex = char(subjectName(:,55:length(subjectName)-4));
        subjectEvent= strcat(subjectNamex, '.evt');
        setNamex = strcat(subjectNamex,'.set');
        
        EEG = pop_readegi(subjectName, []);
        [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
        
        EEG = pop_eegfiltnew(EEG, 0.2, 45);
        
        subjectName
        EEG=Insert_Event(EEG, subjectEvent, [pathin ssPath(t).name '/'] );
        EEG = pop_saveset( EEG, setNamex, pathoutset);
        
        
        EEGF = pop_epoch( EEG, { 'DIN4' }, [-1   2], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGF = pop_rmbase( EEGF, [-1000   2000]);
        EEGF = pop_saveset( EEGF, setNamex, pathoutsegment);
        
    end
end

%MarkEpoch

%ReRefAll

% pathin='/home/voguemerry/Documents/Travail/Experience/MorphEEG/BB_analysis/fil/'
% ssList=dir('/home/voguemerry/Documents/Travail/Experience/MorphEEG/BB_analysis/fil/*.set')
% pathoutsegment='/home/voguemerry/Documents/Travail/Experience/MorphEEG/BB_analysis/segment'
% for i = 14:length(ssList)
%     i   
%         subjectName = [ ssList(i).name]
%         subjectNamex = char(subjectName(:,1:length(subjectName)-4));
%         
%         setNameW = [subjectNamex 'W.set'];
%         
%         EEG = pop_loadset(subjectName,pathin);
%         [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
%     
%    
% 
%     EEGW = pop_epoch( EEG, { 'DINW' }, [-0.5         1.4], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
%     %[LLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
%     EEGW = pop_rmbase( EEGW, [-500    1400]);
%     EEGW = pop_saveset( EEGW, setNameW, pathoutsegment);
% 
%  end
% 
% 
%     