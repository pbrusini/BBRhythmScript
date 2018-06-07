pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered_MarkedbyTrial/';
ssList=dir([pathIn '*.set']);


for i =1:length(ssList)
    subjectName = [ ssList(i).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    subjectNamex = char(subjectName(:,1:length(subjectName)-6))
    
    pattern='\w+(ta|TA)\w*\d+';
    Toanalyse=regexp(subjectNamex, pattern, 'match');
    if length(Toanalyse)>0
        continue
    end
    
    
    NamSetResting=[subjectNamex 'Resting.set'];
    NamSetSongOne=[subjectNamex 'Song1Hz.set'];
    NamSetSongMoreOne=[subjectNamex 'SongMore1Hz.set'];
    NamSetSongTwo=[subjectNamex 'Song2Hz.set'];
    NamSetSongMoreTwo=[subjectNamex 'SongMore2Hz.set'];
    
    EEG = pop_loadset(subjectName,pathIn);
    DebFile=[];
    Nr=[];
    Rest=[];
    
    
    %     try
    for ev=1:length(EEG.event)
        if strcmp(EEG.event(ev).type, 'TRSP')
            tempev=1;
            try
                while ~strcmp(EEG.event(ev+tempev).type, 'TRSP') & ev+tempev<length(EEG.event)
                    if strcmp(EEG.event(ev+tempev).type, 'DIN4')
                        if  tempev==1
                            EEG.event(ev).type='DINM';
                            DebFile=[DebFile ev];
                        end
                        EEG.event(ev+tempev).test=EEG.event(ev).test;
                        EEG.event(ev+tempev).cell=EEG.event(ev).cell;
                        EEG.event(ev+tempev).obss=EEG.event(ev).obss;
                        EEG.event(ev+tempev).song=EEG.event(ev).song;
                        EEG.event(ev+tempev).repe=EEG.event(ev).repe;
                        EEG.event(ev+tempev).numS=EEG.event(ev).numS;
                        
                    end
                    tempev=tempev+1;
                end
            end
            switch EEG.event(ev).test
                case 0
                    EEG.event(ev).type='TRS0';
                    Rest=[Rest ev];
                case 3
                    EEG.event(ev).type='TRS3';
                    
            end
            
            
        else
            switch EEG.event(ev).test                
                case 3
                    EEG.event(ev).type='DINR';
                    Nr=[Nr ev];
                otherwise
                    continue
            end
        end
    end%
    tmpMary=[]; tmpLitt=[];
    Songs=struct('Lond',[],'The_',[],'Ride', [], 'Simp', [], 'Lamb', [], 'When', [], 'Muff', [], 'Wint', [], 'Old', [], 'LitJ', [], 'Frer', [], 'Twin', [], 'Ring',[], 'Sing', [], 'Hick',[], 'JaJil',[], 'Incy',[], 'Mary', []);
    for ev=1:length(EEG.event)
        if strcmp(EEG.event(ev).type, 'DINR')
            
            if  EEG.event(ev).song=='Lond'
                Songs.Lond=[Songs.Lond ev];
            elseif    EEG.event(ev).song=='Ride'
                Songs.Ride=[Songs.Ride ev];
            elseif     EEG.event(ev).song=='Simp'
                Songs.Simp=[Songs.Simp ev];
            elseif    EEG.event(ev).song=='The_'
                Songs.The_=[Songs.The_ ev];
            elseif     EEG.event(ev).song=='Frer'
                Songs.Frer=[Songs.Frer ev];
            elseif     EEG.event(ev).song=='Hick'
                Songs.Hick=[Songs.Hick ev];
            elseif   EEG.event(ev).song=='Jack'
                Songs.LitJ=[Songs.LitJ ev];
            elseif   EEG.event(ev).song=='Bed_'
                Songs.Wint=[Songs.Wint ev];
            elseif      EEG.event(ev).song=='Twin'
                Songs.Twin=[Songs.Twin ev];
            elseif     EEG.event(ev).song=='Incy'
                Songs.Incy=[Songs.Incy ev];
            elseif EEG.event(ev).song=='Ring'
                Songs.Ring=[Songs.Ring ev];
            elseif    EEG.event(ev).song=='When'
                Songs.When=[Songs.When ev];
            elseif   EEG.event(ev).song=='Sing'
                Songs.Sing=[Songs.Sing ev];
            elseif  EEG.event(ev).song=='Ther'
                Songs.Old=[Songs.Old ev];
            elseif  EEG.event(ev).song=='Mary'
                ev
                if length(tmpMary)>0
                    if EEG.event(ev).obss==EEG.event(tmpMary(length(tmpMary))).obss & EEG.event(ev).repe==EEG.event(tmpMary(length(tmpMary))).repe
                        tmpMary=[tmpMary ev];
                    else
                        if length(tmpMary)>80
                            Songs.Lamb=[Songs.Lamb tmpMary];
                            tmpMary=[];
                        else
                            Songs.Mary=[Songs.Mary tmpMary];
                            tmpMary=[];
                        end
                    end
                else
                     tmpMary=[tmpMary ev];
                end
            elseif  EEG.event(ev).song=='Litt'
                if length(tmpLitt)>0
                    if EEG.event(ev).obss==EEG.event(tmpLitt(length(tmpLitt))).obss  & EEG.event(ev).repe==EEG.event(tmpLitt(length(tmpLitt))).repe
                        tmpLitt=[tmpLitt ev];
                    else
                        if length(tmpLitt)>50
                            Songs.JaJil=[Songs.JaJil tmpLitt];
                            tmpLitt=[];
                        else
                            Songs.Muff=[Songs.Muff tmpLitt];
                            tmpLitt=[];
                        end
                    end
                else
                    tmpLitt=[tmpLitt ev];
                end
            end
        end
    end
   
    b=2
    while b<450
        try
            if b==2 || strcmp(EEG.event(Songs.Lamb(b)-2).type,'TRS3' )
                EEG.event(Songs.Lamb(b)).type='D1Hz';
                tempLamb=b;
            elseif (EEG.event(Songs.Lamb(b)).latency - EEG.event(Songs.Lamb(tempLamb)).latency)/1000>=8 && EEG.event(Songs.Lamb(b)).repe==EEG.event(Songs.Lamb(tempLamb)).repe
                EEG.event(Songs.Lamb(b)).type='D1Hz';
                tempLamb=b;
            end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.Lond(b)-2).type,'TRS3' )
                EEG.event(Songs.Lond(b)).type='D1Hz';
                tempLond=b;
            elseif (EEG.event(Songs.Lond(b)).latency - EEG.event(Songs.Lond(tempLond)).latency)/1000>=8 && EEG.event(Songs.Lond(b)).repe==EEG.event(Songs.Lond(tempLond)).repe
                EEG.event(Songs.Lond(b)).type='D1Hz';
                tempLond=b;
            end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.The_(b)-2).type,'TRS3' )
                EEG.event(Songs.The_(b)).type='D1Hz';
                tempThe=b;
            elseif (EEG.event(Songs.The_(b)).latency - EEG.event(Songs.The_(tempThe)).latency)/1000>=8 && EEG.event(Songs.The_(b)).repe==EEG.event(Songs.The_(tempThe)).repe
                EEG.event(Songs.The_(b)).type='D1Hz';
                tempThe=b;
            end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.Ride(b)-2).type,'TRS3' )
                EEG.event(Songs.Ride(b)).type='D1Hz';
                tempRide=b;
            elseif (EEG.event(Songs.Ride(b)).latency - EEG.event(Songs.Ride(tempRide)).latency)/1000>=8 && EEG.event(Songs.Ride(b)).repe==EEG.event(Songs.Ride(tempRide)).repe
                EEG.event(Songs.Ride(b)).type='D1Hz';
                tempRide=b;
            end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.Wint(b)-2).type,'TRS3' )
                EEG.event(Songs.Wint(b)).type='D1.5';
                tempWint=b;
            elseif (EEG.event(Songs.Wint(b)).latency - EEG.event(Songs.Wint(tempWint)).latency)/1000>=8 && EEG.event(Songs.Wint(b)).repe==EEG.event(Songs.Wint(tempWint)).repe
                EEG.event(Songs.Wint(b)).type='D1.5';
                tempWint=b;
            end
        end
        %         try
        %             EEG.event(Songs.Old(b)).type='D1.5';
        %         end
        try
            if b==2 || strcmp(EEG.event(Songs.LitJ(b)-2).type,'TRS3' )
                EEG.event(Songs.LitJ(b)).type='D1.5';
                tempLitJ=b;
            elseif (EEG.event(Songs.LitJ(b)).latency - EEG.event(Songs.LitJ(tempLitJ)).latency)/1000>=8 && EEG.event(Songs.LitJ(b)).repe==EEG.event(Songs.LitJ(tempLitJ)).repe
                EEG.event(Songs.LitJ(b)).type='D1.5';
                tempLitJ=b;
            end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.Incy(b)-2).type,'TRS3' )
                EEG.event(Songs.Incy(b)).type='D1.5';
                tempIncy=b;
            elseif (EEG.event(Songs.Incy(b)).latency - EEG.event(Songs.Incy(tempIncy)).latency)/1000>=8 && EEG.event(Songs.Incy(b)).repe==EEG.event(Songs.Incy(tempIncy)).repe
                EEG.event(Songs.Incy(b)).type='D1.5';
                tempIncy=b;
            end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.When(b)-2).type,'TRS3' )
                EEG.event(Songs.When(b)).type='D1.5';
                tempWhen=b;
            elseif (EEG.event(Songs.When(b)).latency - EEG.event(Songs.When(tempWhen)).latency)/1000>=8 && EEG.event(Songs.When(b)).repe==EEG.event(Songs.When(tempWhen)).repe
                EEG.event(Songs.When(b)).type='D1.5';
                tempWhen=b;
            end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.Muff(b)-2).type,'TRS3' )
                EEG.event(Songs.Muff(b)).type='D1.5';
                tempMuff=b;
            elseif (EEG.event(Songs.Muff(b)).latency - EEG.event(Songs.Muff(tempMuff)).latency)/1000>=8 && EEG.event(Songs.Muff(b)).repe==EEG.event(Songs.Muff(tempMuff)).repe
                EEG.event(Songs.Muff(b)).type='D1.5';
                tempMuff=b;
            end
        end
        
        
        try
             if b==2 || strcmp(EEG.event(Songs.Ring(b)-2).type,'TRS3' )
            EEG.event(Songs.Ring(b)).type='D2Hz';
            tempRing=b;
            elseif (EEG.event(Songs.Ring(b)).latency - EEG.event(Songs.Ring(tempRing)).latency)/1000>=8 && EEG.event(Songs.Ring(b)).repe==EEG.event(Songs.Ring(tempRing)).repe
             EEG.event(Songs.Ring(b)).type='D2Hz';
            tempRing=b;
             end
        end
        try
             if b==2 || strcmp(EEG.event(Songs.Hick(b)-2).type,'TRS3' )
            EEG.event(Songs.Hick(b)).type='D2Hz';
            tempHick=b;
             elseif (EEG.event(Songs.Hick(b)).latency - EEG.event(Songs.Hick(tempRing)).latency)/1000>=8 && EEG.event(Songs.Hick(b)).repe==EEG.event(Songs.Ring(tempRing)).repe
              EEG.event(Songs.Hick(b)).type='D2Hz';
            tempHick=b;
             end
            
        end
        try
            if b==2 || strcmp(EEG.event(Songs.Sing(b)-2).type,'TRS3' )
            EEG.event(Songs.Sing(b)).type='D2Hz';
            tempSing=b;
            elseif (EEG.event(Songs.Sing(b)).latency - EEG.event(Songs.Sing(tempSing)).latency)/1000>=8 && EEG.event(Songs.Sing(b)).repe==EEG.event(Songs.Sing(tempSing)).repe
             EEG.event(Songs.Sing(b)).type='D2Hz';
            tempSing=b;
            end
        end
        try
             if b==2 || strcmp(EEG.event(Songs.JaJil(b)-2).type,'TRS3' )
            EEG.event(Songs.JaJil(b)).type='D2Hz';
            tempJaJil=b;
             elseif (EEG.event(Songs.JaJil(b)).latency - EEG.event(Songs.JaJil(tempJaJil)).latency)/1000>=8 && EEG.event(Songs.JaJil(b)).repe==EEG.event(Songs.JaJil(tempJaJil)).repe
              EEG.event(Songs.JaJil(b)).type='D2Hz';
            tempJaJil=b;
             end
        end
        try
            if b==2 || strcmp(EEG.event(Songs.Twin(b)-2).type,'TRS3' )
            EEG.event(Songs.Twin(b)).type='D2Hz';
            tempTwin=b;
             elseif (EEG.event(Songs.Twin(b)).latency - EEG.event(Songs.Twin(tempTwin)).latency)/1000>=8 && EEG.event(Songs.Twin(b)).repe==EEG.event(Songs.Twin(tempTwin)).repe
              EEG.event(Songs.Twin(b)).type='D2Hz';
            tempTwin=b;
            end
        end
        
        
        try
             if b==2 || strcmp(EEG.event(Songs.Frer(b)-2).type,'TRS3' )
            EEG.event(Songs.Frer(b)).type='D2.5';
            tempFrer=b;
             elseif (EEG.event(Songs.Frer(b)).latency - EEG.event(Songs.Frer(tempFrer)).latency)/1000>=8 && EEG.event(Songs.Frer(b)).repe==EEG.event(Songs.Frer(tempFrer)).repe
                EEG.event(Songs.Frer(b)).type='D2.5';
            tempFrer=b;
             end
        end
        try
             if b==2 || strcmp(EEG.event(Songs.Mary(b)-2).type,'TRS3' )
            EEG.event(Songs.Mary(b)).type='D2.5';
            tempMary=b;
             elseif (EEG.event(Songs.Mary(b)).latency - EEG.event(Songs.Mary(tempMary)).latency)/1000>=8 && EEG.event(Songs.Mary(b)).repe==EEG.event(Songs.Mary(tempMary)).repe
                 EEG.event(Songs.Mary(b)).type='D2.5';
            tempMary=b;
             end
        end
        try
             if b==2 || strcmp(EEG.event(Songs.Simp(b)-2).type,'TRS3' )
                EEG.event(Songs.Simp(b)).type='D2.5';
                tempSimp=b;
            elseif (EEG.event(Songs.Simp(b)).latency - EEG.event(Songs.Simp(tempSimp)).latency)/1000>=8 && EEG.event(Songs.Simp(b)).repe==EEG.event(Songs.Simp(tempSimp)).repe
                EEG.event(Songs.Simp(b)).type='D2.5';
                tempSimp=b;
            end
        end
        b=b+1;
    end
    
    try
        
        EEGO = pop_epoch( EEG, { 'D1Hz' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGO = pop_rmbase( EEGO, [0  8000]);
        EEGO = pop_saveset( EEGO, NamSetSongOne, pathOut);
        
        %   [ALLEEG EEGR CURRENTSET] = eeg_store(ALLEEG, EEGR);
    end
    try
        EEGD = pop_epoch( EEG, { 'D1.5' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGD = pop_rmbase( EEGD, [0  8000]);
        EEGD = pop_saveset( EEGD, SongMoreOne, pathOut);
        
    end
    try
        
        EEGS = pop_epoch( EEG, { 'D2Hz' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGS = pop_rmbase( EEGS, [0  8000]);
        EEGS = pop_saveset( EEGS, NamSetSongTwo, pathOut);
    end
    
     try
        
        EEGR = pop_epoch( EEG, { 'D2.5' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGR = pop_rmbase( EEGR, [0  8000]);
        EEGR = pop_saveset( EEGR, NamSetSyll, pathOut);
    end
        
%     NamSetResting=[subjectNamex 'Resting.set'];
%     =[subjectNamex 'Song1Hz.set'];  
%     NamSet=[subjectNamex 'SongMore1Hz.set'];  
%     =[subjectNamex 'Song2Hz.set']; Ring Hick Sing JaJil Twin
%     NamSetSongMoreTwo=[subjectNamex 'SongMore2Hz.set']; Frer Mary Simp
    
end
                

