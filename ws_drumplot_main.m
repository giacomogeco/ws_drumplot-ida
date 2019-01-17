 function ws_drumplot_main(net)
%  clear all,
 close all
 warning off
% net='wyssen-BC';

%  delete(timerfindall)
if strcmp(computer,'GLNXA64'),slh='/';else slh='\';end
mainpath=mfilename('fullpath');
i=strfind(mainpath,slh);
mainpath=mainpath(1:i(end)-1);
cd(mainpath)
javaaddpath([mainpath,slh,'jar/usgs.jar'])
clear mainpath slh
% javaaddpath('C:\Users\giacomo\Documents\MATLAB\toolseis\mcca_location\mysql-connector-java-5.1.5-bin.jar')

if strcmp(computer,'GLNXA64'),slh='/';else slh='\';end
mainpath=mfilename('fullpath');
i=strfind(mainpath,slh);
mainpath=mainpath(1:i(end)-1);
cd(mainpath)
javaaddpath([mainpath,slh,'jar/mysql-connector-java-5.0.6-bin.jar'])
clear mainpath slh
% javaaddpath('C:\Users\giacomo\Documents\MATLAB\toolseis\ws_drumplot\waveform_suite_r339\usgs.jar')

global t_line nstz oreOnScreen namestz linee Cday
global last15time
global working_dir slh
global OLD_Han TIT_Han AX_Han AX_HanL LEG_Han HAN_Xlab
global rez

if strcmp(computer,'GLNXA64'),slh='/';else slh='\';end
working_dir=mfilename('fullpath');
i=strfind(working_dir,slh);
working_dir=working_dir(1:i(end)-1);
if strcmp(computer,'GLNXA64'),slh='/';else slh='\';end


% slh='\';
% working_dir='C:\Users\giacomo\Documents\MATLAB\toolseis\ws_drumplot';

a=dir([working_dir,slh,'conf_files',slh,char(net),slh,'*conf_*.txt']);
a=struct2cell(a);
a=a(1,:);
for i=1:size(a,2)
    
    b=char(a(i));
    j1=findstr(b,'_');
    j2=findstr(b,'.');
    namestz{i}=b(j1+1:j2-1);

end

station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(i)),'.txt']);

if exist([working_dir,slh,station.figuresdir,char(net),slh],'dir')
else
    mkdir([working_dir,slh,station.figuresdir,char(net),slh])
end
nstz=length(namestz);

oreOnScreen=6;
t_line=900;
linee=oreOnScreen*3600/t_line;

% Last_Time=floor(now*1440/15)*15/1440+15/1440;
timeStart=now;

T=floor(timeStart*86400/900);   %... 900-esimi di secondi
T1=T*900/86400;
T2=T1-oreOnScreen/24+15/1440;
last6Htimes=T2:15/1440:T1;
last6Htimes=last6Htimes(end:-1:1); %ultimo quarto d'ora non apribile
last15time=last6Htimes(1);
% datestr(last15time,'HH:MM:SS.FFF')


%%  CARICO DATI DELLE ULTIME 6 ORE
for istz=1:nstz,  
   clear DAT
   
%    eval(['run conf_',char(namestz(istz)),'.m'])
   station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(istz)),'.txt']);
   
    for ii=1:length(last6Htimes)    %... ordine crescente

        to=last6Htimes(ii);
        tend=last6Htimes(ii)+15/1440-1/86400;
        
        beni=char(namestz(istz));
        switch beni
            
           case {'lvn','gm2','gms','gtn','lpb','rsp','hrm','rpc'}
               data=drumplot_readWYACserverdata(upper(beni),to,tend,...
                   station.filter(:,1),station.filter(:,2));
           otherwise
               data=ws_drumplot_read_data(namestz(istz),net,...
                   to,tend,...
                   station.filter(:,1),station.filter(:,2));
        end
        if isempty(data)
            smpempty=1;
            MD=NaN*zeros(length(station.wschannels)+1,smpempty*t_line);    %... NB
            MD(length(station.wschannels)+1,:)=to:(1/smpempty)/86400:tend;
        else
            MD=zeros(length(station.wschannels)+1,length(data.tt));
            for ich=1:length(station.wschannels)+1
                if ich==length(station.wschannels)+1
                    MD(ich,:)=data.tt;
                else
                    MD(ich,:)=data.(char(station.wschannels(ich)));
                end
            end
        end
    
        DAT(ii,1:size(MD,2),:)=MD';
     
        DATA.(strcat('OLDtrace',char(namestz(istz))))=DAT;
    end
