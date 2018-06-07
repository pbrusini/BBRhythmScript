AllSubjKept=[TFGrandRestdataTwoMo.Listsubj TFGrandSylldataTwoMo.Listsubj TFGrandDrumdataTwoMo.Listsubj TFGrandRestdataSixMo.Listsubj TFGrandSylldataSixMo.Listsubj TFGrandDrumdataSixMo.Listsubj TFGrandRestdataNineMo.Listsubj TFGrandSylldataNineMo.Listsubj TFGrandDrumdataNineMo.Listsubj]


DiffDrum=TFGrandDrumdata.powspctrm-TFGrandRestdata.powspctrm;
ClustDiffDrum=DiffDrum(:,[10 11 12 6 ], 17)
MeanClusDiffDrum=mean(ClustDiffDrum,2);


DiffSyll=TFGrandSylldata.powspctrm-TFGrandRestdata.powspctrm;
ClustDiffSyl=DiffSyll(:,[10 11 12 6 ],17)
MeanClusDiffSyll=mean(ClustDiffSyl,2);

figure(200)
bar(MeanClusDiffDrum)
hold on
bar(MeanClusDiffSyll, 'r')

Diff=TFGrandSylldata.powspctrm-TFGrandDrumdata.powspctrm;
ClustDiff=DiffSyll(:,[10 11 12 6], 2, 5)
MeanClusDiff=mean(ClustDiffSyl,2)

bli=mean(TFGrandDrumdataTwoMo.powspctrm, 1);
bli=squeeze(bli);
bli=mean(bli, 1);
figure(500)
plot(bli(1:80));
hold on
bla=mean(TFGrandDrumdataSixMo.powspctrm, 1);
bla=squeeze(bla);
bla=mean(bla, 1);
plot(bla(1:80), 'r')
hold on
bl=mean(TFGrandDrumdataNineMo.powspctrm, 1);
bl=squeeze(bl);
bl=mean(bl, 1);
plot(bl(1:80), 'black')
freq= 0.125:0.125:80;
xticks([1 8 17 24 32 40 48 56 64 72 80]);
xticklabels({int2str(freq(1)), int2str(freq(8)), int2str(freq(17)), int2str(freq(24)), int2str(freq(32)), int2str(freq(40)), int2str(freq(48)), int2str(freq(56)), int2str(freq(64)), int2str(freq(72)), int2str(freq(80))});

elect=[2:16 18:22 24:28 30 31 33:42 44:46 48:54 56:60]; %all
elect=[6 9 11 12 13 19]; %cluster 1
elect=[46 45 44 42 40]; %cluster 2

