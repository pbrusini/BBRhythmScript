%% Construction of the Grand Varibale
pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefDetrendBase_TimeAvg_FFTSNR/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefDetrendBase_TimeAvg_FFTSNR_Cluster/';

ssListSyll=dir([pathIn 'ss*Syll.mat']);
ssListRest=dir([pathIn 'ss*Resting.mat']);
ssListDrum=dir([pathIn 'ss*Drum.mat']);
ssListSong=dir([pathIn 'ss*Song.mat']);


for i=1:length(ssListSyll)
    load([pathIn ssListSyll(i).name])
    
    cfg.keepindividual = 'yes';
   
    tmpTF(i,:,:,:)=squeeze(TFdata.phase);
    %tmpcrss(i,:,:,:)=squeeze(TFdata.crsspctrm);
    tmpName{i,:}=ssListSyll(i).name;
    %   tmpTF(i,:,:,:)=FieldData.trial{1,1};
    
    
end

PhaseGrandSylldata = TFdata;
PhaseGrandSylldata.powspctrm=squeeze(tmpTF);
PhaseGrandSylldata.Listsubj=tmpName;
PhaseGrandSylldata.dimord='subj_chan_freq';  %  PhaseGrandSylldata.dimord='subj_rpt_chan_freq'    watch out dimord of TF data
save([pathOut 'GrandSyllDataPhase__All' pathIn(59:65)],'PhaseGrandSylldata', '-v7.3')
clear tmpTF  tmpName

for i=1:length(ssListDrum)
    load([pathIn ssListDrum(i).name])
    %EGI = ft_prepare_layout(cfg, TFdata)
    cfg.keepindividual = 'yes';
    
    
    tmpTF(i,:,:,:)=squeeze(TFdata.phase);
    %tmpcrss(i,:,:,:)=squeeze(TFdata.crsspctrm);
    % tmpTF(i,:,:,:)=TFdata.phase{1,1};
    tmpName{i,:}=ssListDrum(i).name;
    
    
end

PhaseGrandDrumdata = TFdata;
PhaseGrandDrumdata.dimord='subj_chan_freq';
PhaseGrandDrumdata.powspctrm = squeeze(tmpTF);
PhaseGrandDrumdata.Listsubj=tmpName;
save([pathOut 'GrandDrumDataPhase__All' pathIn(59:65)],'PhaseGrandDrumdata','-v7.3' )
clear tmpTF  tmpName

for i=1:length(ssListRest)
    load([pathIn ssListRest(i).name])
    
    cfg.keepindividual = 'yes';
    
    tmpTF(i,:,:,:)=squeeze(TFdata.phase);
    %tmpcrss(i,:,:,:)=squeeze(TFdata.crsspctrm);
    tmpName{i,:}=ssListRest(i).name;
    
    % tmpTF(i,:,:,:)=TFdata.phase{1,1};
    
    
end

PhaseGrandRestdata = TFdata;
PhaseGrandRestdata.powspctrm = squeeze(tmpTF);
PhaseGrandRestdata.Listsubj=tmpName;
PhaseGrandRestdata.dimord='subj_chan_freq';
save([pathOut 'GrandRestDataPhase__All' pathIn(59:65)],'PhaseGrandRestdata','-v7.3')

clear tmpTF  tmpName

%%little Plot

bli=mean(PhaseGrandDrumdata.phase([6 9 12 11 3 14 19],:), 1);
bli=squeeze(bli);
bli=mean(bli, 1);
figure(500)
plot(bli(1:150));
hold on
bla=mean(PhaseGrandSylldata.phase([6 9 12 11 3 14 19],:), 1);
bla=squeeze(bla);
bla=mean(bla, 1);
plot(bla(1:150), 'r')
hold on
bl=mean(PhaseGrandRestdata.phase([6 9 12 11 3 14 19],:), 1);
bl=squeeze(bl);
bl=mean(bl, 1);
plot(bl(1:150), 'black')
freq= 0.125:0.125:80;
xticks([1 8 17 24 32 40 48 56 64 72 80]);
xticklabels({int2str(freq(1)), int2str(freq(8)), int2str(freq(17)), int2str(freq(24)), int2str(freq(32)), int2str(freq(40)), int2str(freq(48)), int2str(freq(56)), int2str(freq(64)), int2str(freq(72)), int2str(freq(80))});

