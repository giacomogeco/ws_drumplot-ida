function [data,tim]=readiadgcffile(namestz)
         
global stzID

to=input('start time (yyyy-mm-dd_HH:MM)','s');
tend=input('end time (yyyy-mm-dd_HH:MM)','s');
to=datenum(to,'yyyy-mm-dd_HH:MM');
tend=datenum(tend,'yyyy-mm-dd_HH:MM');

t15=to:15/1440:tend;

ip='http://85.10.199.200/DATA/';

% http://85.10.199.200/DATA/gm2/2016/gm2_20160113/gm2_20160113_0000a480e4.gcf
%%.... LETTURA FILES
for i=1:length(t15)
    load(strcat(lower(namestz),'.mat'))
    for is=1:length(stzID),
%         index=strmatch(lower(stzID(is)),station.chname);
        file=[ip,lower(namestz),'/',datestr(t15(i),'yyyy'),'/',...
        lower(namestz),'_',datestr(t15(i),'yyyymmdd'),'/',...
        lower(namestz),'_',datestr(t15(i),'yyyymmdd_HHMM'),lower(char(station.channel(is))),'.gcf'];
        disp(file)
        urlwrite(file,[lower(namestz),'_',datestr(t15(i),'yyyymmdd_HHMM'),lower(char(station.channel(is))),'.gcf']);
        filename(is,:)=[lower(namestz),'_',datestr(t15(i),'yyyymmdd_HHMM'),lower(char(station.channel(is))),'.gcf'];
    end
    filename=cellstr(filename)';
    
%     http://85.10.199.200/matfiles/GMS/2016/GMS_20160113/GMS_20160113_000000.mat
    try
        a=mcc_read_guralp([pwd,'/'],filename);

        if i==1,
            tim=a.tt;
        else
            tim=cat(2,tim,a.tt);
        end
        a=rmfield(a,'tt');
        a=rmfield(a,'info');
        ch=fieldnames(a);
        for ii=1:length(ch)
            delete(char(filename(ii)))
            sig=a.(char(ch(ii)));
           
            if i==1,
                data.(['m',num2str(ii)])=sig;
            else
                data.(['m',num2str(ii)])=cat(2,data.(['m',num2str(ii)]),sig);
            end
        end
        clear filename
        

    catch
        disp(['...file not found'])
        continue
    end
        
        
end


return