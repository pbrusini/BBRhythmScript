%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% NetStation synchronisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    
    fprintf('#################### \n #################### \n #################### \n Prepare NetSation \n #################### \n #################### \n #################### \n',1);
    [status, error] = NetStation('Connect','172.29.27.159', '55513');  %IP adress of the EGI MAC
    if (status ~= 0)
        fprintf('\n COMMUNICATION WITH THE MAC IMPOSSIBLE',1);
        pause;
    else
        fprintf('\n Mac is alive \n   ');
        fprintf('\n Press any key to start the experiment\n');
        pause
        NetStation('Synchronize');
        NetStation('StartRecording');
        NetStation('Event','SESS',GetSecs,0.001,'TEST',1, 'cel#', 0, 'obs#', 000);
    end
    
    WaitSecs(3);
catch
    display('prb ini NetStation')
end