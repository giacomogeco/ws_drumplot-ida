function data=ws_drumplot_read_data(stz,net,to,tend,f1,f2)

global working_dir slh
% to=now-5/1440;
% tend=now;
% f1=[.1 .1 .1 .1];
% f2=[10 10 10 10];
% stz='mvt';

% eval(['run conf_',char(stz),'.m'])
% [working_dir,slh,'conf_files',slh,net,slh,'conf_',char(stz),'.txt']
station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(stz),'.txt']);

if nargin<5,
    flag_filt=false;
else
    flag_filt=true;
end
channels=station.wschannels;%{'C1','C2','C3','C4'};
network=station.wsnetwork;%'VSR';

[data,w]=get_winston_data(char(station.wsstation),channels,network,to,tend,...
    station.wsserver,...
    station.wsport,...
    station.wslocation);

if isempty(data) || length(station.wschannels)~=length(fieldnames(data))-1,
    data=[];
    return
end

%... correzione onde quadre
if strcmp(stz,'gms')
    
%     data.CH3=remove_fibra_outliyers(data.CH3);
end

% spike remove ............
if station.spikeremove(1)==1
    tmp=data.tt;data=rmfield(data,'tt');
    data=spike_remove_hampel(data,station.smp(1));
    data.tt=tmp;
end
%...........................



for i=1:length(station.wschannels),
    sconv=(station.advoltage/2^station.adbit)/station.gain(i);
    
    data.(char(station.wschannels(i)))=data.(char(station.wschannels(i)))*sconv;   %... UM
    
    if flag_filt,
        data.(char(station.wschannels(i)))=filtrax_nan(data.(char(station.wschannels(i))),...
            f1(i),f2(i),...
            station.smp(i));
    else

        data.(char(station.wschannels(i)))=data.(char(station.wschannels(i)))-nanmean(data.(char(station.wschannels(i))));
    end
end

return

