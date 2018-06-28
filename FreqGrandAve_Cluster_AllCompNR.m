pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered_MarkedbyTrial_CleanByProb_TimeAvg_FFTSNR/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/4months/Event_Filtered_MarkedbyTrial_CleanByProb_TimeAvg_FFTSNR_Cluster/';
% ssListSyll=dir([pathIn 'scrpt*Syll.mat']);
% ssListRest=dir([pathIn 'scrpt*Resting.mat']);
% ssListDrum=dir([pathIn 'scrpt*Drum.mat']);
% ssListSong=dir([pathIn 'scrpt*Song.mat']);

ssListSyll=dir([pathIn 'ss*Song2Hz.mat']);
ssListRest=dir([pathIn 'ss*Resting.mat']);
ssListDrum=dir([pathIn 'ss*Song1Hz.mat']);
ssListSong=dir([pathIn 'ss*Song.mat']);

tmpTF=[];  tmpName=[];  tmpPhase=[];  tmpMeanPhase=[];
for i=1:length(ssListSyll)
    load([pathIn ssListSyll(i).name])
    
    cfg.keepindividual = 'yes';
    
    if size(TFdata.powspctrm,2)>4000
        TFdata.powspctrm=TFdata.powspctrm;
    end
    
    tmpTF(i,:,:,:)=squeeze(mean(TFdata.powspctrm,1)); 
    tmpmeanPhase(i,:,:,:)=squeeze(mean(TFdata.phase,1));
    if size(TFdata.phase,1)<25
        for l=size(TFdata.phase,1):25
            TFdata.phase(l,:,:)=zeros(64,4000);
        end
    end
    tmpPhase(i,:,:,:)=TFdata.phase;
    tmpName=[tmpName, {ssListSyll(i).name}];
    %   tmpTF(i,:,:,:)=FieldData.trial{1,1};
    
    
end
TFGrandSylldata = TFdata;
TFGrandSylldata.powspctrm=squeeze(tmpTF);
TFGrandSylldata.meanPhase =  tmpmeanPhase;
TFGrandSylldata.phase=tmpPhase;
TFGrandSylldata.Listsubj=tmpName;
TFGrandSylldata.dimord='subj_chan_freq';  %  TFGrandSylldata.dimord='subj_rpt_chan_freq'    watch out dimord of TF data
save([pathOut 'GrandSyllData__All' pathIn(59:65)],'TFGrandSylldata', '-v7.3')

phaseClusterFrontSyll=mean(TFGrandSylldata.phase(:,:,[6 9 11 12 13 14 19],:),3);
phaseClusterParSyll=mean(TFGrandSylldata.phase(:,:,[45 40 42 46 44],:),3);
phaseClusterFrontSyll=squeeze(phaseClusterFrontSyll);
phaseClusterParSyll=squeeze(phaseClusterParSyll);

phaseClusterParSylltwoHertz=phaseClusterParSyll(:,:,17);
phaseClusterFrontSylltwoHertz=phaseClusterFrontSyll(:,:,17);

tmpTF=[];  tmpName=[];  tmpPhase=[]; tmpMeanPhase=[];
for i=1:length(ssListDrum)
    load([pathIn ssListDrum(i).name])
    %EGI = ft_prepare_layout(cfg, TFdata)
    cfg.keepindividual = 'yes';
    
    
    tmpTF(i,:,:,:)=squeeze(mean(TFdata.powspctrm,1));
    tmpmeanPhase(i,:,:,:)=squeeze(mean(TFdata.phase,1));
    if size(TFdata.phase,1)<25
        for u=size(TFdata.phase,1):25
            TFdata.phase(u,:,:)=zeros(64,4000);
        end
    end
    tmpPhase(i,:,:,:)=TFdata.phase;

    % tmpTF(i,:,:,:)=TFdata.powspctrm{1,1};
    tmpName=[tmpName, {ssListDrum(i).name}];
    
    
