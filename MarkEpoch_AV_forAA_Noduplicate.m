pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered_MarkedbyTrial/';
ssList=dir([pathIn '*.set']);


for i =70:length(ssList)
    subjectName = [ ssList(i).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    subjectNamex = char(subjectName(:,1:length(subjectName)-6));
    NamSetResting=[subjectNamex 'Resting.set'];
    NamSetDrum=[subjectNamex 'Drum.set'];
    NamSetSyll=[subjectNamex 'Syll.set'];
%     NamSetSong=[subjectNamex 'Song.set'];
    NamSetMer=[subjectNamex '_RDS.set'];
    NamSetAll=[subjectNamex '_All.set'];
    
    EEG = pop_loadset(subjectName,pathIn);
    DebMovie=[];
    MovieD=[];
    MovieS=[];
    Rest=[];
    Syll=[];
    Drum=[];
    Nr=[];
    
    
    %     try
    for ev=1:length(EEG.event)
        if strcmp(EEG.event(ev).type, 'TRSP')
            tempev=1;
            try
                while ~strcmp(EEG.event(ev+tempev).type, 'TRSP') & ev+tempev<length(EEG.event)
                    if strcmp(EEG.event(ev+tempev).type, 'DIN4')
                        if  tempev==1
                            EEG.event(ev).type='DINM';
                            DebMovie=[DebMovie ev];
                        end
                        EEG.event(ev+tempev).test=EEG.event(ev).test;
                        EEG.event(ev+tempev).cell=EEG.event(ev).cell;
                        EEG.event(ev+tempev).obss=EEG.event(ev).obss;
                        
                    end
                    tempev=tempev+1;
                end
            end
            switch EEG.event(ev).test
                case 0
                    EEG.event(ev).type='TRS0';
                    Rest=[Rest ev];
                case 1
                    EEG.event(ev).type='TRS1';
                    MovieS=[MovieS ev];
                case 2
                    EEG.event(ev).type='TRS2';
                    MovieD=[MovieD ev];
                case 3
                    EEG.event(ev).type='TRS3';
                    
            end
            
            
        else
            switch EEG.event(ev).test                
                case 1
                    EEG.event(ev).type='DINS';
                    Syll=[Syll ev];
                case 2
                    EEG.event(ev).type='DIND';
                    Drum=[Drum ev];
                case 3
                    EEG.event(ev).type='DINR';
                    Nr=[Nr ev];
                case 4
                    EEG.event(ev).type='DINF';
                otherwise
                    continue
            end
        end
    end%
    
    
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(['Nbre of movie TA detected ' num2str(length(MovieS))]);
    disp(' ')
    disp(['Nbre of movie Drum detected ' num2str(length(MovieD))]);
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

    
    goodDrumforzero=[];
    goodSyllforzero=[];
    goodRstforzero=[];
    
    d=1;
    while d<length(Rest)
        goodRstforzero=[goodRstforzero Rest(d)];
        d=d+16;
    end
    
    d=2;
    while d<length(Drum)
        try
            if strcmp(EEG.event(Drum(d)+3).type, 'DIND') & strcmp(EEG.event(Drum(d)+2).type, 'DIND') & strcmp(EEG.event(Drum(d)+1).type, 'DIND') & strcmp(EEG.event(Drum(d)+4).type, 'DIND') & strcmp(EEG.event(Drum(d)+5).type, 'DIND') & strcmp(EEG.event(Drum(d)+6).type, 'DIND') & strcmp(EEG.event(Drum(d)+7).type, 'DIND') & strcmp(EEG.event(Drum(d)+8).type, 'DIND') & strcmp(EEG.event(Drum(d)+14).type, 'DIND')
                goodDrumforzero=[goodDrumforzero Drum(d)];
                d=d+15;
            else
                d=d+1;
            end
        catch
            break
        end
    end
    d=2;
    while d<length(Syll)
        try
            if strcmp(EEG.event(Syll(d)+3).type, 'DINS') & strcmp(EEG.event(Syll(d)+2).type, 'DINS') & strcmp(EEG.event(Syll(d)+1).type, 'DINS') & strcmp(EEG.event(Syll(d)+4).type, 'DINS') & strcmp(EEG.event(Syll(d)+5).type, 'DINS') & strcmp(EEG.event(Syll(d)+6).type, 'DINS') & strcmp(EEG.event(Syll(d)+7).type, 'DINS') & strcmp(EEG.event(Syll(d)+8).type, 'DINS') & strcmp(EEG.event(Syll(d)+14).type, 'DINS')
                goodSyllforzero=[goodSyllforzero Syll(d)];
                d=d+24;
            else
                d=d+1;
            end
        catch
            break
        end
        
    end
    
    
    for dr=1:length(goodDrumforzero)
        EEG.event(goodDrumforzero(dr)).type='D_DM';
    end
    
    for sy=1:length(goodSyllforzero)
        EEG.event(goodSyllforzero(sy)).type='D_SL';
    end
    
    for rs=1:length(goodRstforzero)
        EEG.event(goodRstforzero(rs)).type='D_RS';
    end
    
    
    
    try
        
        EEGR = pop_epoch( EEG, { 'D_RS' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGR = pop_rmbase( EEGR, [0  8000]);
        EEGR = pop_saveset( EEGR, NamSetResting, pathOut);
        
        %   [ALLEEG EEGR CURRENTSET] = eeg_store(ALLEEG, EEGR);
    end
    try
        EEGD = pop_epoch( EEG, { 'D_DM' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGD = pop_rmbase( EEGD, [0  8000]);
        EEGD = pop_saveset( EEGD, NamSetDrum, pathOut);
        
    end
    try
        
        EEGS = pop_epoch( EEG, { 'D_SL' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGS = pop_rmbase( EEGS, [0  8000]);
        EEGS = pop_saveset( EEGS, NamSetSyll, pathOut);
    end
    
%     try  % What do You do with NUSERY RHYMES :)
%         
%         EEGS = pop_epoch( EEG, { 'DINR' }, [-0.3  1.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
%         % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
%         EEGS = pop_rmbase( EEGS, [-300  1800]);
%         EEGS = pop_saveset( EEGS, NamSetSong, pathOut);
%     end
%     
    
    
    
end