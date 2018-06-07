pathin='/media/Work/Data_RhythmProject/Data_Analysis/ETdata/';
pathout='/media/Work/Data_RhythmProject/Data_Analysis/ETdata/ETFReport/';
ssList=dir([pathin '*.mat']);

eyeArrayHeader_Left={'Eyeposition3d_Left.x','Eyeposition3d_Left.y','Eyeposition3d_Left.z','Eyeposition3dRelative_Left.x','Eyeposition3dRelative_Left.y', ...
    'Eyeposition3dRelative_Left.z','GazePoint2d_Left.x','GazePoint2d_Left.y','GazePoint3d_Left.x','GazePoint3d_Left.y','GazePoint3d_Left.z','PupilDiameter_Left','Validity_Left','Trigger'};
eyeArrayHeader_Right={'Eyeposition3d_Right.x','Eyeposition3d_Right.y','Eyeposition3d_Right.z','Eyeposition3dRelative_Right.x','Eyeposition3dRelative_Right.y', ...
    'Eyeposition3dRelative_Right.z','GazePoint2d_Right.x','GazePoint2d_Right.y','GazePoint3d_Right.x','GazePoint3d_Right.y','GazePoint3d_Right.z','PupilDiameter_Right','Validity_Right','Trigger'};
timeStampHeader = { 'Eye_Tracker_Timestamp'};
trigSignalHeader={'Trigger Signal'};
ETHeader=[timeStampHeader eyeArrayHeader_Left(7) eyeArrayHeader_Left(8) eyeArrayHeader_Left(13) eyeArrayHeader_Right(7) eyeArrayHeader_Right(8) eyeArrayHeader_Right(13) eyeArrayHeader_Right(14) trigSignalHeader];

ExtractData=ETHeader;

AOI_LeftObj_MIN_X = 17/1920;
AOI_LeftObj_MAX_X = 941/1920;
AOI_LeftObj_MIN_Y = 270/1080;
AOI_LeftObj_MAX_Y = 810/1080;

AOI_RightObj_MIN_X = 974/1920;
AOI_RightObj_MAX_X = 1909/1920;
AOI_RightObj_MIN_Y = 270/1080;
AOI_RightObj_MAX_Y = 810/1080;

