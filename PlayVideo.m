function PlayVideo(moviename, screenid, resolmovie, start, durmovie)
KbName('UnifyKeyNames');
escape=KbName('ESCAPE');


    [keyIsDown, secs, keyCode]=KbCheck;  
    
    % Open 'windowrect' sized resol, window on screen, with black [0] background color:
    windowm = Screen('OpenWindow', screenid, 0, resolmovie);
    
    % Open movie file:
    movie= Screen('OpenMovie', windowm, moviename);
    
    
    % Start playback engine:
    Screen('PlayMovie', movie, 1);
    
    % Playback loop: Runs until end of movie or keypress:
    while ~KbCheck & GetSecs<start+durmovie
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', windowm, movie);
        
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end
        
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', windowm, tex);
        
        % Update display:
        Screen('Flip', windowm);
    end
    
    
    % Close movie:
    Screen('CloseMovie', movie);
    Screen('Close', windowm);
    
%     catch ME
%         Screen('CloseAll');
%         rethrow(ME);
% end