bli=mean(PhaseGrandDrumdata.phase([46 44 45 42 40],:), 1);
bli=squeeze(bli);
bli=mean(bli, 1);
figure(501)
plot(bli(1:150));
hold on
bla=mean(PhaseGrandSylldata.phase([46 44 45 42 40],:), 1);
bla=squeeze(bla);
bla=mean(bla, 1);
plot(bla(1:150), 'r')
hold on
bl=mean(PhaseGrandRestdata.phase([46 44 45 42 40],:), 1);
bl=squeeze(bl);
bl=mean(bl, 1);
plot(bl(1:150), 'black')
freq= 0.125:0.125:80;
xticks([1 8 17 24 32 40 48 56 64 72 80]);
xticklabels({int2str(freq(1)), int2str(freq(8)), int2str(freq(17)), int2str(freq(24)), int2str(freq(32)), int2str(freq(40)), int2str(freq(48)), int2str(freq(56)), int2str(freq(64)), int2str(freq(72)), int2str(freq(80))});


%pause

% cfg = [];
% cfg.rotate =+180;
% EGI = ft_prepare_layout(cfg, TFdata);

cfg = [];
cfg.channel          = [6 9 12 11 3 14 19];
%cfg.latency          = [0 1.6];
cfg.frequency        =  [1 20];
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.01;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 0;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.01;
cfg.numrandomization = 10000;
load('EGI.mat')
cfg.layout           = EGI;
% prepare_neighbours determines what sensors may form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, PhaseGrandDrumdata);
cfg.dimord           ='subj_chan_freq';


design = zeros(1, length(ssListSyll) + length(ssListRest));
design(1, 1:length(ssListSyll))=1;
design(1, (length(ssListSyll)+1):(length(ssListSyll) + length(ssListRest)))=2;

cfg.design   = design';
cfg.ivar     = 1;

[statPhaseSyll] =  ft_freqstatistics(cfg, PhaseGrandSylldata, PhaseGrandRestdata)

meanSyll=mean(PhaseGrandSylldata.powspctrm);
meanSyll=squeeze(meanSyll);
meanRest=mean(PhaseGrandRestdata.powspctrm);
meanRest=squeeze(meanRest);
statPhaseSyll.raweffect = meanSyll- meanRest;
statPhaseSyll.raweffect(:,2,:)

save([pathOut 'statPhaseSyll'],'statPhaseSyll')

try
    cfg = [];
    cfg.alpha  = 0.1;
    cfg.parameter = 'stat';
    cfg.markers='labels';
    %  cfg.highlight    =  'labels';
    cfg.channel = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
    cfg.highlightseries = {'labels','labels','labels','labels','labels'};
    %cfg.highlightsizeseries =[8 8 8 8 8];
    cfg.layout = EGI;
    
    ft_clusterplot(cfg, statPhaseSyll);
catch
    display('no significant cluster')
end
%%

cfg = [];cfg.channel          = [6 9 12 11 3 14 19];
%cfg.latency          = [0 1.6];
cfg.frequency        =  [1 20];
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.01;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 0;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.01;
cfg.numrandomization = 10000;
cfg.layout           = EGI;
% prepare_neighbours determines what sensors may form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, PhaseGrandDrumdata);
cfg.dimord           ='subj_chan_freq';

design = zeros(1, length(ssListDrum) + length(ssListRest));
design(1, 1:length(ssListDrum))=1;
design(1, (length(ssListDrum)+1):(length(ssListDrum) + length(ssListRest)))=2;

cfg.design   = design';
cfg.ivar     = 1;

[statPhaseDrum] =  ft_freqstatistics(cfg, PhaseGrandDrumdata, PhaseGrandRestdata)

meanDrum=mean(PhaseGrandDrumdata.powspctrm);
meanDrum=squeeze(meanDrum);
meanRest=mean(PhaseGrandRestdata.powspctrm);
meanRest=squeeze(meanRest);
statPhaseDrum.raweffect = meanDrum- meanRest;
%stat.raweffect = stat.raweffect(:,2,:);

save([pathOut 'statPhaseDrum'],'statPhaseDrum');


try
    cfg = [];
    cfg.alpha  = 0.1;
    cfg.parameter = 'stat';
    cfg.markers='labels';
    cfg.highlight    =  'labels';
    cfg.channel = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
    cfg.highlightseries = {'labels','labels','labels','labels','labels'};
    %cfg.highlightsizeseries =[8 8 8 8 8];
    cfg.layout = EGI;
    
    ft_clusterplot(cfg, statPhaseDrum);
catch
    display('no significant cluster')
end


