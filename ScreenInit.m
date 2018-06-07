function [screenid, windowBG, resolWindow] = ScreenInit()
ordi=Screen('Computer');
javaaddpath(which('MatlabGarbageCollector.jar'))

Screen('Preference', 'ConserveVRAM', 4096)
% priorityLevel=MaxPriority(screenid,'WaitBlanking');
% Screen('Preference', 'VisualDebugLevel', 0); %
Screen('Preference', 'SkipSyncTests', 2);
% Screen('Preference','SuppressAllWarnings',0);% Choose output screen as usual:


% Choose output screen as usual:
screenid=1
% essential colors
white = WhiteIndex(screenid);
black = BlackIndex(screenid);
if length(Screen('Screens'))>1

    ScreenWidth=1920;
    ScreenHeight=1080;
    resolWindow=[-ScreenWidth  0 ScreenWidth ScreenHeight]; %size/place BG window
     
   % Open  window  on screen, with grey background color:
    [windowBG, windowR] =  Screen('OpenWindow',screenid, [0 0 0], resolWindow);
    
    % set priority
%     priorityLevel = MaxPriority(windowBG);
%     Priority(priorityLevel);
    
else
    ScreenResolution=Screen('Resolution', screenid); %READ screen resolution
    ScreenWidth=700;
    ScreenHeight=400;
    resolWindow=[0 0 ScreenWidth ScreenHeight]; % BG window
    windowBG=Screen(screenid,'OpenWindow',0,resolWindow);
end


% clear screen
Screen('FillRect',windowBG, [black black black],resolWindow );
Screen('Flip', windowBG);