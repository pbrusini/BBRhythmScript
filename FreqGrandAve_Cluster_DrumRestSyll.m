pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefMean_FieldTrip_FourierTransform/CompDrumRestSyll/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefMean_FieldTrip_FreqGrandAver/';
ssListSyll=dir([pathIn 'ssBCS*Syll.mat']);
ssListRest=dir([pathIn 'ssBCS*Resting.mat']);
ssListDrum=dir([pathIn 'ssBCS*Drum.mat']);
ssListSong=dir([pathIn 'ssBCS*Song.mat']);

tmpTF=[];
for i=1:length(ssListSyll)
    load([pathIn ssListSyll(i).name])
    
    cfg.keepindividual = 'yes';
    
    
   tmpTF(i,:,:,:)=TFdata.powspctrm;
 %   tmpTF(i,:,:,:)=FieldData.trial{1,1};
    
    
end
TFGrandSylldata = TFdata;
TFGrandSylldata.powspctrm=squeeze(tmpTF);
TFGrandSylldata.dimord='subj_chan_freq';
save([pathOut 'GrandSyllData_sqare'],'TFGrandSylldata')

tmpTF=[];
for i=1:length(ssListDrum)
    load([pathIn ssListDrum(i).name])
    %EGI = ft_prepare_layout(cfg, TFdata)
    cfg.keepindividual = 'yes';
    
  tmpTF(i,:,:,:)=TFdata.powspctrm;
   % tmpTF(i,:,:,:)=TFdata.powspctrm{1,1};
    
    
end
TFGrandDrumdata = TFdata;
TFGrandDrumdata.dimord='subj_chan_freq';
TFGrandDrumdata.powspctrm = squeeze(tmpTF);
save([pathOut 'GrandDrumData_sqare'],'TFGrandDrumdata')

tmpTF=[];
for i=1:length(ssListRest)
    load([pathIn ssListRest(i).name])
 
    cfg.keepindividual = 'yes';
    
   tmpTF(i,:,:,:)=TFdata.powspctrm;
   % tmpTF(i,:,:,:)=TFdata.powspctrm{1,1};
    
    
end
TFGrandRestdata = TFdata;
TFGrandRestdata.powspctrm = squeeze(tmpTF);
TFGrandRestdata.dimord='subj_chan_freq';
save([pathOut 'GrandRestData_sqare'],'TFGrandRestdata')



% cfg = [];
% cfg.rotate =+180;
% EGI = ft_prepare_layout(cfg, TFdata);

cfg = [];
cfg.channel          = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
%cfg.latency          = 0.5;
cfg.frequency        =  'all';
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 1;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.05;
cfg.numrandomization = 10000;
cfg.layout           = EGI;
% prepare_neighbours determines what sensors may form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, TFGrandDrumdata);
cfg.dimord           ='subj_chan_freq_time';


subj = length(ssListDrum)
design = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design   = design';
cfg.uvar     = 1;
cfg.ivar     = 2;

[statDrum] =  ft_freqstatistics(cfg, TFGrandDrumdata, TFGrandRestdata)
save([pathOut 'statDrum'],'statDrum')

meanDrum=mean(TFGrandDrumdata.powspctrm);
meanDrum=squeeze(meanDrum);
meanRest=mean(TFGrandRestdata.powspctrm);
meanRest=squeeze(meanRest);
statDrum.raweffect = meanSyll- meanRest;
%stat.raweffect = stat.raweffect(:,2,:);



[statSyll] =  ft_freqstatistics(cfg, TFGrandSylldata, TFGrandRestdata)
save([pathOut 'statSyll'],'statSyll')

meanSyll=mean(TFGrandSylldata.powspctrm);
meanSyll=squeeze(meanSyll);
meanRest=mean(TFGrandRestdata.powspctrm);
meanRest=squeeze(meanRest);
statSyll.raweffect = meanSyll- meanRest;
%statSyll.raweffect = stat.raweffect(:,2,:);



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
    ft_clusterplot(cfg, statDrum);
end


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
    ft_clusterplot(cfg, statSyll);
end



DiffDrum=TFGrandDrumdata.powspctrm-TFGrandRestdata.powspctrm;
ClustDiffDrum=DiffDrum(:,[5 2 6 11 12 13 14 ], 2)
MeanClusDiffDrum=mean(ClustDiffDrum,2)


DiffSyll=TFGrandSylldata.powspctrm-TFGrandRestdata.powspctrm;
ClustDiffSylFront=DiffSyll(:,[5 2 6 11 12 13 14 ], 2)
MeanClusDiffSyllFront=mean(ClustDiffSylFront,2)

ClustDiffSylTempR=DiffSyll(:,[44 45 46 39 40 36], 2)
MeanClusDiffSyllTempR=mean(ClustDiffSylTempR,2)

ClustDiffSylFront=DiffSyll(:,[5 2 6 11 12 13 14 ], 4)
MeanClusDiffSyllFrontFour=mean(ClustDiffSylFront,2)

ClustDiffSylTempR=DiffSyll(:,[44 45 46 39 40 36], 4)
MeanClusDiffSyllTempRFour=mean(ClustDiffSylTempR,2)


figure(200)
bar(MeanClusDiffDrum)
figure(400)
bar(MeanClusDiffSyllFront, 'r')
figure(500)
bar(MeanClusDiffSyllTempR, 'r')


Diff=TFGrandSylldata.powspctrm-TFGrandDrumdata.powspctrm;
ClustDiff=Diff(:,[11 6 12 13 19 14 ], 2)
MeanClusDiff=mean(ClustDiffSyl,2)

figure(300)
bar(MeanClusDiff)



for i=1:[1 2 3 4  6 7 13 18 22 23 27 29 30 34 39 40 41 42 45 46 50  51]
    BBdata
