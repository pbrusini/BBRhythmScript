function ListSong=PlayNurseryRimes(nbrOfRepet, pahandle)
KeyBoard_basics
listofSong= {'Mary_1_sound_cutDin_SAF_March' 'Oldwoman_BB_good_sound_cutDin_SAF_March'...
'LonBridge_1_NB_sound_cutDin_SAF_March' 'Lamb_4_sound_cutDin_SAF_March' ...
'JackJill_NB_good_sound_cutDin_SAF_March' 'Jack_BB_good_sound_plusDin_SAF_March'...
'Iqredoc_BB_good_sound_plusDin_SAF_March' 'Frere_2_sound_plusDin_SAF_March'...
'Banbury_1_sound_cutDin_SAF_March' 'Winter_NB_good_sound_cutDin_SAF_March'...
'Twinkle_1_sound_cutDin_SAF_March' 'Spider_NB_1_good_sound_cutDin_SAF_March' ...
'SixPence_NB_1_good_sound_cutDin_SAF_March' 'SimpleSimon_NB_good_1_sound_cutDin_SAF_March'...
'RingARoses_2_NB_sound_cutDin_SAF_March' 'Queen_1_sound_cutDin_SAF_March' ...
'One_NB_hesitation_sound_cutDin_SAF_March' 'MissMarple_BB_good_sound_cutDin_SAF_March'}
shuf=randperm(length(listofSong));
pathsong='C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\'

NetStation('Synchronize');
NetStation('StartRecording');
WaitSecs(3);
ListenChar(2);
try
    Count=0;
    listSong=[];
    tic
    NetStation('Event','TRSP',GetSecs,0.001,'TEST',3, 'obs#', Count, 'cel#', 0, 'song', 0);
    % Fill the audio playback buffer with the audio data 'wavedata':
    ss=[];
    Fc=1;
    while Count<nbrOfRepet
        song=1;
        while song<=length(listofSong)
            if toc>length(ss)/Fc
                nameSong=listofSong{shuf(song)};
                [ss, Fc]=audioread([pathsong nameSong '.wav']);
                ss=ss'; % Psytoolbox needs line !
                PsychPortAudio('FillBuffer', pahandle, ss);
                t1 = PsychPortAudio('Start', pahandle, 1, 0, 0);
                listSong=[listSong; {t1 listofSong{song}}];
                tic
                status = PsychPortAudio('GetStatus', pahandle);
                NetStation('Event','TRSP',GetSecs, 0.001,'TEST',3, 'obs#', Count+song, 'cel#', GetSecs, 'song', song);
                song=song+1;
                if MakeAPause(leftsh) % Check if need to do pause with spa keycode of spacebar
                    
                    NetStation('Event','TRSP',GetSecs,0.001,'TEST', TestBloc, 'obs#', 0, 'cel#', 0);
                    tic                   
                    PsychPortAudio('Stop', pahandle);
                end
            end
            
        end
        WaitSecs(length(ss)/Fc)
        Count=Count+1;
    end
    ListenChar(0)
    NetStation('StopRecording');
    NetStation('Disconnect')
catch
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0)
    NetStation('StopRecording');
    NetStation('Disconnect')
    rethrow(lasterror);
end