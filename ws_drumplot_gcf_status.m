% function [T,TMP,VLT]=gcf_read_textfile(stz,id,varargin)
% Read status text file from guralp digitizer
% stz = station name
% varargin:
%     (1) tstart = start time
%     (2) tend = end time
%     (3) tstep = step time
%     (4) pth = main path ending with slash 

% [T,TMP,VLT]=gcf_read_textfile('isl','c654',now,now-20,6/24,'/users/giacomo/Documents/islanda/dati');
% clear all
tstart=ceil(now)-2;
tend=ceil(now);
pth='/home/scream/data/';
tstep=12/24;
stz='prt';
id='a441';
%ws_drumplot_gcf_status
%os=computer;
%switch os
 %   case {'MACI','MACI64','GLNX86'}
        slh='/';
   % case {'PCWIN','PCWIN64'}
    %    slh='\';
    %otherwise
     %   slh='\';
%end

% if nargin==2,
%     [files,pth]=uigetfile('*.txt','Select text file','MultiSelect','on');
% else
%     if nargin<6
%         fprintf('imputs arguments must be 1 or 5')
%     else
%         disp('pippo')
%         tstart=varargin{1};
%         tend=varargin{2};
%         tstep=varargin{3};
%         pth=varargin{4};
        tfiles=tstart:tstep:tend;
%         isl_20100507_0000c65400.txt
        filestring=datestr(tfiles,'yyyymmdd_HHMM');
        folderY=datestr(tfiles,'yyyy');
        folderD=datestr(tfiles,'yyyymmdd');
        files=cellstr(strcat(pth,stz,slh,folderY,slh,stz,'_',folderD,slh,...
            stz,'_',filestring,id,'00.txt'))

%     end
% end

%   prt_20161217_0000a44100.txt

nfile=length(files);
VLT=[];TMP=[];T=[];

for ii=1:nfile
    disp(strcat(char(files(ii))))
    fid=fopen(char(files(ii)));
    if fid==-1
        continue
    end
    data=fread(fid,'int8');
    fclose(fid);

    jcr=[1;find(data==13)];

    nrows=length(jcr);

    str1='External supply :';nstr1=length(str1);
    str2='Temperature';nstr2=length(str2);
    k=0;
    time=[];volt=[];temp=[];
    for i=1:nrows-1,

        string=char(data(jcr(i):jcr(i+1)-1));
        jvo=findstr(str1,string');

        if ~isempty(jvo)
            k=k+1;
            %% TIME
            stringtime=string(2:jvo-1);
            jsp=find(isspace(stringtime)==1);
            ii=find(diff(jsp)==1)+1;

            stringtime(jsp(ii))='0';
            jsp(ii)='';
            stringtime(jsp)='';

            if ~isempty(stringtime)
                time(k)=datenum(stringtime','yyyymmddHH:MM:SS');

                %% VOLTAGE
                string=string(jvo+nstr1:end);
                jV=findstr('V',string');
                jS=isspace(string);jS=find(jS==1);jS=jS(1);

                volt(k)=str2double(string(jS+1:jV-1)');

                %% TEMPERATURE
                string=string(jV+1:end);
                jC=findstr(str2,string');
                string=string(jC+nstr2:end);
                string=string(isspace(string)==0)';
                jL=findstr('C',string);
                temp(k)=str2double(string(1:jL-2));
            else
                continue
            end
        end
    end
    T=cat(2,T,time);
    TMP=cat(2,TMP,temp);
    VLT=cat(2,VLT,volt);
end

%%

[T,ic]=sort(T);
TMP=TMP(ic);
VLT=VLT(ic);

i=T>0;
T=T(i);TMP=TMP(i);VLT=VLT(i);

figure

ax(1)=subplot(211);
plot(T,TMP,'r');grid on,ylabel('Temperature (°C)')

ax(2)=subplot(212);
plot(T,VLT,'b');grid on,ylabel('Voltage')

linkaxes(ax,'x')




