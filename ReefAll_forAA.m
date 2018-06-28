pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/6months/Event_Filtered_MarkedbyTrial_CleanByProb/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/6months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefDetrendBase/';
ssList=dir([pathIn 'ssBCS*Drum.set']);

for t =20:length(ssList)
    subjectName = [ ssList(t).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset(subjectName,pathIn);
    ElectLsit=[2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
    %% Reref and create echannel 65
    for i = 1:EEG.trials
        curData = EEG.data(1:64,:,i);
        meanData = mean(curData);
        
        for j = 1:length(ElectLsit) %for each good channel
            curData(ElectLsit( j),:) = curData(ElectLsit(j),:) - meanData;
        end
        
        EEG.data(1:64,:,i)=curData;
        EEG.data(65,:,i)= -meanData;
        %always add to the extra channel (65th, 129th or 257th)
    end
    EEG.nbchan=65;
    EEG.ref='averef';
    chanlocs='channel65.xyz';
    EEG=pop_chanedit(EEG,  'load',{ chanlocs, 'filetype', 'autodetect'});
    pop_saveset(EEG,subjectName, pathOut)
    
    %% Detrend to improve stationarity for ICA
    EEG.data = reshape(permute(EEG.data, [2 1 3]), [EEG.pnts EEG.nbchan * EEG.trials]);
    EEG.data = detrend(EEG.data);
    EEG.data = permute(reshape(EEG.data, [EEG.pnts EEG.nbchan EEG.trials]), [2 1 3]);
   
    %% Rm base

%     pop_saveset(EEG,subjectName, '/media/sdb/Data_RhythmProject/Data_Analysis/EEG_Analysis/EventReject/')
%      EEG = pop_rmbase( EEG, [-150  0]);
%      pop_saveset(EEG,subjectName, pathOut)
end