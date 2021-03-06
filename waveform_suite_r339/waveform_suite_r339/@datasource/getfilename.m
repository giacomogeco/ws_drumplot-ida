function [filename] = getfilename(ds, scnls, starttimes)
%GETFILENAME returns a filename that is associated with a single SCNL
%  filename= getfilename(ds, scnlobject, starttime)
%    where:
%    DS is the datasource object
%    SCNLOBJECT is a scnlobject with station/channel/network/location
%    information.
%    STARTTIME is a matlab formatted time, or a string
%
% getfile is capable of traversing directory trees.
%
% [filename] = getfilename(ds, [],[],[]) will return a sample-string.
% ex.
%  >> ds = datasource('file','myfiles/%04d/%02d/thisfile%04d_%s%s.dat',...
%      'year', 'month','day','station','channel');
%  >> getfile(ds,[],[])
%  ans =
%     myfiles/[YEAR]/[MONTH]/thisfile[DAY]_[STATION][CHANNEL].dat
%
%  >> getfilename(ds,scnlobject('OKCF','EHZ'),'12/31/2008 04:03:21')
%  ans =
%     myfiles/2008/12/thisfile0031_OKCFEHZ.dat
%
%
% see also SETFILENAME

% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2011-09-15 16:19:07 -0700 (Thu, 15 Sep 2011) $
% $Revision: 307 $

% Day numbers at start of each month.  Used within to calculate "jday".
monthadd = [ 0 31 59 90 120 151 181 212 243 273 304 334 ];

if ~ds.usefile
  warning('Datasource:noAssociatedFiles','No files have been associated with this datasource');
  filename = [];
  return
end

%
% if numel(scnl) > 1
%   warning('Datasource:multipleSCNL',...
%     'An array of SCNL was passed as the argument.  Only search for a single SCNL at a time');
% end
if isnumeric(starttimes) && ~isempty(starttimes)
    for n=1:numel(starttimes)
        st(n) = {starttimes(n)};        
    end
    starttimes = st;
    clear st
end
if ~iscell(starttimes)
    starttimes = {starttimes};
end
filename = cell(numel(scnls),numel(starttimes));

if isempty(filename) %show the generic file name
  %return a THEORETICAL filename
  year = '[YEAR]';
  jday ='[JDAY]';
  month ='[MONTH]';
  day ='[DAY]';
  hour ='[HOUR]';
  minute ='[MINUTE]';
  second ='[SECOND]';
  station = '[STATION]';
  channel = '[CHANNEL]';
  location = '[LOCATION]';
  network = '[NETWORK]';
  stringToShow = regexprep(ds.file_string,'(%|%0)(\d|)d','%s');
  % build the file arg string
  if isempty(ds.file_args)
    filename = {stringToShow};
  else
	z = cellfun(@eval,ds.file_args,'UniformOutput',false);
	filename = {sprintf(stringToShow,z{:})};
  end
else %get detailed file.for n=1:numel(scnls)
	
  for n=1:numel(scnls)
    scnl = scnls(n);
	station = get(scnl,'station');
	channel = get(scnl,'channel');
	location = get(scnl,'location');
	network = get(scnl,'network');

    for m = 1:numel(starttimes)
	  starttime = starttimes{m};


      %pull all the data that may be required to parse out files & directories
	  
	  % If we have a datenum, use the fast built-in version of datevec
      if isnumeric(starttime)
		  [year, month, day, hour, minute, second] = datevecmx(starttime);
	  else
		  [year, month, day, hour, minute, second] = datevec(starttime);
	  end
	  
      second = round(second);
      
      % The following few IF statements handle possible rounding issues
      if second == 60
         second = 0; minute = minute+1;
      end
      if minute == 60
         minute = 0; hour = hour + 1;
      end
      if hour == 24
         hour = 0; day = day + 1;
	  end

	  % Calculate day number
	  leapadd = +((mod(year,400) == 0) | ((mod(year,4) == 0) & (mod(year,100) ~= 0)) & (month > 2));
	  jday = monthadd(month) + day + leapadd;
		
      stringToShow = ds.file_string;
      % build the file arg string
      if isempty(ds.file_args)
        filename = {stringToShow};
	  else
		z = cellfun(@eval,ds.file_args,'UniformOutput',false);
		filename(n,m) = {sprintf(stringToShow,z{:})};
      end
    end
  end

end
filename = filename(:);
%basic location of all archives