end
TFGrandDrumdata = TFdata;
TFGrandDrumdata.dimord='subj_chan_freq';
TFGrandDrumdata.powspctrm = squeeze(tmpTF);
TFGrandDrumdata.meanPhase =  tmpmeanPhase;
TFGrandDrumdata.phase=tmpPhase;
TFGrandDrumdata.Listsubj=tmpName;
save([pathOut 'GrandDrumData__All' pathIn(59:65)],'TFGrandDrumdata','-v7.3')

PowerTwoSyllFrontClust=mean(TFGrandSylldata.powspctrm(:, [6 9 11 12 13 14 19], 17),2);
MeanPhaseTwoSyllFrontClust=mean(TFGrandSylldata.meanPhase(:, [6 9 11 12 13 14 19], 17),2);

phaseClusterFrontDrum=mean(TFGrandDrumdata.phase(:,:,[6 9 11 12 13 14 19],:),3);
phaseClusterParDrum=mean(TFGrandDrumdata.phase(:,:,[45 40 42 46 44],:),3);
phaseClusterFrontDrum=squeeze(phaseClusterFrontDrum);
phaseClusterParDrum=squeeze(phaseClusterParDrum);

phaseClusterParDrumtwoHertz=phaseClusterParDrum(:,:,17);
phaseClusterFrontDrumtwoHertz=phaseClusterFrontDrum(:,:,17);

tmpTF=[];  tmpName=[]; tmpPhase=[];  tmpMeanPhase=[];
for i=1:length(ssListRest)
    load([pathIn ssListRest(i).name])
    
    cfg.keepindividual = 'yes';
    
   
    tmpTF(i,:,:,:)=squeeze(mean(TFdata.powspctrm,1));
    tmpmeanPhase(i,:,:,:)=squeeze(mean(TFdata.phase,1));
    if size(TFdata.phase,1)<25
        for u=size(TFdata.phase,1):25
            TFdata.phase(u,:,:)=zeros(64,4000);
        end
    end
    tmpPhase(i,:,:,:)=TFdata.phase;
    tmpName=[tmpName, {ssListRest(i).name}];
    
    % tmpTF(i,:,:,:)=TFdata.powspctrm{1,1};
    
    
end
TFGrandRestdata = TFdata;
TFGrandRestdata.powspctrm = squeeze(tmpTF);
TFGrandRestdata.meanPhase =  tmpmeanPhase;
TFGrandRestdata.phase=tmpPhase;
TFGrandRestdata.Listsubj=tmpName;
TFGrandRestdata.dimord='subj_chan_freq';
save([pathOut 'GrandRestData_All' pathIn(59:65)],'TFGrandRestdata','-v7.3')

phaseClusterFrontRest=mean(TFGrandRestdata.phase(:,:,[6 9 11 12 13 14 19],:),3);
phaseClusterParRest=mean(TFGrandRestdata.phase(:,:,[45 40 42 46 44],:),3);
phaseClusterFrontRest=squeeze(phaseClusterFrontRest);
phaseClusterParRest=squeeze(phaseClusterParRest);

phaseClusterParResttwoHertz=phaseClusterParRest(:,:,17);
phaseClusterFrontResttwoHertz=phaseClusterFrontRest(:,:,17);

% tmpTF=[]; tmpcrss=[];
% for i=1:length(ssListSong)
%     load([pathIn ssListSong(i).name])
%     
%     cfg.keepindividual = 'yes';
%         if size(TFdata.powspctrm,3)>4000
%         TFdata.powspctrm=TFdata.powspctrm
%     end
%     tmpTF(i,:,:,:)=TFdata.powspctrm;
%     tmpcrss(i,:,:,:)=TFdata.crsspctrm;
%     % tmpTF(i,:,:,:)=TFdata.powspctrm{1,1};
%     
%     
% end
% TFGrandSongdata = TFdata;
% TFGrandSongdata.powspctrm = squeeze(tmpTF);
% TFGrandSongdata.dimord='subj_chan_freq';
% save([pathOut 'GrandSongData_sqare'],'TFGrandSongdata')



