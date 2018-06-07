function fixation(Fixdirectory, PicList,destinationRect, window,  pahandleA)

NewCenter=destinationRect;
t=GetSecs;
while GetSecs<t+5
    PsychPortAudio('Start', pahandleA,1, 0, 1);
    for pl=1:length(PicList)
        m=imread([Fixdirectory PicList(pl).name]);
        %CONVERT it to a texture
        object=Screen('MakeTexture',window,m);
        
        %PRESENT object
        Screen('DrawTexture',window,object,[], NewCenter); %draw the object middle of the screen            object_on=Screen('Flip',window); %present the object
        object_on=Screen('Flip',window); %present the object
        WaitSecs(0.07);
    end
end


end