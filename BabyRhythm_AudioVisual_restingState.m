%% Script use to run the Audio/visual Nursery experiment
%   play a define sequence of three movies (syllable ta, drum bit and nursery
%   rhymes)
%   setup as to send an audio mark to egi system (din)
%   suppose Psychotoolbox install
%  folder stim C:\Users\CNEBabyLab\Documents\Experiment\Stimuli\
% Perrine 28/01/17


%% Set the global var for the experiment
clc;
clear all;
close all;

addpath('functions');
addpath('tetio');
addpath('Stimuli');
PsychJavaTrouble

fprintf('\n___________________________________________ ',1);
fprintf('\n Run Experiment BabyRhythm AudioVisual \n',1);
fprintf('\n___________________________________________ \n',1);

Nom=[];
Nom.code=input('BB code : ','s'); %set the var to save for each participant
Nom.Syllable=[];
Nom.Drum=[];
Nom.restState = [];

% Load the sounds to play and create a pseudo-random order of the bloc
ordi=Screen('Computer');
KbName('UnifyKeyNames');
leftsh=KbName('LEFTSHIFT');
if ordi.linux
    pathStim='/media/sdb/Data_RhythmProject/EEG&ET_script/Stimuli/'
    addpath('/media/sdb/Data_RhythmProject/EEG&ET_script/')
else
    pathStim='C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\'
    addpath('C:\Users\CNEBabyLab\Documents\Experiment\EEG_script')
end

%initialize ET var
LeftEyeAll = [];
RightEyeAll = [];
TimeStampAll = [];
TrigSignalAll = [];

%Stim to play
StimMovieTA='TaAudioVisual_FinalDinb.mp4';
StimMovieDrum='DrumAudioVisual_FinalDinb.webm';
stimNursery={'Mary_mary_quite_contrary_AA_DIN.mp4' 'NurseryRimes_FinalDinb.mp4'...
'Ride_a_cock_horse_AA_DIN.mp4' 'Ring_a_ring_a_roses_AA_DIN.mp4'...
'Simple_simon_AA_DIN.mp4' 'Sing_a_song_of_sixpence_AA_DIN.mp4'...
'The_queen_of_hearts_AA_DIN.mp4' 'There_was_an_old_woman_DIN.mp4'...
'Twinkle_twinkle_AA_DIN.mp4' 'When_I_was_six_AA_DIN.mp4'...
'Bed_in_summer_AA_DIN.mp4' 'Frere_jacques _AA_DIN.mp4'...
'Hickory_dickory_dock_AA_DIN.mp4' 'Incy_wincy_spider_AA_DIN.mp4'...
'Jack_and_jill_AA_DIN.mp4' 'Little_jack_horner_DIN.mp4'...
'London_bridge_is_falling_down_AA_DIN.mp4' 'Mary_had_a_little_lamb_AA_DIN.mp4'};
shuf=randperm(length(stimNursery));


%Attention grabber
Graber={'windows_screen_saver_10sec_3_no_sound.wmv' 'windows_screen_saver_10sec_2_no_sound.wmv'...
    'windows_screen_saver_10sec_1_no_sound.wmv' 'windows_bouncing_screen_saver_8sec_boing.wmv'...
    'windows_bouncing_screen_saver_4sec_boing.wmv'};
for st=1:length(Graber)
    Graber{st}=[pathStim Graber{st}];
end


% Set the number of repetition, Frequency of the stim, accepted Marge and
% duration resting state

time=3; %duration of resting state in min
Freq=2;  %freq of playing sound
Marge=0.1; %authorise delay in sound playback in sec

fprintf(['\n exp set up for ' num2str(time) 'min of resting state, ' ...
    ' repetitions of the movies \n']) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Keyboard Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KeyBoard_basics

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Screen Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[screenid, windowBG,resolWindow]=ScreenInit()

%%
%%%%%%%%%%%%% NetStation synchronisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Init_netStation

%%
%%%%%%%%%%%%% Initia/Calib Tobii %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PtsCalib=Init_Tobii();
Nom.Calib=PtsCalib;
save([Nom.code num2str(GetSecs)],'Nom')

%__________________________________________________________________________
% EXPERIMENT BLOC

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Experimental Blocks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ListenChar;
pause

