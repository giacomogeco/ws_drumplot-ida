function trf_local_magnitude(wZ,wN,wE,tt)

%% read_guralp (inserire il percorso esatto)
% [data]=read_guralp;
% eval(cmd)

%% parametri iniziali
fs=50; %frequenza di campionamento
% wZ=ud; %componente verticale UD
% wN=ns; %componente orizzontale NS
% wE=ew; %componente orizzontale EW
% tt=t1; %tempi da Guralp

th_on=3.7; %threshold sta/lta (2.5-5)
l_sta=2;
l_lta=20;
th_p=0.3;  %threshold onset P (0.01-0.3)
th_s=0.3;  %threshold onset S (0.15-0.4)
Vp=5;      %velocit� onde P assegnata [Km/s] (3.5-6)

%% vettore_tempi e rimozione NaN
t=(1/fs)*(0:length(wZ)-1);
w=wZ+wN+wE;
i=find(isnan(w)==0);
wZ=wZ(i);
wN=wN(i);
wE=wE(i);
tt=tt(i);
t=t(i);
tZ=t;
tE=t;
tN=t;

%% filtrax (per fs=50HZ)
wZ=filtrax(wZ,0.8,20,fs); 
wN=filtrax(wN,0.8,20,fs);
wE=filtrax(wE,0.8,20,fs);

%% sta_lta_ratio (solo sulla componente ud)
[ratioZ,n_events,indeZ,teZ]=sta_lta_ratio(wZ,tZ,fs,l_sta,l_lta,th_on,1);
if isempty(indeZ)
    disp('no events in the last 5 minutes')
    return
end
%% onset P ed S
% onset P su Z (a partire da sta/lta)
itP=2; % it=10 per magnitudo>2; % it=2 per magnitudo<2;
[tP,indtP,mP]=onsetP(wZ,tZ,fs,indeZ,itP,th_p); 
onsetPZ=datestr(tt(indtP))

% onset S su E (a partire da tP)
itS=1; % it=2 per magnitudo>2; % it=1 per magnitud<2;
[tS,indtS,mS]=onsetP(wE,tE,fs,indtP,itS,th_s);
onsetSE=datestr(tt(indtS));

%% distanza_epicentrale (in realt� ipocentrale)
tPS=tS-tP;
distance=tPS*(Vp/0.7321);

%% local_magnitude
l=0;
Tsp=zeros(size(indtP));
Ml=zeros(size(indtP));

% indici di ritaglio eventi dalla traccia intorno a tP
for i=1:length(indtP) 
    i0=indtP(i)-2*fs; %2 secondi prima
    iend=indtP(i)+30*fs; %30 secondi dopo
    %evita di uscire dalla traccia, quindi non prende eventi sui bordi
    if i0>1 && iend<length(wZ) 
        l=l+1;
        i1(l)=i0;
        i2(l)=iend;
        Tsp(l)=tPS(i);
    end
end

for i=1:l % per ogni evento seleziona le tracce e calcola magnitudo
    uu=wZ(i1(i):i2(i));
    nn=wN(i1(i):i2(i));
    ee=wE(i1(i):i2(i));
    tau=30; %periodo proprio (s) dello sismometro usato
    h=0.707; %smorzamento del sismometro usato
    [Ml(i)]=local_magnitude_trf(uu,nn,ee,fs,tau,h,distance(i));
    
end

%% azimuth da ruotacomp
AZ=zeros(length(indtP),1);

% ritaglio tracce fra tP e tS senza prendere tS (-25 campioni)
for i=1:length(indtP)
    Z=wZ(indtP(i):indtS(i)-25); 
    N=wN(indtP(i):indtS(i)-25);
    E=wE(indtP(i):indtS(i)-25);
    
% ruotacomp e ricerca azimuth  
    for j=1:360
        [R,T] = ruotacomp (E,N,j);
        EE(j)=sum(abs(R));
    end

    [a,b]=find(EE==max(EE)); % incertezza di +/-180 gradi
    AZ(i)=max(b);
end

%% risultati (onset P, tP-tS, distanza epicentrale, magnitudo, azimuth)
R=[tPS' distance' Ml AZ]; 

iE=find(tPS>2);
onP=datestr(tt(indtP(iE)))
TP=tP(iE)
TS=tS(iE)
tPS_Distance_Ml_AZ=[tPS(iE)' distance(iE)' Ml(iE) AZ(iE)]

%% POPOLO dB
D.time=tt(indtP(iE));
D.magnitude=Ml(iE);
D.duration=zeros(size(TP));
zon={'XXX'};
D.zona=repmat(zon,[1 length(TP)]);
D.dt=tPS(iE);
D.distance=distance(iE);
D.azimuth= AZ(iE);
D.dip=zeros(size(TP));

ws_drumplot_TodB(D,'rete_sismica','devnet',...
    'nurserycrime',...
    '150.217.73.94',...
    'TRF',...
    {'time';'magnitude';'duration';'zona';'dt';'distance';'azimuth';'dip'})
% colnames={'time';'pressure';'Lon';'Lat';'elevation';'coherence'};
return
