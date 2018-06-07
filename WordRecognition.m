%% Script use to run the WordReco experiment
%  Present sequences of pair of images and a label pronounce by caregiver
%  record eye with Tobii
% Perrine 21/04/17


%% Set the global var for the experiment
clear all
fprintf('\n___________________________________________ ',1);
fprintf('\n Run Experiment BabyRhythm WordRecognition \n',1);
fprintf('\n___________________________________________ \n',1);


addpath('functions');
addpath('tetio');
addpath('Stimuli');
PsychJavaTrouble

Nom=[];
Nom.code=input('BB code : ','s'); %set the var to save for each participant

% Load the sounds to play and create a pseudo-random order of the bloc
ordi=Screen('Computer');
if ordi.linux
    pathStim='/media/Work/Data_RhythmProject/EEG&ET_script/B&S2012_Stimuli/WordRecoTask/'
    addpath('/media/sdb/Data_RhythmProject/EEG&ET_script/')
    stimpath='/media/Work/Data_RhythmProject/EEG&ET_script/B&S2012_Stimuli/NewLabel/Label_Intensity50_Cut/'
else
    pathStim='C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\WordRecoTask\'
    addpath('C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\')
    stimpath='C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\WordRecoTask\Label_Intensity50_Cut\';
end

startExp=0;
group=input('enter 1 for group1 images or 2 for group2 images : ');


while ~startExp
    try
        switch group
            case 1
                ImageSet=Image(1);
                LabelSet=Label(1);
                CarierSet=Carier(1);
                TrialSet=TrialType(1);
                Block=[ImageSet; CarierSet ;LabelSet; TrialSet];
                startExp=1;
                fprintf('\n you selected 1 the BB is attributed to group1 \n',1);
            case 2
                ImageSet=Image(2);
                LabelSet=Label(2);
                CarierSet=Carier(2);
                TrialSet=TrialType(2);
                Block=[ImageSet; CarierSet ;LabelSet; TrialSet];
                startExp=1;
                fprintf('\n you selected 2 the the BB is attributed to group2 \n',1);
            otherwise
                group=input('\n you enter a non-expected character! enter 1 for group1 images or 2 for group2 images :  \n');
        end
    catch
        group=input('\n you enter a non-expected character! enter 1 for group1 images or 2 for group2 images :  \n');
    end
end
Nom.Groupe=Block;
repetitions = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Keyboard Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KeyBoard_basics
leftsh=KbName('LEFTSHIFT');
spa=KbName('SPACE');

%%
%%%%%%%%%%%%% NetStation synchronisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Init_netStation

%%
%%%%%%%%%%%%% Initia/Calib Tobii %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PtsCalib=Init_Tobii();

Nom.Calib=PtsCalib;
save([Nom.code num2str(GetSecs)],'Nom')

LeftEyeAll = [];
RightEyeAll = [];
TimeStampAll = [];
TrigSignalAll = [];

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Experimental Blocks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set the default value to play a movie

fprintf(['Start WorRecognition Test'],1);

ListenChar;
pause
NetStation('Event','WoRe',GetSecs,0.001,'TEST',7, 'cel#', 0, 'obs#', 000);
WaitSecs(3);

% folder of the calib stim
InitializePsychSound;
Fixdirectory = 'C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\Fixation\';
SoundList = dir(strcat(Fixdirectory,'*.wav'));

%Attention grabber
Graber={'windows_screen_saver_10sec_3_no_sound.wmv' 'windows_screen_saver_10sec_2_no_sound.wmv'...
    'windows_screen_saver_10sec_1_no_sound.wmv' 'windows_bouncing_screen_saver_8sec_boing.wmv'...
    'windows_bouncing_screen_saver_4sec_boing.wmv'};
cmdDos='vlc --fullscreen --video-on-top  --no-audio --no-video-title-show --play-and-exit ';
for st=1:length(Graber)
    Graber{st}=['C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\' Graber{st}];
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Screen Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[screenid, windowBG,resolwindowBG]=ScreenInit()
% essential colors
white = WhiteIndex(screenid);
black = BlackIndex(screenid);

%%start ET tracker
tetio_startTracking()

[lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;

LeftEye = lefteye;
RightEye = righteye;
tempstimestamp = timestamp;
TrigSignal = trigSignal;

if isempty(lefteye)
    
else
    LeftEye(:,14) = 57;
    RightEye(:,14) = 57;
    
    LeftEyeAll = [LeftEyeAll;LeftEye];
    RightEyeAll = [RightEyeAll;RightEye];
    TimeStampAll = [TimeStampAll;tempstimestamp];
    TrigSignalAll = [TrigSignalAll; TrigSignal];
    
end

Strat=GetSecs;

for bloc=1:length(Block)
    bloc
    mOrder=randperm(length(SoundList));
    if bloc==1
        DrawFormattedText(windowBG,'                                         The Test will start in 2 secs you will see label on the screen \n                                         that you should please repeat to your infant when the objects appear','left','center',white);
        Screen('Flip',windowBG);
        WaitSecs(2);
    end
    [keyIsDown, secs, keyCode]=KbCheck;
    
    %******************************************************************
    %******************************************************************
    %% Videos to maintain attntion of bb
    %******************************************************************
    if keyIsDown==1 & keyCode(leftsh)==1
        Screen('CloseAll');
        NetStation('Event','PAUS',GetSecs,0.001,'TEST', 0, 'obs#', 0, 'cel#', 0);
        
        tmp=randperm(length(Graber));
        vid=tmp(1);
        system([cmdDos Graber{vid}]);
        
        [screenid, windowBG,resolwindowBG]=ScreenInit()
    end
    
    %******************************************************************
    %******************************************************************
    %% Trial 3s of image presentation + parent label + fixation time
    %******************************************************************
    
    %Set the image / target to display
    triaLabel=Block{4,bloc};
    triaCarier=Block{3,bloc};
    triaImageLeft=Block{1,bloc};
    triaImageRight=Block{2,bloc};
    triaProp=Block{5,bloc};
    
    if strcmp(triaProp, 'td')
        tri=1; % target left
    else
        tri=2; %target right
    end
    
    loomString={'' 'a' 'b' 'a' ''};
    
    
    %% present images looming 1 sec each
    freq=44100;
    nrchannels = 2;
    pahandleA = PsychPortAudio('Open', [], [], repetitions, freq, nrchannels);
    staticImage=imread(strcat(pathStim,Block{1,bloc},Block{2,bloc}, '.jpg'));
    destinationRect =[ 0    0   1920   1080];
    object=Screen('MakeTexture',windowBG, staticImage);
    
    Screen('DrawTexture',windowBG,object,[],destinationRect); %draw the object (full picture)
    object_on=Screen('Flip',windowBG); %present the object
    
    NetStation('Event','TRBG', object_on,0.001, 'cel#', 1, 'obs# ',bloc, 'tria', tri);
    
    [y, freq, nbits] = wavread(strcat(Fixdirectory, SoundList(mOrder(1)).name));
    leftfunnysound=zeros(length(y),1);
    y=[y leftfunnysound];
    wavedata = y';
    PsychPortAudio('FillBuffer', pahandleA, wavedata);
    
    tic
    tStartpres=toc;
    while toc < tStartpres +1.5
        
        PsychPortAudio('Start', pahandleA,1, 0, 1);
        for l=1:length(loomString)
            loomLeft=imread(strcat(pathStim, Block{1,bloc},loomString{l},Block{2,bloc},'.jpg'));
            
            %CONVERT it to a texture
            object=Screen('MakeTexture',windowBG,loomLeft);
            
            %PRESENT object
            Screen('DrawTexture',windowBG,object,[],destinationRect); %draw the object (full picture)
            object_on=Screen('Flip',windowBG); %present the object
            
            [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
            
            
            if isempty(lefteye)
            else
                lefteye(:,14) = 570;%strcat(triaImageLeft, triaImageRight,'\t', triaLabel,'\t', triaCarier,'\t', triaProp);
                righteye(:,14) = 570%strcat(triaImageLeft, triaImageRight,'\t', triaLabel,'\t', triaCarier,'\t', triaProp);
                
                LeftEye = lefteye;
                RightEye = righteye;
                tempstimestamp = timestamp;
                TrigSignal = trigSignal;
            end
            WaitSecs(0.1);
            LeftEyeAll = [LeftEyeAll;LeftEye];
            RightEyeAll = [RightEyeAll;RightEye];
            TimeStampAll = [TimeStampAll;tempstimestamp];
            TrigSignalAll = [TrigSignalAll; TrigSignal];
            
        end
    end
    
    
    PsychPortAudio('Stop', pahandleA);
    
    [y, freq, nbits] = wavread(strcat(Fixdirectory, SoundList(mOrder(2)).name));
    leftfunnysound=zeros(length(y),1);
    y=[y leftfunnysound];
    wavedata = y';
    PsychPortAudio('FillBuffer', pahandleA, wavedata);
    tic
    tStartpres=toc;
    
    object=Screen('MakeTexture',windowBG, staticImage);
    Screen('DrawTexture',windowBG,object,[],destinationRect); %draw the object (full picture)
    object_on=Screen('Flip',windowBG); %present the object
    WaitSecs(0.4);
    
    while toc < tStartpres +1.5
        PsychPortAudio('Start', pahandleA,1, 0, 1);
        for l=1:length(loomString)
            loomRight=imread(strcat(pathStim,Block{1,bloc},Block{2,bloc},loomString{l},'.jpg'));
            %CONVERT it to a texture
            object=Screen('MakeTexture',windowBG,loomRight);
            
            %PRESENT object
            Screen('DrawTexture',windowBG,object,[],destinationRect); %draw the object (full picture)
            object_on=Screen('Flip',windowBG); %present the object
            [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
            
            if isempty(lefteye)
            else
                lefteye(:,14) = 570 %strcat(triaImageLeft, triaImageRight,'\t', triaLabel,'\t', triaCarier,'\t', triaProp);
                righteye(:,14) = 570;
                LeftEye = lefteye;
                RightEye = righteye;
                tempstimestamp = timestamp;
                TrigSignal = trigSignal;
            end
            WaitSecs(0.1);
            LeftEyeAll = [LeftEyeAll;LeftEye];
            RightEyeAll = [RightEyeAll;RightEye];
            TimeStampAll = [TimeStampAll;tempstimestamp];
            TrigSignalAll = [TrigSignalAll; TrigSignal];
            
        end
    end
    
    disp('press enter')
    
    PsychPortAudio('Stop', pahandleA);
    
%     %Present to the cargiver the label
%     load din
%     din=din(1:50);
%     [lab, freq, nbits] = wavread(strcat(stimpath, triaLabel,'.wav'));
%     lab=lab*20;
%     [carri, freq, nbits] = wavread(strcat(stimpath, triaCarier,'.wav'));
%     carri=carri*20;
%     lab(1:length(din),2)=din;
%     silence=zeros(5,2);
%     wavedata = [carri;silence ;lab]';
%     PsychPortAudio('FillBuffer', pahandleA, wavedata);
%     
%     tPresLabel=PsychPortAudio('Start', pahandleA,1, 0, 1);
    NetStation('Event','LABL', GetSecs,0.001, 'cel#', 1, 'obs# ',bloc, 'tria', tri)
        
    %Present the image
    
    staticImage=imread(strcat(pathStim,Block{1,bloc},Block{2,bloc}, '.jpg'));
    
    object=Screen('MakeTexture',windowBG,loomLeft);
    Screen('DrawTexture',windowBG,object,[],destinationRect); %draw the object (full picture)
    tStartTrial=Screen('Flip',windowBG); %present the object
    
    NetStation('Event','TRSP', tStartTrial,0.001, 'cel#', 1, 'obs# ',bloc, 'tria', tri);
    
    tic
    tStartpres=toc;
    while toc < tStartpres +6
        mark=0;
        marktime=0;
        [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
        [keyIsDown, secs, keyCode]=KbCheck;
        if keyIsDown==1 & keyCode(spa)==1
            mark=1;
            marktime=secs;
        end
        if isempty(lefteye)
        else
           lefteye(:,14) = tri;
            righteye(:,14) = tri;
            
            LeftEye = lefteye;
            RightEye = righteye;
            tempstimestamp = timestamp;
            if mark
                TrigSignal = [2;2; trigSignal(2:length(trigSignal))];
            else
                TrigSignal = trigSignal;
            end
        end
        LeftEyeAll = [LeftEyeAll;LeftEye];
        RightEyeAll = [RightEyeAll;RightEye];
        TimeStampAll = [TimeStampAll;tempstimestamp];
        TrigSignalAll = [TrigSignalAll; TrigSignal];
        clear LeftEye
        clear RightEye
        clear tempstimestamp
        clear TrigSignal
        PsychPortAudio('Close');
    end
    
    
end
Stop=GetSecs;
Stop-Strat;
ETdata=[double(TimeStampAll) LeftEyeAll RightEyeAll double(TrigSignalAll)];

save(Nom.code, 'ETdata');
Nom.ET=ETdata;

WaitSecs(1);
NetStation('StopRecording');
NetStation('Disconnect')

tetio_cleanUp;
Screen('CloseAll');
ShowCursor;
ListenChar(0)
save([Nom.code num2str(GetSecs)],'Nom')

fprintf(['Experiement is over! \n'],1);