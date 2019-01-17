function ws_noise2dB_insert(EF,station)
% date=num2str('2013-11-19 09:30:11');
tablename=station.dB_noise_tablename;

% sudo ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib
mysql('open', station.dBhost, station.dBuser, station.dBpassword );
mysql('use',station.dB_noise_name)  
mysql('status')

disp(tablename)
% 
% [ t, p ] = mysql('select T,Date from isc_avalanches where date="2012-12-10 07:41:40"');
% return
% var_name = input('Enter the name: ','s');  %# Treats input like a string
% commandString = sprintf('insert into table (name) values (''%s'')', var_name);
%                             %# Note the two apostrophes --^
% mysql(commandString);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% query=['delete from ',stz,'_avalanches where Date > (''',date,''') '];
% commandString = sprintf('insert into table (name) values (''%s'')', var_name);
% tablename='prova';
% colnames='prova';
% commandString = sprintf('insert into table (prova) values (''%s'')', num2str(120))
% mysql(query)
% query = sprintf(['insert into table ',tablename, 'values (''%s'')', var_name]);
% mysql('close')
% return
% Mpriv=cat(1,now,100,50,0.7,0,0,0,0,0,0,0,0,0);
% torretta={'ciao'};
% query=['insert into gms_explosions values (''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'')'];

% length(EF.time)
for i=1:length(EF.time)
     
     query=['replace into ',tablename,' values (''%s'',''%s'',''%s'',''%s'',''%s'',''%s'')'];
     mysql(sprintf(query,...
     datestr(EF.time(i),31),...
     num2str(EF.ch1(i)),...
     num2str(EF.ch2(i)),...
     num2str(EF.ch3(i)),...
     num2str(EF.ch4(i)),...
     num2str(EF.ch5(i))));    %... 13
end
% disp(query)
mysql('closeall')

return
