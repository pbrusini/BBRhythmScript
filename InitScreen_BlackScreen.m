
try
ordi=Screen('Computer');
%READ the presentation screen size
    scr=Screen('Screens');
       
    PresScreen=0; %by default there is only one monitor
    resol=[50 50 700 500]; % small window
    ScreenWidth=700;
    ScreenHeight=500;
    if size(scr,2)>1 %CHECK if a second monitor is connected
        PresScreen=1;%SET the first (tobii) monitor as presentation screen
        resol=Screen('Rect',PresScreen); % fulscreen
        ScreenResolution=Screen('Resolution', PresScreen); %READ screen resolution
        ScreenWidth=ScreenResolution(1).width;
        ScreenHeight=ScreenResolution(1).height;
    end
  
    
    % preferences PTB
    priorityLevel=MaxPriority(scr,'WaitBlanking');
    Screen('Preference', 'VisualDebugLevel', 1); % vire fenetre 'welcome'
    %ListenChar(2); %elimine entrees clavier sur fenetre
    
    % some usefull colors
    white = WhiteIndex(scr); %255
    black = BlackIndex(scr); %0
    
    
    %%%%%%  black screen
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference','SkipSyncTests',0);
    Screen('Preference','SuppressAllWarnings',0);
    [window,rect]=Screen(PresScreen,'OpenWindow',black,resol,32,2);
    
    catch
    display('!!!!!!!!!!!  Problem initialisation Screen !!!!!!!!!!!')
end