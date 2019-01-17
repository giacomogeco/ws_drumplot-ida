function setcurrLIM(h,ev,t,ax,HH) 

axon=get(HH,'currentaxes');
xlim=get(axon,'xlim');

step=round(diff(xlim)/10);

xt=xlim(1):step:xlim(2);

for i=1:length(ax)
    set(ax(i),'xtick',xt,'xticklabel','')
    
    if i==length(ax),
        if xt(end)-xt(1)<86400
            set(ax(i),'xtick',xt,'xticklabel',datestr(t(1)+xt/86400,13))
        else
            set(ax(i),'xtick',xt,'xticklabel',datestr(t(1)+xt/86400,6))
        end
    end
end


return