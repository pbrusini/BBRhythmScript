function calibPlotData = Calibrate_baby(Calib,mOrder,iter,donts,win)
%CALIBRATE calibrate the eyetracker
%   This function is used to set and view the calibration results for the tobii eye tracker. 
%
%   Input: 
%         Calib: The calib structure (see CalibParams)
%         morder: Order of the calibration point 
%         iter: 0/1 (0 = A new calibation call, esnure that calibration is not already started)
%                   (1 = just fixing a few Calibration points)
%         donts: Points (with one in the index) that are to be
%         recalibrated, 0 else where
%   Output: 
%         calibPlotData: The calibration plot data, specifying the input and output calibration data

    repetitions = 1;
    assert(Calib.points.n >= 2 && length(Calib.points.x)==Calib.points.n, ...
      'Err: Invalid Calibration params, Verify...');
    Calib.mondims = Calib.mondims1;
    try
        tetio_stopCalib;
        PsychPortAudio('Close');
    end
    if (iter==0)
        tetio_startCalib;    
    end
    
    validmat = ones(1,Calib.points.n);
    %generate validity matrix 
    if ~isempty(donts)
        validmat = zeros(1,Calib.points.n);
        for i = 1:length(donts)
           validmat(donts(i))=1;
        end
    end
    
    pause(1);

    
    % folder of the calib stim
    InitializePsychSound;
    Fixdirectory = 'C:\Users\CNEBabyLab\Documents\Experiment\EEG_script\Stimuli\Fixation\';
    SoundList = dir(strcat(Fixdirectory,'*.wav'));
    PicList = dir(strcat(Fixdirectory,'*.png'));
    
    freq=44100;
    nrchannels = 1; 
    pahandleA = PsychPortAudio('Open', [], [], repetitions, freq, nrchannels);
            
    for i =1:Calib.points.n;
        if (validmat(i)==0)
            continue;
        end
        %load sound in Soundcard
        [y, freq, nbits] = wavread(strcat(Fixdirectory, SoundList(mOrder(i)).name));
        wavedata = y';
        PsychPortAudio('FillBuffer', pahandleA, wavedata);
        destinationRect = [Calib.mondims.width*Calib.points.x(mOrder(i))-70 Calib.mondims.height*Calib.points.y(mOrder(i))-70 Calib.mondims.width*Calib.points.x(mOrder(i))+70 Calib.mondims.height*Calib.points.y(mOrder(i))+70];
        
        if (i==Calib.points.n)
            if (mod(i,2)==1)
                 [y, freq, nbits] = wavread(strcat(Fixdirectory, SoundList(mOrder(i)).name));
                wavedata = y';
                PsychPortAudio('FillBuffer', pahandleA, wavedata);
                fixation(Fixdirectory, PicList, destinationRect, win, pahandleA);
                if ~isempty(donts)
                    tetio_removeCalibPoint(Calib.points.x(mOrder(i)), Calib.points.y(mOrder(i)));
                    disp(['deleted point ' num2str(mOrder(i)) ' and now adding it, where i = ' num2str(i)])
                end
                
                display('Press a key to display the next stimulus!','s')
                pause
                tetio_addCalibPoint(Calib.points.x(mOrder(i)),Calib.points.y(mOrder(i)));
                
            else
                 [y, freq, nbits] = wavread(strcat(Fixdirectory, SoundList(mOrder(i)).name));
                wavedata = y';
                PsychPortAudio('FillBuffer', pahandleA, wavedata);
                fixation(Fixdirectory, PicList, destinationRect, win, pahandleA);
                if ~isempty(donts)
                    tetio_removeCalibPoint(Calib.points.x(mOrder(i)), Calib.points.y(mOrder(i)));
                    disp(['deleted point ' num2str(mOrder(i)) ' and now adding it, where i = ' num2str(i)])
                end
                
                display('Press a key to display the next stimulus!','s')
                pause
                tetio_addCalibPoint(Calib.points.x(mOrder(i)),Calib.points.y(mOrder(i)));
            end
            
        else
            if (mod(i,2)==1)
                 [y, freq, nbits] = wavread(strcat(Fixdirectory, SoundList(mOrder(i)).name));
                wavedata = y';
                PsychPortAudio('FillBuffer', pahandleA, wavedata);
                fixation(Fixdirectory, PicList, destinationRect, win, pahandleA);
                if ~isempty(donts)
                    tetio_removeCalibPoint(Calib.points.x(mOrder(i)), Calib.points.y(mOrder(i)));
                    disp(['deleted point ' num2str(mOrder(i)) ' and now adding it, where i = ' num2str(i)])
                end
                
                display('Press a key to display the next stimulus!','s')
                pause
                tetio_addCalibPoint(Calib.points.x(mOrder(i)),Calib.points.y(mOrder(i)));
            else
                 [y, freq, nbits] = wavread(strcat(Fixdirectory, SoundList(mOrder(i)).name));
                wavedata = y';
                PsychPortAudio('FillBuffer', pahandleA, wavedata);
                fixation(Fixdirectory, PicList, destinationRect, win, pahandleA);
                if ~isempty(donts)
                    tetio_removeCalibPoint(Calib.points.x(mOrder(i)), Calib.points.y(mOrder(i)));
                    disp(['deleted point ' num2str(mOrder(i)) ' and now adding it, where i = ' num2str(i)])
                end
                
                display('Press a key to display the next stimulus!','s')
                pause
                tetio_addCalibPoint(Calib.points.x(mOrder(i)),Calib.points.y(mOrder(i)));
            end
        end
    end
    
    PsychPortAudio('Close', pahandleA);
    pause(0.5);
    Screen('DrawText', win, ' ', [], []);
    Screen('Flip', win );
    
    close
    tetio_computeCalib;
    %     Screen('CloseAll');
    calibPlotData = tetio_getCalibPlotData;
end


