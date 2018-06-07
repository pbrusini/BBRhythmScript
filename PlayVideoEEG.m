function [LeftEye, RightEye, tempstimestamp, TrigSignal] = PlayVideoEEG(moviename,Test, Grabber, shuf)

KbName('UnifyKeyNames');
escape=KbName('ESCAPE');
leftsh=KbName('LEFTSHIFT');

cmdDos='vlc --fullscreen --video-on-top --no-video-title-show --play-and-exit ';

%try


LeftEye = [];
RightEye = [];
tempstimestamp = [];
TrigSignal = [];

tetio_startTracking()
[lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;

LeftEyeTemp = lefteye;
RightEyeTemp = righteye;
tempstimestampTemp = timestamp;
TrigSignalTemp = trigSignal;

if isempty(lefteye)
else
    LeftEyeTemp(:,14) = 77;
    RightEyeTemp(:,14) = 77;
    
    LeftEye = [LeftEye;LeftEyeTemp];
    RightEye = [RightEye;RightEyeTemp];
    tempstimestamp = [tempstimestamp;tempstimestampTemp];
    TrigSignal = [TrigSignal ; TrigSignalTemp] ; 
end
pause = 0;

switch Test
    case {1,  2}
        for i=1:100
            [keyIsDown, secs, keyCode]=KbCheck;
            if (keyIsDown & keyCode(leftsh))
                pause=1;
            end
            if ~pause
                NetStation('Event','TRSP',GetSecs,0.001,'TEST',Test, 'obs#', i, 'cel#', 1);
                [status result]=system([cmdDos moviename]);
                [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
                lefteye(:,14) = 77;
                righteye(:,14) = 77;
                
                LeftEye = [LeftEye; lefteye];
                RightEye = [RightEye; righteye];
                tempstimestamp = [tempstimestamp ; timestamp];
                TrigSignal = [TrigSignal ; trigSignal];
                [keyIsDown, secs, keyCode]=KbCheck;
            end                      
            if pause% Check if need to do pause with spa keycode of spacebar
                NetStation('Event','TRSP',GetSecs,0.001,'TEST', 6, 'obs#', 0, 'cel#', 0);
                tmp=randperm(length(Grabber));
                vid=tmp(1);
                system([cmdDos Grabber{vid}]);
                pause=0;
            end
        end
    case 4
        NetStation('Event','TRSP',GetSecs,0.001,'TEST',Test, 'obs#', 1, 'cel#', 1);
        [status result]=system([cmdDos moviename]);
        [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
        lefteye(:,14) = 66;
        righteye(:,14) = 66;
        
        LeftEye = [LeftEye; lefteye];
        RightEye = [RightEye; righteye];
        tempstimestamp = [tempstimestamp ; timestamp];
        TrigSignal = [TrigSignal ; trigSignal];               
        
    case 3
        for repet=1:3
            for song=1:length(moviename)
                video=moviename{song}
                [keyIsDown, secs, keyCode]=KbCheck;
                if (keyIsDown & keyCode(leftsh))
                    pause=1;
                end
                if ~pause
                    NetStation('Event','TRSP',GetSecs,0.001,'TEST',Test, 'obs#', shuf(song), 'cel#', 1, 'repet', repet, 'file',video(61:64));
                    [status result]=system([cmdDos video]);
                    [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
                    lefteye(:,14) = 77;
                    righteye(:,14) = 77;
                    
                    LeftEye = [LeftEye; lefteye];
                    RightEye = [RightEye; righteye];
                    tempstimestamp = [tempstimestamp ; timestamp];
                    TrigSignal = [TrigSignal ; trigSignal];
                end                                
                if pause % Check if need to do pause with spa keycode of spacebar
                    NetStation('Event','TRSP',GetSecs,0.001,'TEST', 6, 'obs#', 0, 'cel#', 0);
                    tmp=randperm(length(Grabber));
                    vid=tmp(1);
                    system([cmdDos Grabber{vid}]);
                    pause=0;
                end
            end
        end
        
        
end
tetio_stopTracking
end




%end