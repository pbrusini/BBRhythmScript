function Bool=MakeAPause(key)
rghtsh=KbName('RIGHTSHIFT');
[keyIsDown, secs, keyCode]=KbCheck;
Bool=(keyIsDown==1 & keyCode(key)==1);
if Bool
    WaitSecs(1);
    NetStation('StopRecording');
    fprintf('\n___________________________________________ \n',1);
    fprintf('\n Experiment BabyRhythmAudio in pause press Enter to resume\n',1);
    fprintf('\n___________________________________________ \n',1);
    ListenChar
    Wait=1;
    while Wait
        [keyIsDown, secs, keyCode]=KbCheck;
        if (keyIsDown==1 & keyCode(rghtsh)==1)
            Wait=0;
        end
    end
    NetStation('Synchronize');
    NetStation('StartRecording');
    ListenChar(2);
    WaitSecs(3);
else
    ListenChar(2);
end