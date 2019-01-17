function flag = ws_drumplot_matfile(station,t0,working_dir,slh,net)
% flag = ws_drumplot_matfile( station ,stzdata,working_dir,slh)
%   Save .mat file on mafiles folder

switch station.name
    case {'lvn','gm2','gms'}
        data=drumplot_readWYACserverdata(upper(station.name),t0,t0+15/1440); 
    otherwise
        data=ws_drumplot_read_data(lower(station.name),net,...
        t0,t0+15/1440);
end


path=[ working_dir,slh,'matfiles',slh,...
    station.name,slh,...
    datestr(t0,'yyyy'),slh,...
    station.name,'_',datestr(t0,'yyyymmdd')];

mkdir(path)

filename=[station.name,'_',datestr(t0,'yyyymmdd_HHMMSS'),'.mat'];

disp(['... saving ',filename])

% time=stzdata(:,end);
% pressure=stzdata(:,1:end-1);
info.smp=station.smp;

try
    save([path,slh,filename],'data','info')
    flag=1;
catch
    flag=0;
end

end

