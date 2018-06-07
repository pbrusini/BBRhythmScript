pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_Reref_FieldTrip/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefMean_FieldTrip_ITC/';

ssList=dir([pathIn 'ssBCS*.mat']);


cfg = [];
cfg.method = 'wavelet';
cfg.output = 'fourier';                        % analysis 2 to 30 Hz in steps of 2 Hz
%cfg.t_ftimwin    = ones(length(cfg.foi),1).*2.1;   % length of time window = 0.5 sec
cfg.toi          = 0.1:0.01:1.5;
cfg.foi          = 1:1:30;
cfg.width        =1;
cfg.gwidth       =2;
cfg.pad          = 'nextpow2';

% make a new FieldTrip-style data structure containing the ITC
% copy the descriptive fields over from the frequency decomposition




for i=1:length(ssList)
    Babydata.Fre=[];
    Babydata.itc=[];
    load([pathIn ssList(i).name])
    FFTdata = ft_freqanalysis(cfg, FieldData);
    itc = [];
    itc.label     = FFTdata.label;
    itc.freq      = FFTdata.freq;
    itc.time      = FFTdata.time;
    itc.dimord    = 'chan_freq_time';
    %save([pathOut ssList(i).name],'FFTdata')
    
    F = FFTdata.fourierspctrm;   % copy the Fourier spectrum
    N = size(F,1);           % number of trials
    
    % compute inter-trial phase coherence (itpc)
    itc.itpc      = F./abs(F);         % divide by amplitude
    itc.itpc      = sum(itc.itpc,1);   % sum angles
    itc.itpc      = abs(itc.itpc)/N;   % take the absolute value and normalize
    itc.itpc      = squeeze(itc.itpc); % remove the first singleton dimension
    %itc.itpc      = mean(itc.itpc,1);
    
    % compute inter-trial linear coherence (itlc)
    itc.itlc      = sum(F) ./ (sqrt(N*sum(abs(F).^2)));
    itc.itlc      = abs(itc.itlc);     % take the absolute value, i.e. ignore phase
    itc.itlc      = squeeze(itc.itlc); % remove the first singleton dimension
    % itc.itlc      = mean(itc.itlc,1);
    
    Babydata.Fre=FFTdata
    Babydata.itc=itc
    babycode=ssList(i).name;
    babycode=babycode(1:length(babycode)-4);
    
    save([pathOut ssList(i).name],'Babydata','-v7.3')
    
    
end

figure
subplot(2, 1, 1);
imagesc(itc.time, itc.freq, squeeze(itc.itpc(65,:,:)));
axis xy
title('inter-trial phase coherence');
subplot(2, 1, 2);
imagesc(itc.time, itc.freq, squeeze(itc.itlc(65,:,:)));
axis xy
title('inter-trial linear coherence');