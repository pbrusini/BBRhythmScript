pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_SegByTask_RerefDetrendBase/';
pathOutM='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_SegByTask_RerefDetrendBase_Mean/';
cd(pathIn)
ssList=dir([pathIn '*.set']);

for i =18:length(ssList)
    subjectName = [ ssList(i).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    subjectNamex = char(subjectName(:,1:length(subjectName)-4));
    EEG = pop_loadset(subjectName,pathIn);
%     tmp=EEG.data;
%     
%     save(subjectNamex, 'tmp')
    
     EEG.data=mean(EEG.data,3);
    try
        EEG.event=EEG.event(1);
        EEG.urevent=EEG.urevent(1);
        EEG.epoch=1;
    end
    EEG = pop_saveset( EEG, subjectNamex, pathOutM);
    
end
    