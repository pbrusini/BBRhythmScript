function pts = HandleCalibWorkflow_CBC(Calib,win)
%HandleCalibWorkflow Main function for handling the calibration workflow.
%   Input:
%         Calib: The calib config structure (see SetCalibParams)
%   Output:
%         pts: The list of points used for calibration. These could be
%         further used for the analysis such as the variance, mean etc.


while(1)

%     try
        mOrder = randperm(Calib.points.n); %[1 2 3 4 5] %
        calibplot = Calibrate_baby(Calib, mOrder, 0, [],win); % Can change this function for Calibrate
        pts = PlotCalibrationPoints(calibplot, Calib, mOrder);% Show calibration points and compute calibration.
        
        while(1)
            h = input('Accept calibration? ([y]/n):','s');  
            if isempty(h) || strcmp(h(1),'y')
                tetio_stopCalib;
                close;
                return; 
            end
            
            h = input('Recalibrate all points (a) or some points (b)? ([a]/[b]):','s'); 
            
            if isempty(h) || (strcmp(h(1),'a'))
                close all;
                tetio_stopCalib;
                break; 
            else
                while (1)
                    h = input('Please enter (space separated) the point numbers that you wish to recalibrate e.g. 1 3: ', 's');
                    recalibpts = str2num(h);
                    calibplot = Calibrate_baby(Calib, mOrder, 1, recalibpts,win);
                    pts = PlotCalibrationPoints(calibplot, Calib, mOrder);
                    
                    h = input('Accept calibration? ([y]/n):','s');  
                    if isempty(h) || strcmp(h(1),'y')
                        tetio_stopCalib;
                        close;
                    return; 
            end
                    
                end
            end         
            
        end
%     catch ME    %  Calibration failed
%         tetio_stopCalib;
%         ShowCursor;
%         h = input('Not enough calibration data. Do you want to try again([y]/n):','s');
%         if isempty(h) || strcmp(h(1),'y')
%             close all;            
%             continue; 
%         else
%             return;    
%         end
%         
%     end
end








