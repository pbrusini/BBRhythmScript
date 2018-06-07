function RestingState(Freq, time, Marge, TestBloc)
KeyBoard_basics
timeRestingState=time*Freq*60; % min *freq#sec

try
    Freq=1/Freq;
    bpsecMax=Freq+Marge; %marge authorized between two sounds here will sounds between 0.47 sec to 0.53 
    bpsecMin=Freq-Marge;
    Count=0;
    
    tic
    t=toc;
    Count=Count+1

    NetStation('Event','TRSP',t, 0.001,'TEST',TestBloc,  'obs#', Count, 'cel#', 0); %sent event to netstation 
    while Count<timeRestingState
        t=GetSecs;
        if toc<=bpsecMax & toc>=bpsecMin
            to=toc
            
            NetStation('Event','TRSP',t,0.001,'TEST',TestBloc, 'obs#', Count, 'cel#', to);
            tic
            Count=Count+1
            if MakeAPause(leftsh) %with spa keycode of spacebar
                tic
                t=GetSecs;
                NetStation('Event','TRSP',t,0.001,'TEST', TestBloc, 'obs#', Count, 'cel#', 0);
                Count=Count+1;
            end
            
        elseif toc>bpsecMax % what to do if the computer lag and lost the freq
            disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
            disp('Computer lag reset the clock, check that this happen not too much during experiment')
            disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
            
            tic
            NetStation('Event','TRSP',GetSecs, 0.01,'TEST',TestBloc, 'obs#', Count, 'cel#', 0);
        end
    end
    WaitSecs(1);
    ListenChar
    NetStation('StopRecording');
catch
    ListenChar
    NetStation('StopRecording');
    rethrow(lasterror);
end
