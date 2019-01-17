function D=ws_drumplot_FromdB(to,tend)

% to=datenum(2014,8,11,7,24,30);
% tend=datenum(2014,8,11,7,25,30);
to=datestr(to,31);tend=datestr(tend,31);

%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'structure');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');


%Make connection to database.  Note that the password has been omitted.
%Using JDBC driver.
psw='wave*worm';
conn = database('etna_locations', 'labgeofisica', psw,...
    'Vendor', 'MYSQL', 'Server', 'localhost', 'PortNumber', 3306);

%Read data from database.
% curs = exec(conn, ['SELECT 	locations.pressure'...
%     ' ,	locations.Lon'...
%     ' ,	locations.Lat'...
%     ' ,	locations.elevation'...
%     ' ,	locations.coherence'...
%     ' ,	locations.time'...
%     ' FROM 	etna_locations.locations '...
%     ' WHERE 	locations.time > "2014-08-11 07:24:10"'...
%     ' AND 	locations.time < "2014-08-11 07:25:10"']);

curs = exec(conn, ['SELECT 	locations.pressure'...
    ' ,	locations.Lon'...
    ' ,	locations.Lat'...
    ' ,	locations.elevation'...
    ' ,	locations.coherence'...
    ' ,	locations.time'...
    ' FROM 	etna_locations.locations '...
    ' WHERE 	locations.time > "',to,'"'...
    ' AND 	locations.time < "',tend,'"']);

% curs = exec(conn, ['DELETE FROM etna_locations.locations ']);

curs = fetch(curs);
close(curs);

%Assign data to output variable
D = curs.Data;

%Close database connection.
close(conn);

%Clear variables
clear curs conn



return





psw='urAhA35PrMwvC2hp';
conn = database('etna_locations','labgeofisica',psw,'Vendor','MySQL',...
          'Server','127.0.0.1');

tablename=strcat('locations');
fprintf(strcat('Database Table:\t',tablename,'\n'))
colnames={'time';'pressure';'Lon';'Lat';'elevation';'coherence'};


% query = ("SELECT first_name, last_name, hire_date FROM employees "
%      "WHERE hire_date BETWEEN %s AND %s")

query=['select from ',tablename,' ','where time between ','"',to,'"',' and ','"',tend,'"']


curs = exec(conn, query)

curss = fetch(curs, 3)
close(conn)

return

close(conn)

fprintf(strcat('...... ',' RECORDS UPDATED ON DATABASE\t-\t',datestr(now,0),'\r'))

return