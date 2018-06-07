%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% SoundInit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pahandle=Init_SoundCard()

try
    % Perform basic initialization of the sound driver:
    InitializePsychSound;
    
    % Open the default audio device [], with default mode [] (==Only playback),
    % and a required latencyclass of zero 0 == no low-latency mode, as well as
    % a frequency of freq and nrchannels sound channels.
    % This returns a handle to the audio device:
    try
        % Try with the frequency we wanted:
        freq=48000; % settle freq can change regarding sound to play
        pahandle = PsychPortAudio('Open', [], [], 0, freq, 2); % open the AudioPort with spe freq
    catch
        % Failed. Retry with default frequency as suggested by device:
        fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
        fprintf('Sound may sound a bit out of tune, ...\n\n');
        
        psychlasterror('reset');
        pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels); % open AdioPort with default freq
    end
    
catch
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0)
    display('Prb Ini carte audio')
end
