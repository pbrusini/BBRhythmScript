pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb/';
pathOutM='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_TimeAvg/';

ssList=dir([pathIn 'ssBCS*.set']);

for i =1:length(ssList)
    subjectName = [ ssList(i).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset(subjectName,pathIn);
    
    subjectNamex=char(subjectName(1:length(subjectName)-4));
    
    if size(EEG.data,3)>40
        EEG.data=mean(EEG.data(:,:,1:40),3);
        nbr=40;
    else
        EEG.data=mean(EEG.data,3);
        nbr=EEG.epoch;
    end
    try
        EEG.event=EEG.event(1);
        EEG.urevent=EEG.urevent(1);
        EEG.epoch=1;
    end
    EEG = pop_saveset( EEG,subjectName, pathOutM);
    if EEG.srate<1000
        EEG=pop_resample(EEG, 1000)
        EEG = pop_saveset( EEG,subjectName, pathOutM);
    end
    
%     EEG.nbchan=65;
%     EEG.ref='averef';
    chanlocs='/home/perrine/Dropbox/Experience/Imagerie/eeglab_modifP/sample_locs/GSNReal64v2_0.sfp';
    EEG=pop_chanedit(EEG,  'load',{ chanlocs, 'filetype', 'autodetect'});

    FieldData=eeglab2fieldtrip(EEG, 'preprocessing', 'none');
    FieldData.subject=subjectNamex;
    FieldData.Nbtrial=nbr;
    save([pathOutM subjectNamex '.mat'],'FieldData')
    
    EEG = pop_saveset( EEG,subjectName, pathOutM);
    
end
