function ws_drumplot_run(tstart,net)

global nstz namestz linee Cday
global last15time 
global working_dir slh
global OLD_Han TIT_Han AX_Han AX_HanL LEG_Han HAN_Xlab
global rez


fid = fopen([working_dir,slh,'log',slh,net,'.log'],'w');
fprintf(fid,net);
fclose(fid);


% disp(strcat('------------------> START TIME','-',datestr(t_start)))
HH=guihandles;
for istz=1:nstz,
    
    
    station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(istz)),'.txt']);
    
    t_start=tstart-station.offset/1440;
    
    disp('')
    disp(['... ',upper(char(namestz(istz))),' DRUMPLOT'])
    
    to=last15time;
    tend=floor(t_start*1440)/1440;
    
    try
%         data=ws_drumplot_read_data(namestz(istz),net,...
%         to,tend,...
%         station.filter(:,1),station.filter(:,2));
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
    catch
        disp(['... WARNING ',upper(char(namestz(istz))),' error reading data'])
        continue
    end
    
    if isempty(data)
        smpempty=1;
        tteo=to:(1/smpempty)/86400:tend;
        MD=NaN*zeros(length(station.wschannels)+1,length(tteo));
        
%         ws_drumplot_TodB(D,dB,usr,psw,server,tablename,colnames)

        MD(length(station.wschannels)+1,:)=tteo;
    else
        MD=zeros(length(station.wschannels)+1,length(data.tt));
        for ich=1:length(station.wschannels)+1
            if ich==length(station.wschannels)+1
                MD(ich,:)=data.tt;
            else
                MD(ich,:)=data.(char(station.wschannels(ich)));
            end
        end
%         D.txrate=length(MD(1,:))/(station.smp*60)
%         ws_drumplot_TodB(D,dB,usr,psw,server,tablename,colnames)
    end
    DAT(1:size(MD,2),:)=MD';
     
    DATA.(strcat('RTtrace',char(namestz(istz))))=DAT;
    
    clear MD DAT
 end
clear data

%... checking change of the lines
t1=last15time+15/1440;
if t_start>t1,
    disp('<<<<<<<<<<<< Scrolling lines >>>>>>>>>>>>>>')
    for i=1:nstz,
%         set(AX_Han,'visible','off'),set(AX_Han(i),'visible','on')
        %... filling the new data for each station
%         eval(['run conf_',char(namestz(i)),'.m'])

        station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(i)),'.txt']);
        stzdata=DATA.(strcat('RTtrace',char(namestz(i))));
        tempo=(stzdata(:,end)-last15time)*86400;
        
        if station.writematfile==1,
            flag=ws_drumplot_matfile(station,stzdata(1,end),working_dir,slh,net);
            if flag==0
                disp('Error saving .mat file')
            end  
        end
        
        if station.writestatus,
            disp('Status Data on dB') 
            try
            ws_drumplot_status2dB(last15time,station);
            catch
                disp('!!! Error Status Data on dB') 
            end
        end
        
        if station.writenoise,
            disp('Infrasonic Noise Level Computation') 
            try
                ws_drumplot_inl2dB(last15time,station);
            catch
                disp('!!! Error Status Data on dB') 
            end
        end
        
        if isempty(tempo),
            continue
        end
        
              
        for ii=1:length(station.wschannels),
            %... and for each channels
            Htmp= HH.(strcat('OLDtrace',char(namestz(i)),char(station.chname(ii))));
            Htmp=Htmp(1);   %... only the most recent line
            
            y15=stzdata(:,ii);
            set(Htmp,'xdata',tempo,'ydata',y15)
        
             %... updating ylabel
            
            lbl=datestr(last15time-6/24+15/1440:15/1440:last15time,15);
            lblL=datestr(last15time+station.localtimeutcoffset/24-6/24+15/1440:15/1440:last15time+station.localtimeutcoffset/24,15);
            set(AX_Han(i,ii),'yticklabel',lbl(end:-1:1,:))
            set(AX_HanL(i,ii),'yticklabel',lblL(end:-1:1,:))
            set(HAN_Xlab,'visible','on')
            
            set(OLD_Han,'visible','off'),set(OLD_Han(i,ii),'visible','on')
            set(AX_Han,'visible','off'),set(AX_Han(i,ii),'visible','on')
            set(AX_HanL,'visible','off'),set(AX_HanL(i,ii),'visible','on')
            set(LEG_Han,'visible','off'),%set(LEG_Han(i,ii),'visible','on')
            
            pngfilename=strcat(station.figuresdir,slh,...
            upper(char(namestz(i))),'_RealTime',num2str(ii),'.png');
          

                string=[station.network,' - IDA: ',...
                    upper(station.name),' - ',...
                    'SNR: ',...
                    upper(char(station.chname(ii))),' - ',...
                    'Date: ',...
                    datestr(ceil(stzdata(end,end)*1440)/1440,'dd-mmm-yyyy HH:MM'),...
                    ' UT <-->',...
                    datestr(ceil(stzdata(end,end)*1440)/1440+station.localtimeutcoffset/24,'dd-mmm-yyyy HH:MM'),...
                    ' LT'];
