function pts = Init_Tobii()

tetio_init();

trackerId = 'TX300-010106740374'; %cne eye tracker

SearchForTrackersID( trackerId )

fprintf('Connecting to tracker "%s"...\n', trackerId);
tetio_connectTracker(trackerId);
tetio_setFrameRate(300);
currentFrameRate = tetio_getFrameRate;
fprintf('Frame rate: %d Hz.\n', currentFrameRate);



 %% Calibration
    SetCalibParams;
    TrackStatus;
    screenid=1;

    ScreenWidth=1920;
    ScreenHeight=1080;
    resol=[-ScreenWidth  0 ScreenWidth ScreenHeight]; %size/place BG window
     
   % Open  window  on screen, with grey background color:
    [win,res] =  Screen('OpenWindow',screenid, [153 153 153], resol);
    NetStation('Event','CALS',GetSecs, 0.001); %sent event to netstation 
    disp('Starting Calibration workflow');
    load('C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\PtsCalib.mat')
    %!!!!!!!!!!!!!!!! Calib Line 
     %%%%%%%%%%%%%HandleCalibWorkflow_CBC(Calib,win); %;%
    %%%%%%
    pts = PtsCalib;%  HandleCalibWorkflow_CBC(Calib,win); %;%PtsCalib;%   
    disp('Calibration workflow stopped');    
    Screen('CloseAll');
    NetStation('Event','CALS',GetSecs, 0.001); %sent event to netstation 
end
    
    