LL_Drum_twomo = squeeze(mean(mean(TFGrandDrumdataTwoMo.powspctrm(:,elect,:),2),1));
LL_Drum_twomostd =squeeze(std(mean(TFGrandDrumdataTwoMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandDrumdataTwoMo.powspctrm,1));
LL_Drum_sixmo = squeeze(mean(mean(TFGrandDrumdataSixMo.powspctrm(:,elect,:),2),1));
LL_Drum_sixmostd = squeeze(std(mean(TFGrandDrumdataSixMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandDrumdataSixMo.powspctrm,1));
LL_Drum_ninemo = squeeze(mean(mean(TFGrandDrumdataNineMo.powspctrm(:,elect,:),2),1));
LL_Drum_ninemostd = squeeze(std(mean(TFGrandDrumdataNineMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandDrumdataNineMo.powspctrm,1));

LL_Syll_twomo = squeeze(mean(mean(TFGrandSylldataTwoMo.powspctrm(:,elect,:),2),1));
LL_Syll_twomostd =squeeze(std(mean(TFGrandSylldataTwoMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandSylldataTwoMo.powspctrm,1));
LL_Syll_sixmo = squeeze(mean(mean(TFGrandSylldataSixMo.powspctrm(:,elect,:),2),1));
LL_Syll_sixmostd = squeeze(std(mean(TFGrandSylldataSixMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandSylldataSixMo.powspctrm,1));
LL_Syll_ninemo = squeeze(mean(mean(TFGrandDrumdataNineMo.powspctrm(:,elect,:),2),1));
LL_Syll_ninemostd = squeeze(std(mean(TFGrandSylldataNineMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandSylldataNineMo.powspctrm,1));

LL_Rest_twomo = squeeze(mean(mean(TFGrandRestdataTwoMo.powspctrm(:,elect,:),2),1));
LL_Rest_twomostd =squeeze(std(mean(TFGrandRestdataTwoMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandRestdataTwoMo.powspctrm,1));
LL_Rest_sixmo = squeeze(mean(mean(TFGrandRestdataSixMo.powspctrm(:,elect,:),2),1));
LL_Rest_sixmostd = squeeze(std(mean(TFGrandRestdataSixMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandRestdataSixMo.powspctrm,1));
LL_Rest_ninemo = squeeze(mean(mean(TFGrandRestdataNineMo.powspctrm(:,elect,:),2),1));
LL_Rest_ninemostd = squeeze(std(mean(TFGrandRestdataNineMo.powspctrm(:,elect,:),2),0,1))/sqrt(size(TFGrandRestdataNineMo.powspctrm,1));


freq=[0.125:0.125:500];
%time=timesh


figure(3)
subplot(3,1,1);
[l,p] = boundedline(freq(7:70), LL_Drum_twomo(7:70), LL_Drum_twomostd(7:70), 'b', freq(7:70), LL_Syll_twomo(7:70), LL_Syll_twomostd(7:70), 'r', freq(7:70), LL_Rest_twomo(7:70), LL_Rest_twomostd(7:70), 'black','alpha');
%outlinebounds(l,p);
title('Frequency power all Condition 2mo');
subplot(3,1,2);
[l,p] = boundedline(freq(7:70), LL_Drum_sixmo(7:70), LL_Drum_sixmostd(7:70), 'b', freq(7:70), LL_Syll_sixmo(7:70), LL_Syll_sixmostd(7:70), 'r', freq(7:70), LL_Rest_sixmo(7:70), LL_Rest_sixmostd(7:70), 'black','alpha');
%outlinebounds(l,p);
title('Frequency power all Condition 6mo');
subplot(3,1,3);
[l,p] = boundedline(freq(7:70), LL_Drum_ninemo(7:70), LL_Drum_ninemostd(7:70), 'b', freq(7:70), LL_Syll_ninemo(7:70), LL_Syll_ninemostd(7:70), 'r', freq(7:70), LL_Rest_ninemo(7:70), LL_Rest_ninemostd(7:70), 'black','alpha');
%outlinebounds(l,p);
title('Frequency power all Condition 9mo');

twoHz=15:18;
ABdrum=[mean(mean(TFGrandDrumdataTwoMo.powspctrm(1,elect,twoHz),2),3)  mean(mean(TFGrandDrumdataSixMo.powspctrm(1,elect,twoHz),2),3) mean(mean(TFGrandDrumdataNineMo.powspctrm(1,elect,twoHz),2),3)];
figure(2)
subplot(2,1,1)
bar(ABdrum)
ABsyll=[mean(mean(TFGrandSylldataTwoMo.powspctrm(1,elect,twoHz),2),3)  mean(mean(TFGrandSylldataSixMo.powspctrm(1,elect,twoHz),2),3) mean(mean(TFGrandSylldataNineMo.powspctrm(1,elect,twoHz),2),3)];
subplot(2,1,2)
bar(ABsyll)

twoHz=15:18;
ABdrum=[mean(mean(TFGrandDrumdataTwoMo.powspctrm(1,elect,twoHz),2),3)-mean(mean(TFGrandRestdataTwoMo.powspctrm(1,elect,twoHz),2),3)  mean(mean(TFGrandDrumdataSixMo.powspctrm(1,elect,twoHz),2),3)-mean(mean(TFGrandRestdataTwoMo.powspctrm(1,elect,twoHz),2),3)];
figure(3)
subplot(2,1,1)
bar(ABdrum)
ABsyll=[mean(mean(TFGrandSylldataTwoMo.powspctrm(1,elect,twoHz),2),3)-mean(mean(TFGrandRestdataTwoMo.powspctrm(1,elect,twoHz),2),3)  mean(mean(TFGrandSylldataSixMo.powspctrm(1,elect,twoHz),2),3)-mean(mean(TFGrandRestdataTwoMo.powspctrm(1,elect,twoHz),2),3)];
subplot(2,1,2)
bar(ABsyll)






FrontClust=[6 9 11 12 13 14 19];
ParClust=[40 42 44 45 46];


i=1;
for b=1:length(BBdatabase)
    try 
        DiffSyl=TFGrandSylldataTwoMo.powspctrm(BBdatabase(b).EEGTwomo.Ta,:,:)-TFGrandRestdataTwoMo.powspctrm(BBdatabase(b).EEGTwomo.Rest,:,:);
        DiffDru=TFGrandDrumdataTwoMo.powspctrm((BBdatabase(b).EEGTwomo.Drum),:,:)-TFGrandRestdataTwoMo.powspctrm(BBdatabase(b).EEGTwomo.Rest,:,:);
        BB2monthAllcond(i)=BBdatabase(b);
        
        EEGdat(i).SylFrontClust=mean(mean(DiffSyl(:,FrontClust,TwoH),2),3);
        EEGdat(i).SylParClust=mean(mean(DiffSyl(:,ParClust,TwoH),2),3);
        
         
        EEGdat(i).DrumFrontClust=mean(mean(DiffDru(:,FrontClust,TwoH),2),3);
        EEGdat(i).DrumParClust=mean(mean(DiffDru(:,ParClust,TwoH),2),3);
        
        Behav(i).Sex=BBdatabase(b).Sex;
        Behav(i).dob=BBdatabase(b).DOB;
        Behav(i).asqTwo=BBdatabase(b).TwomoASQ.Communication;
        Behav(i).asqSix=BBdatabase(b).TotalSixmo;
        Behav(i).asqNine=BBdatabase(b).TotalNinemo;
        i=i+1;
    catch
        continue
    end
end


data1=[];
data2=[];
data3=[];
%select2mo=[1:6 8:12 14:17]
select2mo=[1:17]
for i=1:length(select2mo)
    data1=[data1; EEGdat(select2mo(i)).SylFrontClust];
    data3=[data3; EEGdat(select2mo(i)).DrumFrontClust];
    data2=[data2;Behav(select2mo(i)).Sex];
end
[rpc fig sstruct]=BlandAltman(data1,data2, {'Pow Syl-Rest for FrontClust', 'ASQ score'})
[rpc fig sstruct]=BlandAltman(data3,data2,  {'Pow Drum-Rest for FrontClust', 'ASQ score'})

data1=[];
data2=[];
data3=[];
%select2mo=[1:6 9:13 15:18]
select2mo=[1:17]
for i=1:length(select2mo)
    data1=[data1; EEGdat(select2mo(i)).SylParClust];
    data3=[data3; EEGdat(select2mo(i)).DrumParClust];
    data2=[data2;Behav(select2mo(i)).Sex];
end
[rpc fig sstruct]=BlandAltman(data1,data2,  {'Pow Syl-Rest for ParClust', 'ASQ score'})
[rpc fig sstruct]=BlandAltman(data3,data2,  {'Pow Drum-Rest for ParClust', 'ASQ score'})



i=1;
for b=1:length(BBdatabase)
    try
        DiffSyl2=squeeze(TFGrandSylldataTwoMo.powspctrm(BBdatabase(b).EEGTwomo.Ta,:,:));%-TFGrandRestdataTwoMo.powspctrm(BBdatabase(b).EEGTwomo.Rest,:,:);
        %    DiffDru2=TFGrandDrumdataTwoMo.powspctrm(BBdatabase(b).EEGTwomo.Drum,:,:);%-TFGrandRestdataTwoMo.powspctrm(BBdatabase(b).EEGTwomo.Rest,:,:);
        
        DiffSyl6=squeeze(TFGrandSylldataSixMo.powspctrm(BBdatabase(b).EEGSixmo.Ta,:,:));%-TFGrandRestdataSixMo.powspctrm(BBdatabase(b).EEGSixmo.Rest,:,:);
        
        DiffSyl9=squeeze(TFGrandSylldataNineMo.powspctrm(BBdatabase(b).EEGNinemo.Ta,:,:));%-TFGrandRestdataNineMo.powspctrm(BBdatabase(b).EEGNinemo.Rest,:,:);
        %   DiffDru6=TFGrandDrumdataSixMo.powspctrm(BBdatabase(b).EEGSixmo.Drum,:,:);%-TFGrandRestdataTwoMo.powspctrm(BBdatabase(b).EEGSixmo.Rest,:,:);
        
        BB2and6monthAllcond(i)=BBdatabase(b);
        
        EEGdat(i).Syl=squeeze(mean(DiffSyl2(:,:),1));
        
        
     %  EEGdat(i).DrumFrontClust=mean(mean(DiffSyl2(:,FrontClust,TwoH),2),3);
     %   EEGdat(i).DrumParClust=mean(mean(DiffSyl2(:,ParClust,TwoH),2),3);
        
        EEGdat(i).SixSy=mean(DiffSyl6(:,:),1);
        
         EEGdat(i).NineSy=mean(DiffSyl9(:,:),1);
        
        
      %  EEGdat(i).SixDrumFrontClust=mean(mean(DiffSyl6(:,FrontClust,TwoH),2),3);
      %  EEGdat(i).SixDrumParClust=mean(mean(DiffSyl6(:,ParClust,TwoH),2),3);
        
       % EEGdat(i).NinSylFrontClust=mean(mean(DiffSyl9(:,FrontClust,TwoH),2),3);
       % EEGdat(i).NinSylParClust=mean(mean(DiffSyl9(:,ParClust,TwoH),2),3);
        
       % EEGdat(i).SixDrumFrontClust=mean(mean(DiffSyl6(:,FrontClust,TwoH),2),3);
        %EEGdat(i).SixDrumParClust=mean(mean(DiffSyl6(:,ParClust,TwoH),2),3);
        
        %         Behav(i).Sex=BBdatabase(b).Sex;
        %         Behav(i).dob=BBdatabase(b).DOB;
        %         Behav(i).asqTwo=BBdatabase(b).TotalTwomo;
        %         Behav(i).asqSix=BBdatabase(b).TotalSixmo;
        i=i+1;
    catch
        continue
    end
end

sbjectdat=[];
for i=1:size(EEGdat,2)
    sbjectdat=[sbjectdat; EEGdat(i).Syl EEGdat(i).SixSy EEGdat(i).NineSy  ]
end

 %bar(sbjectdat,'DisplayName','sbjectdat')
 plot(sbjectdat)

    


i=1
for b=1:length(BBdatabase)
    try 
        BBdatabase(b).EEGTwomo.Drum;
        BBdatabase(b).EEGTwomo.Ta;
        BBdatabase(b).EEGTwomo.Rest;
        BBAllcond
        BBdatabase(b).EEGSixmo.Drum;
        BBdatabase(b).EEGSixmo.Ta;
        BBdatabase(b).EEGSixmo.Rest;
        
        BBdatabase(b).EEGNinemo.Drum;
        BBdatabase(b).EEGNinemo.Ta;
        BBdatabase(b).EEGNinemo.Rest;
        BBAllcond(i)=BBdatabase(b);
        i=i+1;
    catch
        continue
    end
end

i=1
for b=1:length(BBdatabase)
    try        
        BBdatabase(b).EEGTwomo.Drum;
        BBdatabase(b).EEGTwomo.Ta;
        BBdatabase(b).EEGTwomo.Rest;
        BBAllcond
        BBdatabase(b).EEGSixmo.Drum;
        BBdatabase(b).EEGSixmo.Ta;
        BBdatabase(b).EEGSixmo.Rest;
        
        BBdatabase(b).EEGNinemo.Drum;
        BBdatabase(b).EEGNinemo.Ta;
        BBdatabase(b).EEGNinemo.Rest;
        BBAllcond(i)=BBdatabase(b);

