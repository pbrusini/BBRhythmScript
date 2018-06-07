pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefMean_FieldTrip_FourierTransform/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial_CleanByProb_RerefMean_FieldTrip_FreqGrandAver/';
ssListSyll=dir([pathIn 'scrpt*Syll.mat']);
ssListRest=dir([pathIn 'scrpt*Resting.mat']);
ssListDrum=dir([pathIn 'scrpt*Drum.mat']);
ssListSong=dir([pathIn 'scrpt*Song.mat']);

tmpTF=[];
for i=1:length(ssListSyll)
    load([pathIn ssListSyll(i).name])
    
    cfg.keepindividual = 'yes';
    
    
   tmpTF(i,:,:,:)=TFdata.powspctrm;
 %   tmpTF(i,:,:,:)=FieldData.trial{1,1};
    
    
end
TFGrandSylldata = TFdata;
TFGrandSylldata.powspctrm=tmpTF;
TFGrandSylldata.dimord='subj_chan_freq_time';
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
TFGrandDrumdata.dimord='subj_chan_freq_time';
TFGrandDrumdata.powspctrm = tmpTF;
save([pathOut 'GrandDrumData_sqare'],'TFGrandDrumdata')

tmpTF=[];
for i=1:length(ssListRest)
    load([pathIn ssListRest(i).name])
 
    cfg.keepindividual = 'yes';
    
   tmpTF(i,:,:,:)=TFdata.powspctrm;
   % tmpTF(i,:,:,:)=TFdata.powspctrm{1,1};
    
    
end
TFGrandRestdata = TFdata;
TFGrandRestdata.powspctrm = tmpTF;
TFGrandRestdata.dimord='subj_chan_freq_time';
save([pathOut 'GrandRestData_sqare'],'TFGrandRestdata')

tmpTF=[];
for i=1:length(ssListSong)
    load([pathIn ssListSong(i).name])
 
    cfg.keepindividual = 'yes';
    
   tmpTF(i,:,:,:)=TFdata.powspctrm;
   % tmpTF(i,:,:,:)=TFdata.powspctrm{1,1};
    
    
end
TFGrandSongdata = TFdata;
TFGrandSongdata.powspctrm = tmpTF;
TFGrandSongdata.dimord='subj_chan_freq_time';
save([pathOut 'GrandRestData_sqare'],'TFGrandRestdata')


% cfg = [];
% cfg.rotate =+180;
% EGI = ft_prepare_layout(cfg, TFdata);

cfg = [];
cfg.channel          = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
cfg.latency          = 0.2;
cfg.frequency        =  'all';
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.1;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 0;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.1;
cfg.numrandomization = 10000;
cfg.layout           = EGI;
% prepare_neighbours determines what sensors may form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, TFGrandDrumdata);
cfg.dimord           ='subj_chan_freq_time';


subj = 22;
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

[stat] =  ft_freqstatistics(cfg, TFGrandSylldata, TFGrandRestdata)

meanSyll=mean(TFGrandSylldata.powspctrm);
meanSyll=squeeze(meanSyll);
meanRest=mean(TFGrandRestdata.powspctrm);
meanRest=squeeze(meanRest);
stat.raweffect = meanSyll- meanRest;
stat.raweffect = stat.raweffect(:,2,:);

cfg = [];
cfg.alpha  = 0.3;
cfg.parameter = 'stat';
cfg.markers='labels';
cfg.highlight    =  'labels';
cfg.channel = [2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60];
cfg.highlightseries = {'labels','labels','labels','labels','labels'};
%cfg.highlightsizeseries =[8 8 8 8 8];
cfg.layout = EGI;
ft_clusterplot(cfg, stat);
