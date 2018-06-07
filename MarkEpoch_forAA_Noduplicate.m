pathIn='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered/';
pathOut='/media/Work/Data_RhythmProject/Data_Analysis/EEG_Analysis/2months/Event_Filtered_MarkedbyTrial/';
ssList=dir([pathIn '*.set']);


for i =46:length(ssList)
    subjectName = [ ssList(i).name]
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    subjectNamex = char(subjectName(:,1:length(subjectName)-6));
    NamSetResting=[subjectNamex 'Resting.set'];
    NamSetDrum=[subjectNamex 'Drum.set'];
    NamSetSyll=[subjectNamex 'Syll.set'];
    NamSetSong=[subjectNamex 'Song.set'];
    NamSetMer=[subjectNamex '_RDS.set'];
    NamSetAll=[subjectNamex '_All.set'];
    
    EEG = pop_loadset(subjectName,pathIn);
    try
        chanlocs='channel64.xyz';
        EEG=pop_chanedit(EEG,  'load',{ chanlocs, 'filetype', 'autodetect'});
    catch
        chanlocs='channel65.xyz';
        EEG=pop_chanedit(EEG,  'load',{ chanlocs, 'filetype', 'autodetect'});
    end
    Rest=[];
    Syll=[];
    Drum=[];
    Nr=[];
    
    for ev=1:length(EEG.event)
        if strcmp(EEG.event(ev).type, 'TRSP')
            switch EEG.event(ev).test
                case 0
                    EEG.event(ev).type='TRS0';
                    Rest=[Rest ev];
                case 1
                    EEG.event(ev).type='TRS1';
                    try
                        EEG.event(ev+1).type='DI_1';
                        Syll=[Syll ev+1];
                    end
                case 2
                    EEG.event(ev).type='TRS2';
                    try
                        EEG.event(ev+1).type='DI_2';
                        Drum=[Drum ev+1];
                    end
                case 3
                    Nr=[Nr ev];
                    EEG.event(ev).type='TRS3';
                    
            end
        end
    end%
    
    goodDrumforzero=[];
    goodSyllforzero=[];
    goodRstforzero=[];
    d=2
    while d<length(Drum)
        goodDrumforzero=[goodDrumforzero Drum(d)];
        d=d+16;
    end
     d=2
    while d<length(Syll)
        goodSyllforzero=[goodSyllforzero Syll(d)];
        d=d+16;
    end
    d=1;
    while d<length(Rest)
        goodRstforzero=[goodRstforzero Rest(d)];
        d=d+16;
    end
    
    for dr=1:length(goodDrumforzero)
        EEG.event(goodDrumforzero(dr)).type='D_DM';
    end
    
    for sy=1:length(goodSyllforzero)
        EEG.event(goodSyllforzero(sy)).type='D_SL';
    end
    
    for rs=1:length(goodRstforzero)
        EEG.event(goodRstforzero(rs)).type='D_RS';
    end
    
     try
        
        EEGR = pop_epoch( EEG, { 'D_RS' }, [0 8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGR = pop_rmbase( EEGR, [0  8000]);
        EEGR = pop_saveset( EEGR, NamSetResting, pathOut);
        
    end
    try
        EEGD = pop_epoch( EEG, { 'D_DM' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGD = pop_rmbase( EEGD, [0  8000]);
        EEGD = pop_saveset( EEGD, NamSetDrum, pathOut);
        
    end
    try
        
        EEGS = pop_epoch( EEG, { 'D_SL' }, [0  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
        EEGS = pop_rmbase( EEGS, [0  8000]);
        EEGS = pop_saveset( EEGS, NamSetSyll, pathOut);
    end
    
%     try % What do You do with NUSERY RHYMES :)
%         EEG.event(Nr(1)).type='BGNR';
%         
%         UpperTime=int64(EEG.xmax)-(EEG.event(Nr(1)).latency/1000);
%         EEG=pop_rmdat(EEG, {'BGNR'}, [-0.3 double(UpperTime-10)], 0);
%         
%         collDin=[];
%         for ev=1:length(EEG.event)
%             if strcmp(EEG.event(ev).type, 'DIN4') || strcmp(EEG.event(ev).type, 'D255') 
%                 collDin=[collDin ev];
%             end
%         end
%         
%         
%         for i=1:length(collDin)
%             try
%                 EEG.event(collDin(i)).latency=EEG.event(collDin(i-1)).latency+500;
%             end
%         end
%                 
%         
%         d=2;
%         goodNRforzero=[];
%         while d<length(collDin)
%             goodNRforzero=[goodNRforzero collDin(d)];
%             d=d+16;
%         end
%         
%         for nr=1:length(goodNRforzero)
%             EEG.event(goodNRforzero(nr)).type='D_NR';
%         end
%     end
%    
%     
%     try 
%   
%         EEGS = pop_epoch( EEG, { 'D_NR' }, [-0.3  8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
%         % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', 'EGI file epochs', 'save', setNamesegNx);
%         EEGS = pop_rmbase( EEGS, [-300  8000]);
%         EEGS = pop_saveset( EEGS, NamSetSong, pathOut);
%     end
    
    
end

% 
% %for am26
% for i=1:length(EEG.event)
%     if EEG.event(i).obss==1501 && EEG.event(i).test==2
%         indicesound=i;
%         EEG.event(i).type='BDrum';
%     end
% end
% % 
% UpperTime=int64(EEG.xmax)-(EEG.event(indicesound).latency/1000);
% EEG=pop_rmdat(EEG, {'BDrum'}, [-0.3 double(UpperTime-10)], 0);
% 
%  EEG.event(1).type='TRSP';
% badseg=[4 5 7 8 9 10 34 82 89 105 108 109 133 134 152 197 198 199 200 201 203 204 205 206 207 208 209 213 214 217 221 222 223 224 232 233 234 239 240 241 251 252 253 256 260 268 271 273 279 297 299 300 304 305 313 314 327 346 354 357 362 373 374 376 377 403 411 416 417 419 444 447 453 456 459 465 483 484 485 488 500]
% OUTEEG = pop_select(EEG, 'notrial', badseg);
% 
% segfroRest=[0    4    8    9   10   13   17   19   20   23   24   25   26   28   29   30   32   33   34   37   39   40   41   42   43   46   47   49   53   54   55   58   59   61   62   63   64   65   66   67   68   69   70   71   72   73   74   76   77   78   80   81   82   83   84   85   86   87   88   89   90   92   93   94   97   98   99  100  101  102  103  104  105  106  107  108  109  110  111  113  114  115  116  117  118  119  121  122  123  124  125  126  127  128  129  130  131  132  133  134  135  136  137  138  139  140  141  143  144  145  146  147  150  152  153  154  155  158  159  162  163  164  165  166  167  168  169  170  171  172  174  175  176  177  178  179  180  184  188  189  190  191  195  197  199  200  201  204  209  210  211  214  218  219  220  221  222  223  225  226  228  230  231  233  234  235  236  240  241  242  243  244  245  246  250  252  253  254  255  256  257  259  260  261  262  263  264  265  271  272  276  277  278  279  280  281  282  283  284  286  287  288  289  290  292  293  294  296  299  300  301  303  304  305  306  309  310  312  314  315  316  317  318  319  320  321  322  323  324  325  326  327  328  329  330  331  334  335  338  339  340  342  343  344  346  348  349  351  352  353  354  356  358  359  360  361  364  365  366  367  370  371  374  376  378  383  384  387  388  389  390  391  392  393  395  397  398  399  400  401  402  403  405  406  407  410  411  412  413  414  415  416  417  419];         
% tmp=randperm(length(segfroRest));
% segfroRest(tmp)
% EEG = pop_select(EEG, 'trial', segfroRest(tmp(1:90)));


% for LL12
% 
% collDin=[];
%         for ev=1:length(EEG.event)
%             if strcmp(EEG.event(ev).type, 'epoc') 
%                 collDin=[collDin ev];
%             end
%         end
% collDin
% % 
% 
% collDin =
% 
%          361        3955        4366        5301        6886        8375
% 
% EEG.event(2:361).type='TRS0';
% Expected one output from a curly brace or dot indexing expression, but there were 360 results.
%  
% for i=2:361
% EEG.event(i).type='TRS0';
%  Rest=[Rest i];
% end
% 
% Drum=[];
% for ev=362:4366
%     if strcmp(EEG.event(ev).type, 'TRSP')
%         EEG.event(ev).type='TRS2';
%         %try
%             EEG.event(ev+1).type='DI_2';
%             Drum=[Drum ev+1];
%         %end
%     end
% end

% Syll=[];
% for i=4367:8375
%     if strcmp(EEG.event(i).type, 'TRSP')
%         EEG.event(i).type='TRS1';
%         try
%             EEG.event(i+1).type='DI_1';
%             Syll=[Syll i+1];
%         end
%     end
% end
% 
%  Nr=[];
%     
%     for ev=8376:length(EEG.event)
%         if strcmp(EEG.event(ev).type, 'TRSP')
%             
%                     Nr=[Nr ev];
%                     EEG.event(ev).type='TRS3';
%                     
%             end
%         end