cfg = [];
cfg.channel          = [6 9 12 11 3 14 19];
%cfg.latency          = [0 1.6];
cfg.frequency        =  [1 20];
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.01;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 0;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.01;
cfg.numrandomization = 10000;
cfg.layout           = EGI;
% prepare_neighbours determines what sensors may form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, PhaseGrandDrumdata);
cfg.dimord           ='subj_chan_freq';

design = zeros(1, length(ssListDrum) + length(ssListSyll));
design(1, 1:length(ssListDrum))=1;
design(1, (length(ssListDrum)+1):(length(ssListDrum) + length(ssListSyll)))=2;

cfg.design   = design';
cfg.ivar     = 1;

[statPhaseDS] =  ft_freqstatistics(cfg, PhaseGrandDrumdata, PhaseGrandSylldata)

meanDrum=mean(PhaseGrandDrumdata.powspctrm);
meanDrum=squeeze(meanDrum);
meanSyll=mean(PhaseGrandSylldata.powspctrm);
meanSyll=squeeze(meanRest);
statDS.raweffect = meanSyll- meanDrum;
%stat.raweffect = stat.raweffect(:,2,:);

save([pathOut 'statPhaseDS'],'statPhaseDS');


try
    cfg = [];
    cfg.alpha  = 0.1;
    cfg.parameter = 'stat';
    cfg.markers='labels';
    cfg.highlight    =  'labels';
    cfg.channel = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
    cfg.highlightseries = {'labels','labels','labels','labels','labels'};
    %cfg.highlightsizeseries =[8 8 8 8 8];
    cfg.layout = EGI;
    
    ft_clusterplot(cfg, statPhaseDrum);
catch
    display('no significant cluster')
end


% % find significant channels
% sig_tiles = find(statPhaseSyll.mask); % find significant time-frequency tiles
% [chan freq time] = ind2sub(size(statPhaseSyll.mask),sig_tiles); % transform linear indices to subscript to extract significant channels, timepoints and frequencies
% chan = unique(chan);
%
% % plot TFRs
% cfg               = [];
% cfg.parameter     = 'stat';
% cfg.maskparameter = 'mask';
% cfg.maskalpha     = .4; % opacity value for non-significant parts
% cfg.zlim          = [-4 4];
% cfg.colorbar      = 'yes';
%
% % loop over channel sets and plot
% for ichan = 1:length(chan)
%     cfg.channel = chan(ichan);
%     figure, ft_singleplotTFR(cfg,statPhaseSyll),
% end


%%
% cfg = [];
% cfg.channel          = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
% %cfg.latency          = [0 1.6];;
% cfg.frequency        =  'all';
% cfg.method           = 'montecarlo';
% cfg.statistic        = 'ft_statfun_indepsamplesT';
% cfg.correctm         = 'cluster';
% cfg.clusteralpha     = 0.05;
% cfg.clusterstatistic = 'maxsum';
% cfg.minnbchan        = 0;
% cfg.tail             = 0;
% cfg.clustertail      = 0;
% cfg.alpha            = 0.05;
% cfg.numrandomization = 10000;
% cfg.layout           = EGI;
% % prepare_neighbours determines what sensors may form clusters
% cfg_neighb.method    = 'distance';
% cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, PhaseGrandDrumdata);
% cfg.dimord           ='subj_chan_freq';
%
%
% design = zeros(1, length(ssListSong) + length(ssListRest));
% design(1, 1:length(ssListSong))=1;
% design(1, (length(ssListSong)+1):(length(ssListSong) + length(ssListRest)))=2;
%
% cfg.design   = design';
% cfg.ivar     = 1;
%
% [statSong] =  ft_freqstatistics(cfg, TFGrandSongdata, PhaseGrandRestdata)
%
% meanSong=mean(PhaseGrandSylldata.powspctrm);
% meanSong=squeeze(meanSong);
% meanRest=mean(PhaseGrandRestdata.powspctrm);
% meanRest=squeeze(meanRest);
% statSong.raweffect = meanSong- meanRest;
%statSong.raweffect = statSong.raweffect(:,2,:);

% try
%     cfg = [];
%     cfg.alpha  = 0.05;
%     cfg.parameter = 'stat';
%     cfg.markers='labels';
%     cfg.highlight    =  'labels';
%     cfg.channel = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
%     cfg.highlightseries = {'labels','labels','labels','labels','labels'};
%     %cfg.highlightsizeseries =[8 8 8 8 8];
%     cfg.layout = EGI;
%     ft_clusterplot(cfg, statSong);
% end
