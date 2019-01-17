function ws_drumplot_inl2dB(t0,station)

% t0=datenum(2016,11,19,10,0,0);

% channels={'VL1','VL2','VL3','VL4','VL5','TH1','TH2','TH3','TH4','TH5'};
channels=station.wschannels;
% char(station.wsstation)
t1=t0+(15)/1440;
% t0=t1-3/24;
% station
% [data,w]=get_winston_data(stz,channels,network,to,tend,ip,port,location)
beni=char(station.name);
switch beni

   case {'lvn','gm2','gms','gtn','lpb','rsp','hrm'}
       data=drumplot_readWYACserverdata(upper(beni),t0,t1);
    otherwise
        [data,w]=get_winston_data(station.wsstation,...
            channels,...
            station.wsnetwork,...
            t0,t1,...
            station.wsserver,...
            station.wsport,...
            station.wslocation);  
end

if isempty(data)
    disp('!!! Warning No Data on WS !!!') 
    return
end

for i=1:length(station.wschannels),
    sconv=(station.advoltage/2^station.adbit)/station.gain(i);
    
    data.(char(station.wschannels(i)))=data.(char(station.wschannels(i)))*sconv;

end

load(station.noise_filename)
j=FF>=1 & FF<=10;
nw=length(data.tt);
chfieldo=fieldnames(data);
chfieldo=chfieldo(2:end);
chfield=char(chfieldo);
chfield=str2num(chfield(:,end));

c1= setdiff(1:5,chfield);
[aa,bb]=ismember(1:5,chfield);
% figure,
%[char(station.wschannels)]
for i=1:5
    
    d=data.([char(station.wschannels(bb(i)))]);
    ii=isnan(d);
    d(ii)=[];
    
    if i==c1
        EF.(['ch',num2str(i)])=-100;
        continue
    end
    if isempty(d)
        EF.(['ch',num2str(i)])=-100;
        continue
    end
        %d=data.([char(station.wschannels(i))]);
	%d=data.([char(station.wschannels(bb(i)))]);
        
    trace=ws_drumplot_tapering(detrend(d),ceil(nw*.015/10)*10);
    [p,f] = pwelch(trace,length(trace),length(trace)-1,NFFT,station.smp(1));
    EF.(['ch',num2str(i)])=mean(10*log10(p(j))-PWD(j));
%         semilogx(f,10*log10(p),'r')
%         hold on  
    
end
% semilogx(f,PWD,'k')
EF.time=t1;

ws_noise2dB_insert(EF,station);

return



