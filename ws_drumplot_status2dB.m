function ws_drumplot_status2dB(t0,station)

% t0=datenum(2016,11,19,10,0,0);

channels={'VL1','VL2','VL3','VL4','VL5','TH1','TH2','TH3','TH4','TH5'};

% char(station.wsstation)
t1=t0+15/1440;
% station
% [data,w]=get_winston_data(stz,channels,network,to,tend,ip,port,location)
datestr(t0)
datestr(t1)
[data,w]=get_winston_data(station.wsstation,...
    channels,...
    station.wsnetwork,...
    t0,t1,...
    station.wsserver,...
    station.wsport,...
    station.wslocation);  
% data
if isempty(data)
    disp('!!! Warning No Data on WS !!!') 
    return
end

%%
% timemin=t0;
period=1/1440;
first = t0;
last = t1;

bins = period*((first/period):ceil(last/period));

[nloc, loc] = histc(data.tt', bins);
% v1 = accumarray(loc',data.VL1')./accumarray(loc',1); % faster than accumaray/mean

EF.time=bins(1:end-1);

EF.v1 = accumarray(loc',data.VL1',[size(bins,2) 1],@mean,NaN)/10; % faster than accumaray/mean
EF.v2 = accumarray(loc',data.VL2',[size(bins,2) 1],@mean,NaN)/10;
EF.v3 = accumarray(loc',data.VL3',[size(bins,2) 1],@mean,NaN)/10;
EF.v4 = accumarray(loc',data.VL4',[size(bins,2) 1],@mean,NaN)/10;
EF.v5 = accumarray(loc',data.VL5',[size(bins,2) 1],@mean,NaN)/10;


EF.v1=EF.v1(1:end-1);EF.v1(isnan(EF.v1))=0;
EF.v2=EF.v2(1:end-1);EF.v2(isnan(EF.v2))=0;
EF.v3=EF.v3(1:end-1);EF.v3(isnan(EF.v3))=0;
EF.v4=EF.v4(1:end-1);EF.v4(isnan(EF.v4))=0;
EF.v5=EF.v5(1:end-1);EF.v5(isnan(EF.v5))=0;

EF.t1 = accumarray(loc',data.TH1',[size(bins,2) 1],@mean,NaN)/10; % faster than accumaray/mean
EF.t2 = accumarray(loc',data.TH2',[size(bins,2) 1],@mean,NaN)/10;
EF.t3 = accumarray(loc',data.TH3',[size(bins,2) 1],@mean,NaN)/10;
EF.t4 = accumarray(loc',data.TH4',[size(bins,2) 1],@mean,NaN)/10;
EF.t5 = accumarray(loc',data.TH5',[size(bins,2) 1],@mean,NaN)/10;

% EF.time=bins(1:end-1);
EF.t1=EF.t1(1:end-1);EF.t1(isnan(EF.t1))=0;
EF.t2=EF.t2(1:end-1);EF.t2(isnan(EF.t2))=0;
EF.t3=EF.t3(1:end-1);EF.t3(isnan(EF.t3))=0;
EF.t4=EF.t4(1:end-1);EF.t4(isnan(EF.t4))=0;
EF.t5=EF.t5(1:end-1);EF.t5(isnan(EF.t5))=0;

%%
% EF.time=now;
% colnames={'time',...
%     'v1','v2','v3','v4','v5',...
%     't1','t2','t3','t4','t5'};
% EF.v1=0;EF.v2=0;EF.v3=0;EF.v4=0;EF.v5=0;
% EF.t1=0;EF.t2=0;EF.t3=0;EF.t4=0;EF.t5=0;
% station.dB_status_name=[lower(station.name),'status'];
% station.dBhost='127.0.0.1';
% station.dBuser='wwsuser';
% station.dBpassword='wwspass';
% station.dBname='W_status';

ws_status2dB_insert(EF,station);

% conn = database(station.dBname,...
%     station.dBuser,...
%     station.dBpassword, ...
%    'com.mysql.jdbc.Driver', ...
%    ['jdbc:mysql://',station.dBhost,':3306/']);
% conn.Message
% % tablename=table;
% 
% nev=length(EF.time);
% 
% exdata=cell(nev,length(colnames));
% for i=1:nev,     
%     exdata(i,:)={datestr(EF.time(i),31)...  %... tempo Database (stringa)
%         round(EF.v1(i)*10)/10 ....  %... pressure (mbar a 5 km)
%         round(EF.v2(i)*10)/10 ... %... coerenza media (0-1)
%         round(EF.v3(i)*10)/10 ...
%         round(EF.v4(i)*10)/10 ...
%         round(EF.v5(i)*10)/10 ...
%         round(EF.t1(i)*10)/10 ....  %... pressure (mbar a 5 km)
%         round(EF.t2(i)*10)/10 ... %... coerenza media (0-1)
%         round(EF.t3(i)*10)/10 ...
%         round(EF.t4(i)*10)/10 ...
%         round(EF.t5(i)*10)/10};  %... frequenza di picco della fase ad ampiezza massima (Hz)
% end
% 
% fastinsert(conn,station.dB_Status_tablename, colnames, exdata);
% close(conn);

return



