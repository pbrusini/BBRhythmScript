pathin='/media/perrine/LACIE SHARE/Preproc_tashacomputer/4month/';
ssList=dir([pathin '*.set']); %dir([pathin  ssPath(t).name '/*.raw']);
pathoutsegment='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered/'
pathoutset='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered/'


for i =5:length(ssList)
    i
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    subjectName = [pathin  ssList(i).name] %[pathin  ssPath(t).name '/' ssList(i).name]
    subjectNamex = ssList(i).name(1:length(ssList(i).name)-4);
    subjectEvent= strcat(subjectNamex, '.evt');
     EEG = pop_loadset(subjectName);
    
    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
    
%     EEG = pop_eegfiltnew(EEG, 0.2, 0);
%     EEG = pop_eegfiltnew(EEG, 0, 45);
    
    subjectName
    EEG=Insert_Event(EEG, subjectEvent, pathin  );
%     chanlocs='channel64.xyz';
%     EEG=pop_chanedit(EEG,  'load',{ chanlocs, 'filetype', 'autodetect'});
    EEG = pop_saveset( EEG, ssList(i).name, pathoutset);
    
  
    
end

