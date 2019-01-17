function [Ml]=local_magnitude_trf(ud,ns,ew,sps,tau,h,De)

%========================================================================
% [Ml,De]=local_magnitude(ud,ns,ew,sps,tau,h,De,tsp);
%   modificata per trf il 29/04/2015
%
% si calcola la magnitudo locale di un terremoto in base all'ampiezza
% dello spostamento dopo la simulazione di un Wood-Anderson. tau e h
% corrispondono al periodo proprio (tau) e allo smorzamento (h) del 
% sismometro utilizzato e sono necessari per la correzione dello strumento 
% e la simulazione del Wood-Anderson. De e tsp corrispondono alla distanza
% epicentrale e al tempo ts-tp. 
%========================================================================

%...correggo per la funzione di trasferimento e simulo un Wood-Anderson
 ud=transfer_restore(ud,tau,h,sps);
 ns=transfer_restore(ns,tau,h,sps);
 ew=transfer_restore(ew,tau,h,sps);

%...integro il segnale e filtro nella banda 0.8-20
[ud,ns,ew]=displacement(ud,ns,ew,sps,0.8,20);

%...calcolo il valore di ampiezza massima di spostamento
A=[max(abs(ud)), max(abs(ns)), max(abs(ew))];
Amax=max(A);
Amax=Amax*2800*1000;

%....calcolo della magnitudo: caso 1
P=[0.000000001113514, -0.000100818183719, -0.073938401558681];
    if De>35
        Dx=1/De; 
        yy=0.843-107.115*Dx+13713.485*Dx^2-983029.901*Dx^3+40318623.71*Dx^4-9.492e8*Dx^5+1.194e10*Dx^6-6.291e10*Dx^7;
        A=-10^yy;
    end
    if De<=35
        A=P(1)*(De*1000)^2+P(2)*(De*1000)+P(3);
    end

Ar=10^(A);
Ml=log10(Amax/Ar);

return