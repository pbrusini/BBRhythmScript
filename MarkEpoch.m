pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial/';
ssList=dir([pathIn '*.set']);


for i =1:length(ssList)
    subjectName = [ ssList(i).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    subjectNamex = char(subjectName(:,1:length(subjectName)-6));
    NamSetResting=[subjectNamex 'Resting.set'];
    NamSetDrum=[subjectNamex 'Drum.set'];
    NamSetSyll=[subjectNamex 'Syll.set'];
    NamSetSong=[subjectNamex 'Song.set'];
    NamSetMer=[subjectNamex '_RDS.set'];
    NamSetAll=[subjectNamex '_All.set'];  
    
    EEG = pop_loadset(subjectName,pathIn);
    
    chanlocs='channel64.xyz';
    EEG=pop_chanedit(EEG,  'load',{ chanlocs, 'filetype', 'autodetect'});
    
    for ev=1:length(EEG.event)
        if strcmp(EEG.event(ev).type, 'TRSP')
            switch EEG.event(ev).test
                case 0
                    EEG.event(ev).type='TRS0';
                case 1
                    EEG.event(ev).type='TRS1';
                    try
                         EEG.event(ev-1).type='DI_1';
                    end
                case 2
                    EEG.event(ev).type='TRS2';
                     try
                         EEG.event(ev-1).type='DI_2';
                    end
                case 3
                    EEG.event(ev).type='TRS3'
                     
            end
        end
    end% 
   try

    EEGR = pop_epoch( EEG, { 'TRS0' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
    % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
    EEGR = pop_rmbase( EEGR, [-300  1800]);
    EEGR = pop_saveset( EEGR, NamSetResting, pathOut);
    
 %   [ALLEEG EEGR CURRENTSET] = eeg_store(ALLEEG, EEGR);
   end
   try
    EEGD = pop_epoch( EEG, { 'DI_2' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
    % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
    EEGD = pop_rmbase( EEGD, [-300  1800]);
    EEGD = pop_saveset( EEGD, NamSetDrum, pathOut);
    
    %[ALLEEG EEGD CURRENTSET] = eeg_store(ALLEEG, EEGD);
    
%     EEG_RD=pop_mergeset(EEGR, EEGD, 1);
%     [ALLEEG EEG_RD CURRENTSET] = eeg_store(ALLEEG, EEG_RD);
   end
   try
    
    EEGS = pop_epoch( EEG, { 'DI_1' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
    % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
    EEGS = pop_rmbase( EEGS, [-300  1800]);
    EEGS = pop_saveset( EEGS, NamSetSyll, pathOut);
   end
   
    try
%     
%     EEGS = pop_epoch( EEG, { 'TRS3' }, [-0.3  3], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
%     % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
%     EEGS = pop_rmbase( EEGS, [-300  3000]);
%     EEGS = pop_saveset( EEGS, NamSetSong, pathOut);
    end
   
    %[ALLEEG EEGD CURRENTSET] = eeg_store(ALLEEG, EEGS);
    
%     EEG_RDS=pop_mergeset(EEG_RD, EEGS, 1);
%     EEGS = pop_saveset( EEG_RDS, NamSetMer, pathOut);

%     catch
%         EEGA = pop_epoch( EEG, { 'DIN4' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
%         % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
%         EEGA = pop_rmbase( EEGA, [-300  1800]);
%         EEGA = pop_saveset( EEGA, NamSetAll, pathOut);
%     end
end