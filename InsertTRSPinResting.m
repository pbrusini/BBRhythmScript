tmp=[];

tmp=EEG.event(1);

for i=2:360
    tmp=cat(2,tmp, EEG.event(i))
end
save RestingTRSP tmp

EEGN=EEG;


for i=1:length(tmp)
    tmp(i).duration=0;
    EEGN.event(i)=tmp(i)
end

for i=length(tmp)+1:2860+length(tmp)
     EEGN.event(i)=EEG.event(i-length(tmp))
end