%             end

                
            
            set(HH.(['title',num2str(i)]),'string',string)
            set(TIT_Han,'visible','off'),set(TIT_Han(i),'visible','on')
            
            print(gcf,pngfilename,'-dpng',['-r',num2str(rez)])
            
            %... cheking for 6 hours hystorical drumplot figure (before scrollimg)
            if sum(strcmp(datestr(t_start,'HHMM'),{'1200';'0000';'0600';'1800'}))~=0                
                disp(['... printing 6h drumplot hystorical ',char(namestz(i)),' drumplot figure'])
                label=floor(4*(t_start-floor(t_start)));    %... 0 1 2 3
                if label==0,label=4;end

                %... controllo directory giornaliera
                foldername=strcat(station.figuresdir,slh,...
                datestr(last15time,'yyyymmdd'),slh);
                if exist(foldername,'dir'),else mkdir(foldername);end
                filename6=strcat(upper(char(namestz(i))),'_',datestr(last15time,30),'_',...
                    num2str(label),'_',num2str(ii),'.png');
                
                filename6(13:19)='';
                filename6=strcat(foldername,filename6);
                
                set(HAN_Xlab,'visible','on')
                
                print(gcf,filename6,'-dpng',['-r',num2str(rez)])
                
            end
        end
    end     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    last15time=ceil(last15time*86400)/86400+15/1440;
    
    lbl=datestr(last15time-6/24+15/1440:15/1440:last15time,15);
    lblL=datestr(last15time+station.localtimeutcoffset/24-6/24+15/1440:15/1440:last15time+station.localtimeutcoffset/24,15);
%     lbl=datestr(last15time-6/24+15/1440:15/1440:last15time,15);
%     lblL=datestr(last15time+station.localtimeutcoffset/24-5/24+15/1440:15/1440:last15time+station.localtimeutcoffset/24,15);
    h_now=1+floor((t_start-floor(t_start))*1440/15);%...  color
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    %... scrolling traces
    for i=1:nstz,
%         eval(['run conf_',char(namestz(i)),'.m'])
        station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(i)),'.txt']);
        
        for ii=1:length(station.wschannels),
            %... shifto gli old in su
            Htmp=HH.(strcat('OLDtrace',char(namestz(i)),char(station.chname(ii))));          
            for iii=linee:-1:2,
                y_old=get(Htmp(iii-1),'ydata');
                x_old=get(Htmp(iii-1),'xdata');
                c_old=get(Htmp(iii-1),'color');
                set(Htmp(iii),'xdata',x_old,'ydata',y_old+station.drumshift(ii),'color',c_old)
            end
            set(Htmp(1),'xdata',0,'ydata',0,'color',Cday(h_now,:))
        end
        %... updating ylabel
        set(AX_Han(i,ii),'yticklabel',lbl(end:-1:1,:))
        set(AX_HanL(i,ii),'yticklabel',lblL(end:-1:1,:))
    end
    