pattern='\w*(wr|WR)\w*\d+.mat';
for I=1:length(ssList)
    Toanalyse=regexp(ssList(I).name, pattern, 'match');
    try
        load([pathin Toanalyse{1}])
        VarTosave=ssList(I).name(1:length(ssList(I).name)-4);
        lookET=[Nom.ET(:,1) Nom.ET(:,8) Nom.ET(:,9) Nom.ET(:,14) Nom.ET(:,22) Nom.ET(:,23) Nom.ET(:,28) Nom.ET(:,29) Nom.ET(:,30)];
        plot(lookET(:,2), lookET(:,3))
        
        % vars
        lookLeft = 0; lookRight = 0; noMira = 0; noData=0;
        TotalLeft = [];
        TotalRight = [];
        TrackObjt=[];
        t=1;
        for i=1:length(lookET)
            timeStamp=(lookET(i,1)-lookET(1,1))/1000;
            ExtractData{i+1,1}=timeStamp;
            ExtractData{i+1,2}=lookET(i,2);
            ExtractData{i+1,3}=lookET(i,3);
            ExtractData{i+1,4}=lookET(i,4);
            ExtractData{i+1,5}=lookET(i,5);
            ExtractData{i+1,6}=lookET(i,6);
            ExtractData{i+1,7}=lookET(i,7);
            ExtractData{i+1,8}=lookET(i,8);
            ExtractData{i+1,9}=lookET(i,9);
            try
                if lookET(i-1,8)<570 && lookET(i,8)==570 && t<33 && i>4
                    t=t+1;
                end
            end
            
            if strcmp(Nom.Groupe{5,t}, 'td')
                Target=1;
            elseif strcmp(Nom.Groupe{5,t}, 'dt')
                Target=2;
            end
            %% look ObjectLeft
            if ((AOI_LeftObj_MIN_Y <= lookET(i,3) && lookET(i,3) <= AOI_LeftObj_MAX_Y) && (AOI_LeftObj_MIN_X <= lookET(i,2) && lookET(i,2) <= AOI_LeftObj_MAX_X)...
                    || (AOI_LeftObj_MIN_Y <= lookET(i,6) && lookET(i,6) <= AOI_LeftObj_MAX_Y) && (AOI_LeftObj_MIN_X <= lookET(i,5) && lookET(i,5) <= AOI_LeftObj_MAX_X))
                lookLeft = lookLeft + 1;
                lookObj=1;
                
                %% look ObjectRight
            elseif ((AOI_RightObj_MIN_Y <= lookET(i,3) && lookET(i,3) <= AOI_RightObj_MAX_Y) && (AOI_RightObj_MIN_X <= lookET(i,2) && lookET(i,2) <= AOI_RightObj_MAX_X)...
                    || (AOI_RightObj_MIN_Y <= lookET(i,6) && lookET(i,6) <= AOI_RightObj_MAX_Y) && (AOI_RightObj_MIN_X <= lookET(i,5) && lookET(i,5) <= AOI_RightObj_MAX_X))
                lookRight = lookRight + 1;
                lookObj=2;
            elseif lookET(i,4)==0 || lookET(i,7)==0
                noMira = noMira + 1;
                lookObj=0;
            else
                noData=noData+1;
                lookObj=-1;
            end
            TrackObjt=[TrackObjt; timeStamp lookET(i,8) lookET(i,9) t Target lookObj ];
        end
        %save the big struct of all recording for exp
        
        fid = fopen([pathout 'ExtractData_' VarTosave '.csv'], 'w') ;
        fprintf(fid, '%s,', ExtractData{1,1:end-1}) ;
        fprintf(fid, '%s\n', ExtractData{1,end}) ;
        fclose(fid) ;
        dlmwrite([pathout 'ExtractData_' VarTosave '.csv'], ExtractData(2:end,:), '-append') ;
                
       
        
        lookTarget=0; lookDsitractor=0; lookNothing=0; lookScreen=0; Trial=0;
        TablePourcentLook=[];
        TableLook=[];
        trial=0;
        v=0;
        while v<length(TrackObjt)
            v=v+1;
            try
                if TrackObjt(v-1,4)<TrackObjt(v,4)
                    trial=trial+1;
                    TablePourcentLook=[TablePourcentLook; trial lookTarget/Trial lookDsitractor/Trial lookScreen/Trial lookNothing/Trial ];
                    TableLook=[TableLook; trial lookTarget lookDsitractor lookScreen lookNothing Trial];
                    lookTarget=0; lookDsitractor=0; lookNothing=0; Trial=0; lookScreen=0;
                end
            end
            
            if TrackObjt(v,2)==1 || TrackObjt(v,2)==2
                if TrackObjt(v-1,2)==570
                    v=v+300;
                    vv=v+900
                end
                if TrackObjt(v,5) == TrackObjt(v,6) & v<vv
                    lookTarget=lookTarget+1;
                    Trial=Trial+1;
                elseif TrackObjt(v,6) == 0 & v<vv
                    lookScreen=lookScreen+1;
                    Trial=Trial+1;
                elseif TrackObjt(v,6) == -1 & v<vv
                    lookNothing=lookNothing+1;
                    Trial=Trial+1;
                elseif TrackObjt(v,6)~= TrackObjt(v,5) & v<vv
                    lookDsitractor=lookDsitractor+1;
                    Trial=Trial+1;
                end
            end
        end
    
    
    TrialResult={};
    TrialResult{1,1}='Traget';
    TrialResult{1,2}='display';
    TrialResult{1,3}='Target/DistractorLook';
    TrialResult{1,4}='LookingTargetPourcent';
    TrialResult{1,5}='LookingDistractorPourcent';
    TrialResult{1,6}='LookingElseScreen';
    TrialResult{1,7}='NoETdata';
    fid = fopen([pathout 'TrialResult_' VarTosave '.csv'], 'w') ;
    fprintf(fid, '%s,', TrialResult{1,1:end-1}) ;
    fprintf(fid, '%s\n', TrialResult{1,end}) ;
    
     listlabel = {'apple' 'hair' 'hand' 'cookie' 'leg' ...
       'juice' 'mouth' 'spoon' 'milk' ...
        'banana' 'eyes' 'bottle' 'ear' ...
        'nose' 'yogurt' 'foot' 'banana'};    
    
    for c=2:length(Nom.Groupe)
        try
            TrialResult{c,1}=Nom.Groupe{4,c};
            TrialResult{c,2}=Nom.Groupe{5,c};
            
            TrialResult{c,3}=(TablePourcentLook(c,2)-TablePourcentLook(c,3))/(TablePourcentLook(c,2)+TablePourcentLook(c,3));
            TrialResult{c,4}=TablePourcentLook(c,2);
            TrialResult{c,5}=TablePourcentLook(c,3);
            TrialResult{c,6}=TablePourcentLook(c,4);
            TrialResult{c,7}=TablePourcentLook(c,5);
            
            fprintf(fid, '%s,', TrialResult{c,1:2}) ;
            fprintf(fid, '%d,', TrialResult{c,3:end}) ;
            fprintf(fid, '\n') ;
        end
       
    end
     fclose(fid) ;
    %save the table of % looking to images
    
    listlabel = {'apple' 'hair' 'hand' 'cookie' 'leg' ...
       'juice' 'mouth' 'spoon' 'milk' ...
        'banana' 'eyes' 'bottle' 'ear' ...
        'nose' 'yogurt' 'foot' };      
    
    
   
    end
end
    
    
    
    
    
    
