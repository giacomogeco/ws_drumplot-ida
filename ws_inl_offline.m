% function iad(net,namestz,ConfFileName)
clear all,close all,clear global
%    function iad(net,namestz,ConfFileName)
% net='wyssen';namestz='fru';ConfFileName='conf_fru_2016_priv.txt';
net='wyssen';namestz='no1';ConfFileName='conf_no1_2017_priv.txt';
% net='wyssen';namestz='no3';ConfFileName='conf_no3_2017_priv.txt';

clear global
warning off


%%%%%%%%%% SET PATHS %%%%%%%%%%%
global working_dir slh
% [working_dir,slh]=iad_setpath;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
working_dir='/home/item/Documents/MATLAB/ws_drumplot';
slh='/';
%%%%%%%%%% STATIONS & PROCESSING PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,ConfFileName]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% noise_filename='fru_site_noise_level.mat';
noise_filename='no1_site_noise_level.mat';

global station
%% LOOP DI PROCESSING

FROM=input('FROM (yyyy-mm-dd_HH:MM)','s');
TO=input('TO (yyyy-mm-dd_HH:MM)','s');
FROM=datenum(FROM,'yyyy-mm-dd_HH:MM');
TO=datenum(TO,'yyyy-mm-dd_HH:MM');
nownames=FROM:15/1440:TO;

matfilepath='/home/item/Documents/MATLAB/ws_drumplot/matfiles/';
% /home/item/Documents/MATLAB/ws_drumplot/matfiles/FRU/2016

%%
PP1=[];PP2=[];PP3=[];PP4=[];PP5=[];pp=[];
for i15=1:length(nownames),

%     load('/home/item/Documents/MATLAB/ws_drumplot/matfiles/FRU/2015/FRU_20151209/FRU_20151209_120000.mat')

    file=[matfilepath,upper(namestz),slh,...
        datestr(nownames(i15),'yyyy'),slh, ...
        upper(namestz),'_',datestr(nownames(i15),'yyyymmdd'),slh,...
        upper(namestz),'_',datestr(nownames(i15),'yyyymmdd_HHMMSS'),'.mat'];
    
    try
        load(file)
        nw=length(data.tt);
        time=data.tt;
        data=rmfield(data,'tt');
    catch
        continue
    end
    
    load(['/home/item/Documents/MATLAB/ws_drumplot/resources/',noise_filename])
    j=FF>=1 & FF<=10;
    
%     figure,semilogx(FF,PWD,'k'),grid on,hold on 
    chf=station.wschannels;
    chfi=char(chf);chfi=str2num(chfi(:,end));
    iout=setdiff(1:5,chfi);
        t15=floor(time(1)*1440/15)*15/1440:1/1440:ceil(time(end)*1440/15)*15/1440;

    EF.(['ch',num2str(iout)])=-100*ones(1,length(t15)-1);
    EF.time=t15(1:end-1);
    for i=1:length(chf);
                
        d=data.(char(chf(i)));
        ii=isnan(d);
        d(ii)=[];
        trace=ws_drumplot_tapering(detrend(d),ceil(nw*.015/10)*10);
        
        t=time;
        t(ii)=[];
        
        k=0;
        
        for ii15=1:length(t15)-1
            iii=find(t>=t15(ii15) & t<t15(ii15+1));
            if ~isempty(iii)
                [p,f] = pwelch(trace(iii),length(trace(iii)),length(trace(iii))-1,NFFT,station.smp(1));
                dB(ii15)=mean(10*log10(p(j))-PWD(j));
            else
                dB(ii15)=-100;
            end
            EF.(lower(char(chf(i))))=dB;
            
            
%             pp=cat(2,pp,p);
           
%         semilogx(f,10*log10(p),'r')
        end
%         PP1=cat(2,PP1,p);
%         PP2=cat(2,PP2,p);
%         PP3=cat(2,PP3,p);
%         PP4=cat(2,PP4,p);
%         PP5=cat(2,PP5,p);

    end
    
%     PPP=cat(1,PPP,PP);

    ws_noise2dB_insert(EF,station)
    
end
return
     