bli=mean(TFGrandDrumdata.powspctrm, 1);
bli=squeeze(bli);
bli=mean(bli, 1);
figure(500)
plot(bli(1:80));
hold on
bla=mean(TFGrandSylldata.powspctrm, 1);
bla=squeeze(bla);
bla=mean(bla, 1);
plot(bla(1:80), 'r')
hold on
bl=mean(TFGrandRestdata.powspctrm, 1);
bl=squeeze(bl);
bl=mean(bl, 1);
plot(bl(1:80), 'black')
freq= 0.125:0.125:80;
xticks([1 8 17 24 32 40 48 56 64 72 80]);
xticklabels({int2str(freq(1)), int2str(freq(8)), int2str(freq(17)), int2str(freq(24)), int2str(freq(32)), int2str(freq(40)), int2str(freq(48)), int2str(freq(56)), int2str(freq(64)), int2str(freq(72)), int2str(freq(80))});


%pause

% cfg = [];
% cfg.rotate =+180;
% EGI = ft_prepare_layout(cfg, TFdata);

cfg = [];
cfg.channel          = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
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
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, TFGrandDrumdata);
cfg.dimord           ='subj_chan_freq';


design = zeros(1, length(ssListSyll) + length(ssListRest));
design(1, 1:length(ssListSyll))=1;
design(1, (length(ssListSyll)+1):(length(ssListSyll) + length(ssListRest)))=2;

cfg.design   = design';
cfg.ivar     = 1;

[statSyll] =  ft_freqstatistics(cfg, TFGrandSylldata, TFGrandRestdata)

meanSyll=mean(TFGrandSylldata.powspctrm);
meanSyll=squeeze(meanSyll);
meanRest=mean(TFGrandRestdata.powspctrm);
meanRest=squeeze(meanRest);
statSyll.raweffect = meanSyll- meanRest;
statSyll.raweffect(:,2,:)

save([pathOut 'statSyll'],'statSyll')

try
    cfg = [];
    cfg.alpha  = 0.01;
    cfg.parameter = 'stat';
    cfg.markers='labels';
    %  cfg.highlight    =  'labels';
    cfg.channel = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
    cfg.highlightseries = {'labels','labels','labels','labels','labels'};
    %cfg.highlightsizeseries =[8 8 8 8 8];
    cfg.layout = EGI;
    
    ft_clusterplot(cfg, statSyll);
catch
    display('no significant cluster')
end
%%

cfg = [];
cfg.channel          = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
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
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, TFGrandDrumdata);
cfg.dimord           ='subj_chan_freq';

design = zeros(1, length(ssListDrum) + length(ssListRest));
design(1, 1:length(ssListDrum))=1;
design(1, (length(ssListDrum)+1):(length(ssListDrum) + length(ssListRest)))=2;

cfg.design   = design';
cfg.ivar     = 1;

[statDrum] =  ft_freqstatistics(cfg, TFGrandDrumdata, TFGrandRestdata)

meanDrum=mean(TFGrandDrumdata.powspctrm);
meanDrum=squeeze(meanDrum);
meanRest=mean(TFGrandRestdata.powspctrm);
meanRest=squeeze(meanRest);
statDrum.raweffect = meanSyll- meanRest;
%stat.raweffect = stat.raweffect(:,2,:);

save([pathOut 'statDrum'],'statDrum');


try
    cfg = [];
    cfg.alpha  = 0.01;
    cfg.parameter = 'stat';
    cfg.markers='labels';
    cfg.highlight    =  'labels';
    cfg.channel = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
    cfg.highlightseries = {'labels','labels','labels','labels','labels'};
    %cfg.highlightsizeseries =[8 8 8 8 8];
    cfg.layout = EGI;
    
    ft_clusterplot(cfg, statDrum);
catch
    display('no significant cluster')
end


% % find significant channels
% sig_tiles = find(statSyll.mask); % find significant time-frequency tiles
% [chan freq time] = ind2sub(size(statSyll.mask),sig_tiles); % transform linear indices to subscript to extract significant channels, timepoints and frequencies
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
%     figure, ft_singleplotTFR(cfg,statSyll),
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
% cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, TFGrandDrumdata);
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
% [statSong] =  ft_freqstatistics(cfg, TFGrandSongdata, TFGrandRestdata)
%
% meanSong=mean(TFGrandSylldata.powspctrm);
% meanSong=squeeze(meanSong);
% meanRest=mean(TFGrandRestdata.powspctrm);
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
