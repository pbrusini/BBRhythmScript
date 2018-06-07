function  EEG=Insert_Event(EEG, FileName,PathName)

%%%%%%%%%%put related information from .evt file to array%%%%%%%%%%%%%
disp('Addition of Specifications to events')
disp('Only TRSP will be attributed to new value, modify DIn regarding your design!!')
disp (' ')

if nargin >=2    
    fid = fopen([PathName '/' FileName '.evt']);
else
    [FileName,PathName] = uigetfile('*.evt','Select the event file');
    
end

evtFile=loadtxt([PathName FileName]);

if length(evtFile)==length(EEG.event)+4
    disp('Nber Event btwn .evt &.raw is the same')
else
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    disp('Nber Event btwn .evt &.raw is different')
    disp('!!!Check the result of this function!!')
end
    
    listTRSP=[];
    for t=1:length(evtFile)
        if strcmp(evtFile{t,1}, 'TRSP')
            listTRSP=[listTRSP; evtFile(t,:)];
        end
    end
    
    indicTRSP=[];
    tmpEvent=struct([]);
    for ev=1:length(EEG.event)
        tmp=struct('type',EEG.event(ev).type, 'latency', EEG.event(ev).latency, 'urevent', EEG.event(ev).urevent, ....
            'test', 000, 'cell', 000, 'obss', 000, 'song', 000, 'repe',000, 'numS', 000);            
        if strcmp(EEG.event(ev).type, 'TRSP')
            indicTRSP=[indicTRSP, ev];
        end
        if ev==1
            tmpEvent=tmp;
        else
            tmpEvent=cat(2, tmpEvent, tmp);
        end
            
    end
    
    if ~ length(indicTRSP)==length(listTRSP)
        disp('!!!NOT The same number of TRSP Advise to recheck every param!!')
    end
    
    din=1;
    for ev=1:length(indicTRSP)
                    tmpEvent(indicTRSP(ev)).cell=listTRSP{ev, 14};
            tmpEvent(indicTRSP(ev)).obss=listTRSP{ev, 12};
            tmpEvent(indicTRSP(ev)).test=listTRSP{ev, 10};
            if listTRSP{ev, 10}==3
                try
                    tmpEvent(indicTRSP(ev)).song=listTRSP{ev, 20};
                    tmpEvent(indicTRSP(ev)).repe=listTRSP{ev, 18};
                    tmpEvent(indicTRSP(ev)).numS=listTRSP{ev, 16};
                catch
                    tmpEvent(indicTRSP(ev)).song=listTRSP{ev, 18};
                    tmpEvent(indicTRSP(ev)).repe=listTRSP{ev, 16};
                end
            end
                    
            

            %         if listTRSP{ev, 10}>0 & listTRSP{ev, 10}<3
            %             while ~ abs(tmpEvent(indicDin(din)).latency-tmpEvent(indicTRSP(ev)).latency)<255
            %                 din=din+1;
            %             end
            %             tmpEvent(indicDin(din)).test =listTRSP{ev, 10};
            %             tmpEvent(indicDin(din)).cell=listTRSP{ev, 14};
            %             tmpEvent(indicDin(din)).obss=listTRSP{ev, 12};
            %             din=din+1;
            %         end
        end
        
        EEG.event=tmpEvent;
    end
        

    
                