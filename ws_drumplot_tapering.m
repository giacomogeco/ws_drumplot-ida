function sig=ws_drumplot_tapering(sig,N)

size(sig)
%>>> sig= vettore riga
sig=sig(:);
H=hanning(N);
nr=length(sig)-N;
H=[H(1:end/2);ones(nr,1);H(end/2+1:end)];
sig=sig'.*H';
                    
                    
return