NumStim=input('Choose the Video To play, 1 for TA, 2 for Drum and 3 for NR:    ');
Exp=1;
while Exp
    switch NumStim
        case 1
            stim = [pathStim StimMovieTA];
            Test = 1;
            disp('The Syllable have been Selected')
            Exp=0;
        case 2
            stim =  [pathStim StimMovieDrum];
            Test = 2;
            disp('The Drum have been Selected')
            Exp=0;
        case 3
            for st=1:length(stimNursery)
                stim{st}=[pathStim stimNursery{shuf(st)}];
            end
            Test = 3;
            disp('The Nursery Rimes have been Selected')
            Exp=0;
        otherwise
            disp('wrong charactere enter your choice again')
            NumStim=input('Choose the Video To play, 1 for TA, 2 for Drum and 3 for NR:    ',1);
    end
end

NetStation('Synchronize');
NetStation('StartRecording');
WaitSecs(3);

tstart=GetSecs;
tic
[LeftEyeVideo, RightEyeVideo, tempstimestampVideo, TrigSignalVideo] = PlayVideoEEG(stim, Test, Graber, shuf);
vid=toc
WaitSecs(1);
NetStation('StopRecording');
NetStation('Disconnect')

LeftEyeAll = [LeftEyeAll;LeftEyeVideo];
RightEyeAll = [RightEyeAll;RightEyeVideo];
TimeStampAll = [TimeStampAll;tempstimestampVideo];
TrigSignalAll = [TrigSignalAll; TrigSignalVideo];

ETdata=[double(TimeStampAll) LeftEyeAll RightEyeAll double(TrigSignalAll)];

save(Nom.code, 'ETdata');
Nom.ET=ETdata;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Bloc of Resting States %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Start Resting State press a key to start',1);
ListenChar;
pause
WaitSecs(1)
tic
[LeftEyeRest, RightEyeRest, tempstimestampRest, TrigSignalRest, Nom.restState] = RestingState_AV(Freq, time, Marge, 0);
rest=toc
LeftEyeAll = [LeftEyeAll;LeftEyeRest];
RightEyeAll = [RightEyeAll;RightEyeRest];
TimeStampAll = [TimeStampAll;tempstimestampRest];
TrigSignalAll = [TrigSignalAll; TrigSignalRest];
clear LeftEyeRest
clear RightEyeRest
clear tempstimestampRest
clear TrigSignalRest

ETdata=[double(TimeStampAll) LeftEyeAll RightEyeAll double(TrigSignalAll)];

Nom.ET=ETdata;
save([Nom.code num2str(GetSecs)],'Nom')


WaitSecs(1)
NetStation('StopRecording');
Screen('CloseAll');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Bloc of Gaze Pursuit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Start Pursuit press a key to start',1);

PtsCalib=Init_Tobii();
FreqFace=input('Choose the speed of the pursuit 1 for 1 Hz and 2 for 2 Hz:    ');
Exp=1;
while Exp
    try
        switch FreqFace
            case 1
                face = [pathStim '1Hz_Face_random_movement_EEG_audio_DIN.wmv'];
                Test=4;
                Exp=0;
            case 2
                face = [pathStim '2Hz_Face_circular_movement.wmv'];
                Test=4;
                Exp=0;
        end
    catch
        disp('wrong charactere enter your choice again')
        FreqFace=input('Choose the speed of the pursuit 1 for 1 Hz and 2 for 2 Hz:    ');
    end
end

NetStation('Synchronize');
NetStation('StartRecording');
WaitSecs(3);
tstart=GetSecs;
tic
[LeftEyeFace, RightEyeFace, tempstimestampFace, TrigSignalFace] = PlayVideoEEG(face, Test, Graber, shuf);
fa=toc
NetStation('StopRecording');
LeftEyeAll = [LeftEyeAll;LeftEyeFace];
RightEyeAll = [RightEyeAll;RightEyeFace];
TimeStampAll = [TimeStampAll;tempstimestampFace];
TrigSignalAll = [TrigSignalAll; TrigSignalFace];


ETdata=[double(TimeStampAll) LeftEyeAll RightEyeAll double(TrigSignalAll)];

Nom.ET=ETdata;
save([Nom.code num2str(GetSecs)],'Nom')




tetio_cleanUp;
Screen('CloseAll');
ShowCursor;
ListenChar(0)
save([Nom.code num2str(GetSecs)],'Nom')

fprintf(['Experiement is over! \n'],1);




