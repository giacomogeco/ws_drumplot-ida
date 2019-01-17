% function view_winston_data()
tic
stz='PZZ';
channels={'Z','N','E','X'};
network='STR';
% ip='192.168.5.88';
ip='193.206.127.24';
port=16088;
location='00';

to=datenum(2014,09,17,22,0,0);
tend=datenum(2014,09,17,22,15,0);

[data,w]=get_winston_data(stz,channels,network,to,tend,ip,port,location);
toc
%%
smp=100;
tims=(0:length(data.tt)-1)/smp;
fname=fieldnames(data);
H1=figure;

K=(27./((2^24)/2))/800;

[data.ZD,data.ND,data.ED]=displacement(data.Z,data.N,data.E,smp,0.03,1); %da usarsi normalmente per i VLP

for i=1:length(channels),
    
    ax(i)=subplot(length(channels),1,i);
    if i==2,
        plot(tims,K*data.ZD,'k')
    else
        plot(tims,K*filtrax(data.(char(fname(i+1))),.01,40,smp),'k')
    end
    grid on
end
linkaxes(ax,'x')


zobj=zoom;   
set(zobj,'ActionPostCallback',{@setcurrLIM,data.tt(1),ax,H1});
set(zobj,'Enable','on');


%%
% [a,b]=ginput(2)
j=tims>a(1) & tims<a(2);
ep=data.E(j);ep=filtrax(ep,1,30,smp);
np=data.N(j);np=filtrax(np,1,30,smp);
zp=data.Z(j);zp=filtrax(zp,1,30,smp);
timp=tims(j);

figure(2)
clf
ax(1)=subplot(121);plot(timp,ep,'k');grid on,axis square,hold on

ax(2)=subplot(122);plot(ep,np,'b'),grid on,axis square
hold on
for i=1:length(ep),
    
    plot(ax(1),timp(i),ep(i),'.r')
    plot(ax(2),ep(i),np(i),'.r')
    pause
end

%%
AZ=290;
[rp,tp] = ruotacomp (ep,np,AZ);

figure(5)
clf
ax(1)=subplot(121);plot(timp,ep,'k');grid on,axis square,hold on

ax(2)=subplot(122);plot(rp,zp,'b'),grid on,axis square
hold on
for i=1:length(ep),
    
    plot(ax(1),timp(i),ep(i),'.r')
    plot(ax(2),rp(i),zp(i),'.r')
    pause
end
    