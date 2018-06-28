pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered_MarkedbyTrial_CleanForICA/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered_MarkedbyTrial_CleanForICA_ICAMarked/';
ssList=dir([pathIn '*All.set']);

for t =:length(ssList)
    subjectName = [ ssList(t).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset(subjectName,pathIn);
    
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'savemode','resave');
    EEG = eeg_checkset( EEG );
    EEG.setname=[subjectName,'_PP_ICA'];
    ICA_name=[subjectName '_PP_ICA'];
    EEG = pop_saveset( EEG, 'filename',ICA_name,'filepath',pathOut);
%     EEG = eeg_checkset( EEG );
%    % pop_eegplot( EEG, 0, 1, 1);%plot the activation scroll
%   %  OUTEEG = pop_subcomp( EEG );%pop up to allow you to select the componants to remove
%     ICA_R_name=[subjectName, '_PP_ICA_R'];
%     EEG = pop_saveset( EEG, 'filename',ICA_R_name,'filepath','/media/sdb/Data_RhythmProject/Data_Analysis/EEG_Analysis/ICAResult/'); %change
%     EEG = eeg_checkset( EEG );
end