pathIn='/media/Work/Data_RhythmProject/SbjectData/FR22/';
pathOut='/media/Work/Data_RhythmProject/SbjectData/FR22/Mark/';
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
    
%     try
        for ev=1:length(EEG.event)
            if strcmp(EEG.event(ev).type, 'TRSP')
                tempev=1;
                try
                while ~strcmp(EEG.event(ev+tempev).type, 'TRSP') & ev+tempev<length(EEG.event)
                    if strcmp(EEG.event(ev+tempev).type, 'DIN4')
                        EEG.event(ev+tempev).test=EEG.event(ev).test
                        EEG.event(ev+tempev).cell=EEG.event(ev).cell
                        EEG.event(ev+tempev).obss=EEG.event(ev).obss
                        
                    end
                    tempev=tempev+1;
                end
                end
                switch EEG.event(ev).test
                    case 0
                        EEG.event(ev).type='TRS0';
                    case 1
                        EEG.event(ev).type='TRS1';
                       
                    case 2
                        EEG.event(ev).type='TRS2';
                      
                    case 3
                        EEG.event(ev).type='TRS3'
                        
                end
                
                
            else
                switch EEG.event(ev).test
                    
                    case 1
                        EEG.event(ev).type='DINV';
                        
                    case 2
                        EEG.event(ev).type='DIND';
                    case 3
                        EEG.event(ev).type='DINR';
                    otherwise
                        continue
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
            EEGD = pop_epoch( EEG, { 'DIND' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
            % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
            EEGD = pop_rmbase( EEGD, [-300  1800]);
            EEGD = pop_saveset( EEGD, NamSetDrum, pathOut);
            
        end
        try
            
            EEGS = pop_epoch( EEG, { 'DINV' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
            % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
            EEGS = pop_rmbase( EEGS, [-300  1800]);
            EEGS = pop_saveset( EEGS, NamSetSyll, pathOut);
        end
        
        try  % What do You do with NUSERY RHYMES :)
            
            EEGS = pop_epoch( EEG, { 'DINR' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
            % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
            EEGS = pop_rmbase( EEGS, [-300  1800]);
            EEGS = pop_saveset( EEGS, NamSetSong, pathOut);
        end
        
        

    
end