%     YtklbL=datestr(last6Htimes+station.localtimeutcoffset/24,15);
%         set(AX_Han(ii,iii),'yticklabel',Ytklb)
%         
%         set(AX_HanL(ii,iii),'yticklabel',YtklbL)
    
else
    
    
    
    disp('<<<<<<<<<<<< Updating Last Minute Data >>>>>>>>>>>>>>')
     for i=1:nstz,
        %... filling the new data for each station
%         eval(['run conf_',char(namestz(i)),'.m'])
        station=ws_read_ascii2cell([working_dir,slh,'conf_files',slh,net,slh,'conf_',char(namestz(i)),'.txt']);
        
        stzdata=DATA.(strcat('RTtrace',char(namestz(i))));
        tempo=(stzdata(:,end)-last15time)*86400;
        if isempty(tempo),
            continue
        end
        
%         string=[station.network,' - Station: ',...
%             upper(station.name),' - ',...
%             'Date: ',...
%             datestr(stzdata(end,end),0),...
%             ' UTC'];
%         set(HH.(['title',num2str(i)]),'string',string)
%         set(TIT_Han,'visible','off'),set(TIT_Han(i),'visible','on')
        
             
        for ii=1:length(station.wschannels),
            %... and for each channels
            Htmp= HH.(strcat('OLDtrace',char(namestz(i)),char(station.chname(ii))));
            Htmp=Htmp(1);
            
            y15=stzdata(:,ii);
            set(Htmp,'xdata',tempo,'ydata',y15)

            
            
            pngfilename=strcat(station.figuresdir,slh,...
            upper(char(namestz(i))),'_RealTime',num2str(ii),'.png');
            
            %... updating ylabel
            lbl=datestr(last15time-6/24+15/1440:15/1440:last15time,15);
            lblL=datestr(last15time+station.localtimeutcoffset/24-6/24+15/1440:15/1440:last15time+station.localtimeutcoffset/24,15);
            set(AX_Han(i,ii),'yticklabel',lbl(end:-1:1,:))
            set(AX_HanL(i,ii),'yticklabel',lblL(end:-1:1,:))
            set(HAN_Xlab,'visible','on')
            
            set(OLD_Han,'visible','off'),set(OLD_Han(i,ii),'visible','on')
            set(AX_Han,'visible','off'),set(AX_Han(i,ii),'visible','on')
            set(AX_HanL,'visible','off'),set(AX_HanL(i,ii),'visible','on')
            set(LEG_Han,'visible','off'),%set(LEG_Han(i,ii),'visible','on')
            
%             string=[station.network,' - Station: ',...
%                 upper(station.name),' - ',...
%                 'Channel: ',...
%                 upper(char(station.chname(ii))),' - ',...
%                 'Date: ',...
%                 datestr(stzdata(end,end),0),...
%                 ' UTC'];
            
            string=[station.network,' - IDA: ',...
                    upper(station.name),' - ',...
                    'SNR: ',...
                    upper(char(station.chname(ii))),' - ',...
                    'Date: ',...
                    datestr(ceil(stzdata(end,end)*1440)/1440,'dd-mmm-yyyy HH:MM'),...
                    ' UT <-->',...
                    datestr(ceil(stzdata(end,end)*1440)/1440+station.localtimeutcoffset/24,'dd-mmm-yyyy HH:MM'),...
                    ' LT'];
            
            set(HH.(['title',num2str(i)]),'string',string)
            set(TIT_Han,'visible','off'),set(TIT_Han(i),'visible','on')
            
            print(gcf,pngfilename,'-dpng',['-r',num2str(rez)])
        end
     end
end

set(OLD_Han,'visible','off'),set(OLD_Han(1,1),'visible','on')
set(TIT_Han,'visible','off'),set(TIT_Han(1),'visible','on')
set(AX_Han,'visible','off'),set(AX_Han(1,1),'visible','on')
set(AX_HanL,'visible','off'),set(AX_HanL(1,1),'visible','on')


save([working_dir,slh,'ws_drumplot_logfile.txt'],'istz')
disp(['-------------------> END TIME','-',datestr(now)])
% toc
return