end
clear DAT MD 

%%
bgcol=[230/255 230/255 230/255];
global graycol velvlpcol
graycol=[.6 .6 .6];
velvlpcol=[1 0 0];
width=850;  %... PIXELS
height=600;
rez=150;    %... dpi

%.... INIZIALIZZO FIGURA .....%
F=figure(1);
set(F,'toolbar','none','menubar','none','Position',get(0,'monitorPositions'),...
    'numbertitle','off','name',['WINSTON DRUM PLOT ',upper(net),' NETWORK'],...
    'backingstore','off','color','w','doublebuffer','off','renderer','zbuffer',...
    'tag','f1','color','w')
set(F,'paperunits','inches',...
    'paperposition',[0 0 width/rez height/rez],...
    'invertHardcopy','off')%,'UIContextMenu',cmenu)
%.... LOGO ...................%
% logo=imread('UNIFI_1.tif');
% logo=imread('LOGO_ITEM_UNIFI_TT.jpg');
% logo=imread('GeCo-srl.jpg');
% ha=axes('units','normalized','position',[0 0 .97 .97]);
% hi=image(logo);
% % alpha(.5)
% axis equal,
% %set(hi,'AlphaData',0.1)
% axis(ha,'off')
% % colormap gray,
% set(ha,'position',[.2 .2 0.6 0.6])


minu=t_line/60;
Tnow=last6Htimes(end);  
%%% COLORS %%%%
CC=[[0 0 0];[221/255 8/255 6/255];[0 0 212/255];[0 128/255 17/255]];
Cday=repmat(CC,24*(60/(minu*4)),1);
h_now=1+floor((Tnow-floor(Tnow))*1440/15);
Cnow=Cday(h_now,:);

t_now=floor(Tnow*24*3600/t_line);
to=datevec(t_now/24/(3600/t_line));
too=datenum(to);

for ii=1:nstz,   
%     eval(['run conf_',char(namestz(ii)),'.m'])
    station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(ii)),'.txt']);

    for iii=1:length(station.wschannels),
        
        AX_Han(ii,iii)=axes;
        set(AX_Han(ii,iii),'units','normalized','pos',[.06 .1 .9 .85],'box','on','fontsize',6,...
            'FontName','Bitstream charter','tag',['axMonitor',num2str(iii)],'xcolor','k','ycolor','k','color','none','drawmode','fast',...
            'xlim',[0 t_line],'box','on','xgrid','on',...
            'drawmode','fast','xtick',0:60:t_line,...
            'xticklabel',0:t_line/60);
        Ytk=0:station.drumshift(iii):station.drumshift(iii)*linee;
        set(AX_Han(ii,iii),'Ylim',[Ytk(1)-station.drumshift(iii) Ytk(end)+station.drumshift(iii)],'ytick',Ytk);
        HAN_Xlab=xlabel('M I N U T E S','FontName','Bitstream charter',...
            'Fontsize',6,'Fontweight','bold');
        
        AX_HanL(ii,iii)=axes;
        set(AX_HanL(ii,iii),'units','normalized','pos',[.06 .1 .9 .85],'box','on','fontsize',5,...
            'FontName','Bitstream charter','tag',['axMonitorL',num2str(iii)],'xcolor','k','ycolor','k','color','none','drawmode','fast',...
            'xlim',[0 t_line],'box','on','xgrid','off',...
            'drawmode','fast','xtick',[],...
            'xticklabel','','xtick',[],...
            'color','none','YaxisLocation','right','Ycolor','k');
        set(AX_HanL(ii,iii),'Ylim',[Ytk(1)-station.drumshift(iii) Ytk(end)+station.drumshift(iii)],'ytick',Ytk);

