function dataOut = FFT_SNR(dataIn, output, binStart, binEnd, operation)


%% FFT
%initialise dataOut
dataOut=zeros(size(dataIn));


%loop through all the data
for channelpos=1:size(dataIn,1);
    
        switch output;
            case 'complex'
                dataOut(channelpos,:)=fft(dataIn(channelpos,:));
            case 'amplitude'
                dataOut(channelpos,:)=abs(fft(dataIn(channelpos,:)));
            case 'power'
                dataOut(channelpos,:)=abs(fft(dataIn(channelpos,:)));
                %will be squared later on in process
            case 'phase'
                dataOut(channelpos,:)=angle(fft(dataIn(channelpos,:)));
            case 'real'
                dataOut(channelpos,:)=real(fft(dataIn(channelpos,:)));
            case 'imag'
                dataOut(channelpos,:)=imag(fft(dataIn(channelpos,:)));
            case 'special'
                dataOut=dataIn;
        end;

end;
if ~strcmp(dataOut,'special')
    display('Keeping only first half of spectrum')
    dataOut=dataOut(:,1:fix(size(dataOut,2)/2));
    display('Normalizing spectrum (divide by N/2)');
    dataOut=dataOut/(size(dataOut,2)/2);
end
%square? (power)
if strcmpi(output,'power');
    dataOut=dataOut.^2;
end;
%% SNR

%dx1,dx2
dx1=binStart;
dx2=binEnd;

dataIn=dataOut;

%init bl and stdbl
bl=zeros(size(dataIn,1),size(dataIn,2));
zscore_compute=0;
if strcmpi(operation,'zscore');
    zscore_compute=1;
    stdbl=bl;
end;




%tp
tp=dataIn;
%transpose tp when there is a single electrode
if size(tp,2)==1;
    tp=tp';
end;
%dxsize
dxsize=size(dataIn,2);
%loop through dx
for dx=1:size(dataIn,2);
    dx31=dx-dx2;
    dx32=dx-dx1;
    dx41=dx+dx1;
    dx42=dx+dx2;
    if dx31<1;
        dx31=1;
    end;
    if dx32<1;
        dx32=1;
    end;
    if dx41>dxsize;
        dx41=dxsize;
    end;
    if dx42>dxsize;
        dx42=dxsize;
    end;
    %tp2
    tp2=tp(:,[dx31:dx32,dx41:dx42]);
    
    %                     if num_extreme>0; % for when you settle max bin
    %                         tp2=sort(tp2,2);
    %                         tp2=tp2(:,1+num_extreme:end-num_extreme);
    %                     end;
    
    
    % mean over selected bins
    bl(:,dx)=mean(tp2,2);
    % compute standard deviation over selected bins for
    % zscore only (save computation time for other operations).
    if zscore_compute==1;
        stdbl(:,dx)=std(tp2,[],2);
    end;
end;
switch operation
    case 'subtract'
        tp2=tp-bl;
        %tp2=bsxfun(@minus,tp,bl);
    case 'snr'
        tp2=tp./bl;
    case 'zscore'
        tp2=(tp-bl)./stdbl;
    case 'percent'
        tp2=tp-bl;
        tp2=tp2./bl;
end;
dataOut=tp2;

end
