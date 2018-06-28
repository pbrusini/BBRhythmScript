pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/6months/Event_Filtered_MarkedbyTrial_CleanByProb/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/6months/Event_Filtered_MarkedbyTrial_CleanByProb/';

ssList=dir([pathIn 'ss*.set']);

for t =1:length(ssList)
    subjectName = [ ssList(t).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    subjectNamex=char(subjectName(1:length(subjectName)-4));
    EEG = pop_loadset(subjectName,pathIn);
%  
%     EEG.nbchan=65;
%     EEG.ref='averef';
%     chanlocs='/home/perrine/Dropbox/Experience/Imagerie/eeglab_modifP/sample_locs/GSNReal65v2_0.sfp';
%     EEG=pop_chanedit(EEG,  'load',{ chanlocs, 'filetype', 'autodetect'});

if size(EEG.data,3) < 25
    nbr=size(EEG.data,3);
    EEG.data=EEG.data;
    nbr=EEG.epoch;
else
    tmp=randperm(5);
    nbr=20+tmp(1);
    EEG.data=(EEG.data(:,:,1:nbr)),3;
end
try
    EEG.event=EEG.event(1);
    EEG.urevent=EEG.urevent(1);
    EEG.epoch=EEG.epoch(:,1:nbr);
    EEG.trials=nbr;
end

%EEG.data=fft(EEG.data);

FieldData=eeglab2fieldtrip(EEG, 'preprocessing', 'none');
FieldData.subject=subjectNamex;
FieldData.Nbtrial=nbr;
save([pathIn subjectNamex '.mat'],'FieldData')

end