%     ax(1)=axes('xgrid','on','Position',[0 0 1 1],'Ycolor','k', 'FontName','Bitstream charter','Fontsize',10,'Fontweight','bold')
%     ax(2)=axes('Position',[0 0 1 1],  'FontName','Bitstream charter','Fontsize',10,'Fontweight','bold')
% set(ax(2),'xtick',[],'color','none','YaxisLocation','right','Ycolor','k')
        
        
        OLD_Han(ii,iii)=hggroup;
        for i=1:linee,
            icolor=h_now-i;
            if icolor<=0,
                icolor=icolor+96;
            end

            l_byte=t_line*station.smp(iii)/station.resampling(iii);
            a=line(0:l_byte-1,zeros(1,l_byte)+(i-1)*station.drumshift(iii),'color',Cday(icolor,:),...
                'tag',strcat('OLDtrace',char(namestz(ii)),char(station.chname(iii))),'linewidth',.1,...
                'Parent',OLD_Han(ii,iii));
        end

        Ytk=0:station.drumshift(iii):station.drumshift(iii)*(linee-1);
        set(AX_Han(ii,iii),'Ylim',[Ytk(1)-station.drumshift(iii) Ytk(end)+station.drumshift(iii)],...
            'ytick',Ytk);
        set(AX_HanL(ii,iii),'Ylim',[Ytk(1)-station.drumshift(iii) Ytk(end)+station.drumshift(iii)],...
            'ytick',Ytk);
       
        %... amplitude legend ...%
        string=['each divisions= ',char(station.legendvalue(iii)),' ',char(station.legend(iii))];
        LEG_Han(ii,iii)=text(t_line+10,100,'');
        set(LEG_Han(ii,iii),'fontsize',5,'rotation',90,'FontName','Bitstream charter',...
            'string',string,...
            'position',[920 station.drumshift(iii) 0])
    end 
    TIT_Han(ii)=hggroup;

    bbb=title('');
    set(bbb,'tag',['title',num2str(ii)],...
        'fontsize',7,...
        'Parent',TIT_Han(ii))
end



%%
HH=guihandles;
for ii=1:nstz,
%     eval(['run conf_',char(namestz(ii)),'.m'])
    station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(ii)),'.txt']);
    
    A=DATA.(strcat('OLDtrace',char(namestz(ii))));
    for iii=1:length(station.wschannels),
        LineH=HH.(strcat('OLDtrace',char(namestz(ii)),char(station.chname(iii))));
        %... OLD handles 24 traccia più vecchia
        %... OLD handles 1 traccia più recente
        for i=1:linee,        
            ixe=A(i,:,end);
            ipsilon=A(i,:,iii);
            ixe=(ixe-last6Htimes(i))*86400/station.resampling(iii);
            set(LineH(i),'xdata',ixe,'ydata',ipsilon+(i-1)*station.drumshift(iii))
        end
        Ytklb=datestr(last6Htimes,15);
        YtklbL=datestr(last6Htimes+station.localtimeutcoffset/24,15);
        set(AX_Han(ii,iii),'yticklabel',Ytklb)
        
        set(AX_HanL(ii,iii),'yticklabel',YtklbL)
        
    end
%     if station.localtimeutcoffset==0,
%         string=[station.network,' - Station: ',...
%             upper(station.name),' - ',...
%             'Date: ',...
%             datestr(A(1,end,end),0),...
%             ' UTC'];
%     else
%         string=[station.network,' - Station: ',...
%             upper(station.name),' - ',...
%             'Date: ',...
%             datestr(A(1,end,end),0),...
%             ' LT'];
%     end
    string=[station.network,' - IDA: ',...
        upper(station.name),' - ',...
        'SNR: ',...
        '1',' - ',...
        'Date: ',...
        datestr(ceil(A(1,end,end)*1440)/1440,'dd-mmm-yyyy HH:MM'),...
        ' UTC <--> ',...
        datestr(ceil(A(1,end,end)*1440)/1440+station.localtimeutcoffset/24,'dd-mmm-yyyy HH:MM'),...
        ' LT'];
    
%     string=['Copahue Seismo-Acoustic Network',' - Station: CPH - Channel: UD - Date: ',datestr(now,0),' UTC']
    set(HH.(['title',num2str(ii)]),'string',string)
 
end


% stzview='rp1';
ihview=1;
set(OLD_Han,'visible','off'),set(OLD_Han(ihview,1),'visible','on')
set(TIT_Han,'visible','off'),set(TIT_Han(ihview),'visible','on')
set(AX_Han,'visible','off'),set(AX_Han(ihview,1),'visible','on')
set(AX_HanL,'visible','off'),set(AX_HanL(ihview,1),'visible','on')
set(LEG_Han,'visible','off'),%set(LEG_Han(ihview,1),'visible','on')
set(AX_Han(1,1),'yticklabel',Ytklb)
set(HAN_Xlab,'visible','on')

fid = fopen([working_dir,slh,'log',slh,net,'.log'],'w');
fprintf(fid,net);
fclose(fid);



%%
tstart=floor(now*86400/60)/86400*60+1/1440+40/86400;
datestr(tstart)
while 1
    if now>tstart,
        tstart=floor(now*86400/60)/86400*60+1/1440+40/86400;
        ws_drumplot_run(tstart,net)
    end
    pause(2)
end
%     
return