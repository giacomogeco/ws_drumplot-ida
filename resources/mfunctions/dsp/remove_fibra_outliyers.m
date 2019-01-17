function out=remove_fibra_outliyers(in)

m3=(in*5/2^16)/.2;
m3=ceil(5*m3/.002);
% m3bin=de2bi(m3);
% length(m3)
m3bins=NaN*zeros(length(m3),16);
for i=1:length(m3)
    if isnan(m3(i)) 
    else
        a=dec2bin(m3(i));
        a=str2num(a');a=a';
        m3bins(i,:)=a(end:-1:1);
    end
end

m3bins(:,14)=0;

m3buonos=NaN*zeros(size(m3));
for i=1:length(m3)
    if isnan(m3(i))
    else
        a=num2str(m3bins(i,:));
        m3buonos(i)=bin2dec(a(end:-1:1));
    end
end

dataw.m3=m3buonos;
% smp=100;
out=spike_remove_hampel(dataw,50);
out=out.m3*.002/5;
out=(out*2^16/5)*.2;

return