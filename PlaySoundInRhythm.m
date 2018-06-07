function checktime=PlaySoundInRhythm(sound, Freq, Marge, nberofBit, TestBloc, pahandle)
KeyBoard_basics
checktime=[];

try
    Freq=(1/Freq)/10;
    Count=0;
    bpsecMax=Freq+Marge; %marge authorized between two sounds here will sounds between 0.47 sec to 0.53 
    bpsecMin=Freq-Marge;

    [ss, Fc]=audioread(sound);
    ss=ss'; % Psytoolbox needs line !
    % Fill the audio playback buffer with the audio data 
    PsychPortAudio('FillBuffer', pahandle, ss);
    t1 = PsychPortAudio('Start', pahandle, 1, 0, 1)
    NetStation('Event','TRSP',t1, 0.001,'TEST',TestBloc, 'obs#', Count, 'cel#', 0);
    tic
    Count=Count+1;
    checktime=[checktime; 0];
    
    PsychPortAudio('Stop', pahandle);
    while Count<=nberofBit % play sound until reaching the require number of bit
        if  toc<=bpsecMax & toc>=bpsecMin % if the latency between two sounds is 2Hz play it
            to=toc*10;
            t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
            NetStation('Event','TRSP',GetSecs,0.001,'TEST', TestBloc, 'obs#', Count, 'cel#', to);
            tic
            checktime=[checktime; to];
            Count=Count+1;            
            PsychPortAudio('Stop', pahandle);
            if MakeAPause(leftsh) % Check if need to do pause with spa keycode of spacebar
                t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
                NetStation('Event','TRSP',GetSecs,0.001,'TEST', TestBloc, 'obs#', Count, 'cel#', 0.001);
                tic
                checktime=[checktime; 0];                
                PsychPortAudio('Stop', pahandle);
            end
        elseif toc>bpsecMax % what to do if the computer lag and lost the freq
            disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
            disp('Computer lag reset the clock, check that this happen not too much during experiment')
            disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
            
            t1 = PsychPortAudio('Start', pahandle, 1, 0, 0);
            tic
            NetStation('Event','TRSP',GetSecs, 0.001,'TEST',TestBloc, 'obs#', Count, 'cel#', 0);            
            checktime=[checktime; 0];
        end
       
    end
    ListenChar
    WaitSecs(1);
    NetStation('StopRecording');
catch
    Screen('CloseAll');
    ShowCursor;
    ListenChar
    NetStation('StopRecording');
    rethrow(lasterror);
end