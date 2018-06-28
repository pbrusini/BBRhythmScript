clear; close all;

%load goodchannels

pathIn='/media/sdb/Data_RhythmProject/Data_Analysis/EEG_Analysis/EventReject/';
pathOut='/media/sdb/Data_RhythmProject/Data_Analysis/EEG_Analysis/EventReject/';
ssList=dir([pathIn '*.set']);



%%


parfor s = 1:length(f)
%for s = 1:2
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    EEG = pop_loadset('filename',f(s).name,'filepath',INPath);
    
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % Re referencing, to test if improves ICA decomposition
    %EEG = pop_reref( EEG, []);
    
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',fullfile(OUTPath, [f(s).name(1:end-4),'_ICA.set']),'overwrite','on','gui','off'); 
    
end