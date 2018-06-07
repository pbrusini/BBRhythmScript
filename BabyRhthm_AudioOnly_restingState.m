%% Script use to run the 2month visual only BabyRhythm experiment
%   play a sequence of three stimuli (syllable ta, drum bit and opt nursery
%   rhymes)
%   setup as to send an audio mark to egi system (din)
%   suppose Psychotoolbox install
%  folder stim C:\Users\CNEBabyLab\Documents\Experiment\Stimuli\
% Perrine 28/01/17


%% Set the global var for the experiment
clear all
fprintf('\n___________________________________________ ',1);
fprintf('\n Run Experiment BabyRhythmAudio only \n',1);
fprintf('\n___________________________________________ \n',1);

Nom=[];
Nom.code=input('BB code : ','s'); %set the var to save for each participant
Nom.Syllable=[];
Nom.Drum=[];
 PsychJavaTrouble

% Load the sounds to play and create a pseudo-random order of the bloc
ordi=Screen('Computer');
if ordi.linux
    pathStim='/media/sdb/Data_RhythmProject/EEG&ET_script/Stimuli/'
    addpath('/media/sdb/Data_RhythmProject/EEG&ET_script/') 
else
    pathStim='C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\'
    addpath('C:\Users\CNEBabyLab\Documents\Experiment\EEG_script')
    addpath('C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\functions')
end

startExp=0;
group=input('enter 1 for playing Ta first or 2 to play Drum first: ');
StimSound={['Unique_TaDin.wav'] ['Unique_DrumDin.wav']};

while ~startExp
    try
        switch group
            case 1
                Block=[StimSound(1) StimSound(2)];
                startExp=1;
                fprintf('\n you selected 1 the experiment order will be Syllable followed by Drum \n',1);
            case 2
                Block=[StimSound(2) StimSound(1)];
                startExp=1;
                fprintf('\n you selected 2 the experiment order will be Drum followed by Syllable \n',1);
            otherwise
                group=input('\n you enter a non-expected character! enter 1 for playing 2Hz first or 2 to play 40Hz first:  \n');
        end
    catch
        group=input('\n you enter a non-expected character! enter 1 for playing Syllable first or 2 to play Drum first:  \n');
    end
end


% Set the number of repetition, Frequency of the stim, accepted Marge and
% duration resting state

nberofBit=2000; % number of repetition of the sound
Freq=2;  %freq of playing sound
Marge=0.0001; %authorise delay in sound playback in sec
time=3; %duration of resting state in min

fprintf(['\n exp set up for ' num2str(time) 'min of resting state, ' ...
    num2str(nberofBit) ' repetitions of bits at '  num2str(Freq) ...
    'Hz. Accepted lag betweeen bits is ' num2str(Marge) 'sec \n']) 

PsychJavaTrouble

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Keyboard Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KeyBoard_basics

%%
%%%%%%%%%%%%% NetStation synchronisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Init_netStation

%%
%%%%%%%%%%%%% Black ScreenDuring Presentation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%InitScreen_BlackScreen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Bloc of Resting States %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Start Resting State press a key to start',1);
ListenChar;
pause
WaitSecs(1)
RestingState(Freq, time, Marge, 0)
WaitSecs(1)
NetStation('StopRecording');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%% SoundInit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 pahandle=Init_SoundCard
% 
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%% Experimental Blocks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for bloc=1:length(Block)
%     if strcmp(Block{bloc}, StimSound(1))
%         fprintf(['Start Block of Sylables press a key to start'],1);
%         Test=1;
%     else
%         fprintf(['Start Block of Drum press a key to start'],1);
%         Test=2;
%     end
%     
%     ListenChar;
%     pause
%     NetStation('Synchronize');
%     NetStation('StartRecording');
%     WaitSecs(3);
%     stim=[pathStim Block{bloc}];
%     switch Test
%         case 1
%             Nom.Syllable=PlaySoundInRhythm(stim, Freq,Marge,nberofBit ,Test,pahandle);
%         case 2
%             Nom.Drum=PlaySoundInRhythm(stim, Freq,Marge, nberofBit ,Test,pahandle);
%     end
% end
% 
% ShowCursor;
% ListenChar
% WaitSecs(1);
% NetStation('StopRecording');
% 
% pause
% fprintf(['Experiement is over!'],1);
% 
% save([Nom.code num2str(GetSecs)],'Nom')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Bloc of Nursery Rimes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PlayNursery=input('\n If you want to pursue the Experiment with Nursery Rimes press 1 if not press 2 \n');
startNursery=0;
while ~startNursery
    try
        switch PlayNursery
            case 1
                fprintf('Start Nursery a key to start',1);
                NetStation('StartRecording');
                pause
                nbrOfRepet=3;
                Nom.ListSong=PlayNurseryRimes(3, pahandle);
                Screen('CloseAll');
                ShowCursor;
                ListenChar
                WaitSecs(1);
                NetStation('StopRecording');
                NetStation('Disconnect')
                fprintf(['Experiement is over, No more sound to play!'],1);
            case 2
                Screen('CloseAll');
                fprintf('The block of nursery Rimes will not be played the experiemnt is over',1);
                NetStation('Disconnect')
                
            otherwise
                startNursery=input('\n you enter a non-expected character! enter 1 for nursery or 2 to end \n');
        end
    catch
        startNursery=input('\n you enter a non-expected character! enter 1 for nursery or 2 to end \n');
    end
end
        
save([Nom.code],'Nom')