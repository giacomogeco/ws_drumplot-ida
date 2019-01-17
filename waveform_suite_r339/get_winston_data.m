function [data,w]=get_winston_data(stz,channels,network,to,tend,ip,port,location)
% clear all
% close all

javaaddpath('C:\Users\giacomo\Documents\MATLAB\toolseis\waveform_suite_r339\usgs.jar')
% % 
% stz='PZZ';
% channels={'Z','N','E','X'};
% network='STR';
% to=datenum(2013,01,20,06,45,00);
% tend=datenum(2013,01,20,11,00,00);

% ds=datasource('winston','192.168.5.88',16088);


%% per monte vetore usa questa stringa
% [data,w]=get_winston_data('MVT',{'P1','P2','P3','P4'},'ETN',now-2/24-60/86400,now-2/24,'150.217.73.228',5900,'00');
% data sono i dati
% w è l'oggetto waveform


if nargin<6,
    ip='127.0.0.1';
    port=16088;
    location='--';
end


ds=datasource('winston',ip,port);
obj=scnlobject(stz,channels,network,location);
w=waveform(ds,obj,to,tend);
% plot(w)
% return

if isempty(w),
    data=[];
    return
end
w=fix_data_length(w);   %... vetteri output uguale
% w=fillgaps(w,[]);
yy=get(w,'data');
tt=get(w,'timevector');

if length(w)~=4,    %... se non ci sono tutti i canali
    data=[];
     disp('no data')
    return
end

% yy=cell2mat(yy');
chname=get(w,'channel');
if ~iscell(chname),
    data=[];
    disp('no data')
    return
end


% to=get(w,'start');
smp=get(w,'freq');
data.tt=tt{1};

for ich=1:length(w),    %... mette i NaN
  eval(['data.',chname{ich},'=yy{',num2str(ich),'};'])
  eval(['data.',chname{ich},'(data.',chname{ich},'==0)=NaN;'])
end


treq=linspace(to,tend,round((tend-to)*86400*smp(1)))'; %intervallo di tempo richiesto

if length(treq)>length(data.tt),
    for ich=1:length(w),
         eval(['data.',chname{ich},'=interp1(data.tt,data.',chname{ich},',treq,''linear'',NaN);'])
    end
    data.tt=treq;
end

    
    
    
    
% for ich=1:length(w),
%   eval(['data.',chname{ich},'=yy{',num2str(ich),'};'])
%   if ich==1,
%       eval(['sdata=size(data.',chname{ich},');'])
%       sdata=max(sdata);
%   else
%       eval(['sdata1=size(data.',chname{ich},');'])
%       sdata1=max(sdata1);
%       if sdata1~=sdata,
%          data=[];
%          return
%       end
%  
%   end
%   
% end
return