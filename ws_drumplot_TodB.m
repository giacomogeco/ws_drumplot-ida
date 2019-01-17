function ws_drumplot_TodB(D,dB,usr,psw,server,tablename,colnames)

% psw='urAhA35PrMwvC2hp';
% psw='wave*worm';
conn = database(dB,usr,psw,'Vendor','MySQL',...
          'Server',server);

% tablename=strcat('locations');
% fprintf(strcat('Database Table:\t',tablename,'\n'))
% colnames={'time';'pressure';'Lon';'Lat';'elevation';'coherence'};

nev=length(D.time);
% disp(fprintf(strcat('UPLOADING\t',num2str(nev),'\tRECORDS\r')))

exdata=cell(nev,length(colnames));
for i=1:nev,
%     [Lat,Lon] = utm2deg(D.xo(i),D.yo(i),'33 S');
   
    exdata(i,:)={
        datestr(D.time(i),31)...  %... tempo Database (stringa)
        D.magnitude(i) ....  %... pressure (mPa)
        D.duration(i) ...
        char(D.zona(i)) ... %... coerenza media (0-1)
        D.dt(i) ... %... back-azimuth medio (�N)
        D.distance(i) ...
        D.azimuth(i) ...
        D.dip(i)};  %... frequenza di picco della fase ad ampiezza massima (Hz)
end

fastinsert(conn,tablename, colnames, exdata);
close(conn);

% fprintf(strcat('...... ',' RECORDS UPDATED ON DATABASE\t-\t',datestr(now,0),'\r'))

return