%% onsetP (MCS)
% Questa funzione cerca gli onset P sugli eventi
% selezionati dalla funzione sta_lta_ratio (indE).
% Crea un grafico:
% 1)cumulata sull'intera traccia
% 2)differenze di pendenze sulla cumulata
% 3)onset P sulla traccia
% 
% richiede in ingresso:
% w= vettore traccia;
% t= vettore tempi [s];
% fs= frequenza di campionamento;
% indE= indice eventi da sta_lta_ratio;
% it= intervallo di tempo [s] prima dell'evento trovato da sta_lta_ratio;
% s= soglia [0.05](stabilita sulle differenze di pendenze della cumulata);
%
% restituisce in uscita:
% tP= vettore tempi [s] onset P;
% indtP= indici onset P
% DM= differenza delle pendenze della cumulata della traccia

function [tP,indtP,DM]=onsetP(w,t,fs,indE,it,s)

%% modifica per soglia minore
%s2=0.23; % per P
s2=0.1; % per S

% indici ritaglio traccia da elaborare
J=indE-(it*fs); %it secondi prima
JJ=indE+15*fs;  %15 secondi dopo 
n=length(J);
%preallocazioni
indtP=zeros(n,1);
DM=zeros(size(t));

%% cumulate parziali su selezioni traccia
for i=1:n
    Sw=w(J(i):JJ(i)); % selezione su traccia
    St=t(J(i):JJ(i)); % selezione su tempi
    Cp=cumsum(abs(Sw)); % cumulata parziale
    lp=length(Cp);
    
    % divisione in polinomi della cumulata
    for a=1:lp-1
        if((lp/a)==fix(lp/a))
            div(a)=a;
        end
    end
 
    ind=find(div);
    div=div(ind);
    div=div';
    d=max(div);
    int=lp/d;

    for j=1:int:lp
        p=polyfit(St(j:j+int-1),Cp(j:j+int-1),1);
        %y=polyval(p,St(j:j+int-1));
        P(j:j+int-1,:)=repmat(p,int,1); 
        warning off
    end
 
% analisi pendenze
m=P(:,1); 
md=m./max(m);
md=detrend(md);
dist=diff(md);
TD=St(1:end-1);
DM(J(i):JJ(i)-1)=dist;

% ricerca onset P
[~,locs]=findpeaks(abs(dist),'minpeakheight',s,'npeaks',1);
    if isempty(locs)==0 %se trova picchi
        indtP(i)=find(t==(TD(locs)));
    elseif isempty(locs)==1 % se non trova picchi
        [~,locs]=findpeaks(abs(dist),'minpeakheight',s2,'npeaks',1);
        indtP(i)=find(t==(TD(locs)));  
    end

end 

%% onsetP 
tP=t(indtP);
tE=t(indE);

% %% plot finale
% C=cumsum(abs(w));
% 
% figure
% ax(1)= subplot(3,1,1); % cumulata con onset
% plot(t,C,'k')
% hold on
% plot(t(indtP),C(indtP),'or')
% ylabel('cumsum')
% title('RICERCA ONSET')
% 
% ax(2)= subplot(3,1,2); % differenze di pendenza con onset
% plot(t,DM,'k')
% hold on
% plot(t(indtP),DM(indtP),'or')
% plot(t(indE),DM(indE),'ob')
% th=s*ones(size(t'));
% plot(t,th,'-r')
% ylabel('diff(pendenze)')
% 
% ax(3)= subplot(3,1,3); % traccia con onset
% plot(t,w,'k')
% hold on
% plot(t(indtP),w(indtP),'or')
% ylabel('traccia')
% linkaxes(ax,'x');


