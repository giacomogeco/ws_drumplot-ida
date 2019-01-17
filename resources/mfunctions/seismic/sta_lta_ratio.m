%% sta_lta_ratio (MCS)
% Questa funzione calcola il rapporto STA/LTA su una traccia (w)
% e fornisce un grafico del rapporto calcolato rispetto
% alle soglie scelte ed un grafico degli eventi trovati sulla traccia.
%
% richiede in ingresso:
% w= vettore traccia;
% t= vettore tempi;
% fs= frequenza di campionamento;
% l_sta= lunghezza della finestra sta [s];
% l_lta= lunghezza della finestra lta [s];
% th_on= soglia di trigger [1.5-5];
% th_off= soglia di detrigger [1];
%
% restituisce in uscita:
% ratio= rapporto sta/lta;
% n_events= numero eventi trovati;
% indE= indici posizioni degli eventi su w e t;
% tE= tempi degli eventi estratti da t;

function [ratio,n_events,indE,tE]=sta_lta_ratio(w,t,fs,l_sta,l_lta,th_on,th_off)

%parametri
l_sta=l_sta*fs;
l_lta=l_lta*fs;
lw=length(w);
wi=abs(w);

%sta
sta=ones(lw,1);
k=l_lta-l_sta+1;
kk=l_lta;
p=kk;
sum_sta=sum(wi(k:kk));
sta(p)=sum_sta/l_sta;

for k=l_lta-l_sta+2:lw-l_sta+1
    p=p+1;
    kk=kk+1;
    sum_sta=sum_sta-wi(k-1)+wi(kk);
    sta(p)=sum_sta/l_sta;
end

%lta
lta=ones(lw,1);
k=1;
kk=l_lta;
p=kk;
sum_lta=sum(wi(k:kk));
lta(p)=sum_lta/l_lta;

for k=2:lw-l_lta+1
    p=p+1;
    kk=kk+1;
    sum_lta=sum_lta-wi(k-1)+wi(kk);
    lta(p)=sum_lta/l_lta;
end

%ratio
ratio=sta./lta;

%eventi
j=0;
flag=0;
indE=[];
for i=1:lw;
    if ratio(i)>=th_on && flag==0
        flag=1;
        j=j+1;
        indE(j)=i; 
    end
    if ratio(i)<th_off && flag ==1
        %ratio(i)<th_on & flag ==1 
        %uncomment se vuoi che il trigger riparta appena scende rispetto
        %alla soglia
        flag=0;
        
    end
end
if isempty(indE)
    ratio=[];
    n_events=[];
    indE=[];
    tE=[];
    return
end

n_events=numel(indE);
tE=t(indE);

% %% plot(ratio sta/lta)
% figure 
% ax(1)=subplot(2,1,1); 
% plot(t,ratio,'k')
% hold on
% c=th_on*ones(1,lw);
% d=th_off*ones(1,lw);
% plot(t,c,'-r')
% plot(t,d,'-y')
% plot(t(indE),ratio(indE),'or')
% grid
% title('STA/LTA Ratio')
% ylabel('STA/LTA Ratio')
% xlabel('Time')
% legend('Ratio','threshold on','threshold off','Events')
% 
% % plot(traccia con eventi)
% ax(2)=subplot(2,1,2);
% plot(t,w,'k')
% hold on
% scatter(t(indE),w(indE),'or')
% grid
% title('EVENTS')
% xlabel('Time')
% ylabel('Amplitude')
% legend('Waveform','Events')
% linkaxes(ax,'x');

