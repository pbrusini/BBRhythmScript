function SearchForTrackersID( trackerId )
%FUNCTION "SEARCH FOR TRACKERS" IF NOTSET

    if (strcmp(trackerId, 'NOTSET'))
        warning('tetio_matlab:EyeTracking', 'Variable trackerId has not been set.'); 
        disp('Browsing for trackers...');

        trackerinfo = tetio_getTrackers();
        for i = 1:size(trackerinfo,2)
            disp(trackerinfo(i).ProductId);
        end

        tetio_cleanUp();
        error('Error: the variable trackerId has not been set. Edit the EyeTrackingSample.m script and replace "NOTSET" with your tracker id (should be in the list above) before running this script again.');
    end
    
end


