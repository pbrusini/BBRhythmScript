pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefDetrendBase/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefDetrendBase_FFTSNR/';
ssList=dir([pathIn 'ss*.mat']);

ssList2=dir([pathOut 'scrpt*.mat']);
%
cfg              = [];
cfg.channel      = 'all';
cfg.method       = 'mtmfft';  %from Power script
cfg.output       = 'fourier';    %from Power script
cfg.taper        = 'dpss';  % useful if method is hanning
cfg.keeptrials   = 'yes';  
cfg.taper        = 'dpss';
cfg.tapsmofrq    = 3;
cfg.foi          = 0.125:0.125:500; % 0:0.0610351562500000:500;         %from Power script                 % frequency of interest analysis
% % cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
% % cfg.toi          = 0.1:0.05:1.4;                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
cfg.pad          = 'nextpow2';
% %cfg.width        =1;
% %cfg.gwidth       =1;

for i=1:length(ssList)
    load([pathIn ssList(i).name])
    TFdata = ft_freqanalysis(cfg, FieldData);
%     
%     
% %     if size(wave,3)>4000
% %         wave=wave(:,:,151:4150)
% %     end
%     a = 5; % parameters from Nozaraden et al
%     b = 3; % parameters from Nozaraden et al
%     for t=1:length(FieldData.trial)
%         wave=FieldData.trial{1,t};
%         tmp(t,:,:)=FFT_SNR(wave, 'amplitude', 3, 5, 'subtract');
%     end
% %      powerSpect=squeeze(TFdata.powspctrm);
% % %     
% % %     % performs the noise cancellation. Takes an input from spectra()
% % %     
% %   
% % %     
% % %     wave=FieldData.trial{1,1};
% % %     samplerate=FieldData.fsample;
% % %     %[f,powerSpect] = spectra(wave,samplerate)
% % %     NFFT = 2^nextpow2(length(wave));
% % %     Y = fft(wave,NFFT)/length(wave);
% % %     f = samplerate/2*linspace(0,1,NFFT/2+1);
% % %     %^Y = fft(wave)/(length(wave)/2);
% % %     powerSpect = 2*abs(Y(:,1:NFFT/2+1));
% %     
% %     powerSpectTemp = zeros(size(powerSpect,1),length((a+1) : size(powerSpect,2)-a));
% %     parfor c = 1 : size(powerSpect,1)
% %         
% %         electrodeTemp = powerSpect(c,:);
% %         
% %         d2 = cell2mat(arrayfun(@(z) mean([electrodeTemp(z-a:z-b),electrodeTemp(z+b:z+a)]),...
% %             ((a+1) : size(electrodeTemp,2)-a),'UniformOutput',false));
% %         powerSpectTemp(c,:) = d2;
% %         
% %     end
% %     
% %     powerSpectOutput = zeros(size(powerSpect,1), size(powerSpect,2));
% %     powerSpectOutput(1:size(powerSpect,1),(a+1) : size(powerSpect,2)-a) = powerSpectTemp;
% %     
% %     TFdata.powspctrm=powerSpect;
% %     %TFdata.freq=f;
% %   
%     TFdata.powspctrm=tmp;
%     clear tmp
    save([pathOut ssList(i).name],'TFdata', '-v7.3')
    
    
    
    %     load ([pathOut ssList2(i).name])
    %     FieldData.trial=data;
    %     FieldData.time=0:0.1205:500;
    %     save([pathOut ssList2(i).name],'FieldData')
end