function w = waveform(varargin)
%WAVEFORM Creates or imports one or more waveform objects (seismic traces)
%   w = WAVEFORM(datasource, scnlobjects, starttimes, endtimes)
%          loads waveform from the specified DATASOURCE
%          SCNL stands for STATION-CHANNEL-NETWORK-LOCATION.
%          multiple start-endtime pairs may be used, while station-channel
%          pairs can be provided as an array of scnlobjects
%
%   w = WAVEFORM() creates a blank waveform out of thin air
%       The default waveform has STATION = '', CHANNEL = '', data = [],
%       starttime = '1/1/1970', and UNITS = 'counts'
%
%   w = WAVEFORM(station, channel, samplerate, starttime, data)
%          manually puts together a waveform object from the minimum
%          required fields.
%
%      STATION - which seismic station, ex. 'OKCF'  (default '')
%      CHANNEL - 'BHZ', 'SHZ', and the like         (default '')
%      SAMPLERATE - Sampling frequency, in Hz       (default nan)
%      DATA - a vector of seismic amplitudes        (default [])
%      STARTTIME - Start time, in most any format   (default '1/1/1970')
%      ENDTIME - end time, in most any format
%
%  w = WAVEFORM(...,'nocombine')
%    If the data requested by waveform consists of multiple segments, then
%    these segments will be combined, with NaN filling any data gaps.  Set
%    the last argument to 'nocombine' to override this behavior.  Be aware
%    that with the nocombine option, the returned value may include
%    multiple waveforms for each starttime-endtime combination.
%
% 
%  DATASOURCES
%    Waveform can retrieve data from the following datasources, with
%    caveats and requirements as noted below:
%  
%    FILE, SAC, SEISAN, ANTELOPE, WINSTON, IRISDMCWS, (plus user-defined)
%
%    ANTELOPE  requires the Antelope Toolbox be installed.
%
%    WINSTON   requires usgs.jar (or equivalent), available through the
%              winston wave server or from SWARM. See *JAR NOTE* below
%
%              Winston data is not automatically adjusted instrument gain.
%              To fix this, multiply it by the gain.  Ex.  W = W .* 6.67; 
% 
%    IRISDMCWS Accessing data from the IRIS-DMC requires the IRIS Web
%              Services Java Library (IRIS-WS Library). For more
%              information on integrating this into MATLAB, please visit
%              http://www.iris.edu/manuals/javawslibrary/
%
%              See *JAR NOTE* below
%      
%
%    *JAR NOTE* - using WAVEFORM with java libraries:
%      Winston and IRIS-DMC access each require access to specific java
%      archives (.jar files).  These may be added to the MATLAB search path
%      dynamically with "javaaddpath"; doing so in the startup.m will make
%      the .jar available each time MATLAB starts. 
%   
%      Another way to make a java library perminently available is
%      to edit Matlab's classpath.txt file (located in the toolbox/local 
%      directory) and add the full path to the appropriate .jar file.
%
%
%  Examples of accessing waveform data
%    Example:
%      % Retrieve data stored in .mat files in a directory structure 
%      % like this: /data/YYYY/MM/STATION_DD 
%      ds = datasource('file','/data/%4d/%02d/%s_%02d','year','month','station','day');
%      scnls = scnlobject('STA1','BHZ','AA','--');
%      w = waveform(ds, scnls, '6/25/1998 08:00:00', '6/26/1998 09:00:00');
%      
%    
%    Example:
%      % Get a few minutes of data from a ficticious winston wave server.
%      myStations = {'OKCF','PV6','SSLS'}; 
%      myChannels = 'EHZ';
%      scnls = scnlobject(myStations,myChannels,'AV','--');
%      ds = datasource('winston','servername.here.edu',1255);
%      w = waveform(ds, scnls, now - 1, now - .98);
%
%    Example:
%      % Get some data from IRIS, then plot it
%      ds = datasource('irisdmcws');
%      scnls = scnlobject('ANMO', '?HZ', 'IU', '*')
%      w = waveform(ds, scnl, '2010-02-27 06:30:00','2010-02-27 07:30:00')
%      plot(w)
%
%    More Examples are available in the datasource documentation.
%
%
%  REFERENCE / CITATION:
%     Reyes, C. G. and West, M. E., 2011. "The Waveform Suite: A Robust
%     Platform for Manipulating Waveforms in MATLAB", SRL 82 (1) 104-110. 
%  
%
% see also SCNLOBJECT, DATASOURCE, ADDPATH

% VERSION: 1.1 of waveform objects
% AUTHOR: Celso Reyes (celso@gi.alaska.edu)
% LASTUPDATE: 11/24/2009

global WaveformNamespaceIsLoaded
if isempty(WaveformNamespaceIsLoaded)
  WaveformNamespaceIsLoaded = loadGlobalNamespace();
end;

%global mep2dep dep2mep; %#ok<NUSED>

% do we combine waveforms, or not?  If NOT, then the last argument will be
% 'nocombine'.
% if 'nocombine' isn't listed, then the constructor will combine waveforms
% by default.
argCount = nargin;
if argCount>0 && ischar(varargin{end}) && strcmpi(varargin{end},'nocombine')
  varargin = varargin(1:end-1);
  COMBINE_WAVES = false;
  argCount = argCount -1;
else
  COMBINE_WAVES = true;
end
updateWarningID = 'Waveform:waveform:oldUsage';

switch argCount
  case 0 % create a generic waveform
    w = genericWaveform();
    
  case 1   %"copy" a waveform object
    
    anyV = varargin{1};
    if isa(anyV, 'waveform')
      % INPUT: waveform (station)
      w = anyV;
    end;
    
  case 4
    if isa(varargin{1},'datasource')
      % invoke the "standard" way of importing a waveform
      % eg.  w = waveform(datasource, scnlobjects,startTimes,endTimes)
      
      % reassign the function arguments into meaningful variables
      [ds, scnls, startt, endt] = deal(varargin{:});
      %ds = varargin{1};
      %scnls = varargin{2};
      %startt = datenum(varargin{3});
      %endt = datenum(varargin{4});
      
      % ensure proper date formatting
      if ischar(startt), startt = {startt}; end
      if ischar (endt), endt = {endt}; end;
      startt = reshape(datenum(startt(:)),size(startt));
      endt = reshape(datenum(endt(:)),size(endt));
      
      % -------------------------------------------------------------------
      % if there is no specifically assigned load function, then
      % determine the load function based upon the datasource's type
      
      if isVoidInterpreter(ds)
        ds_type  = get(ds,'type');
        switch lower(ds_type)
          
          % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          % file, sac, and seisan all do not require fancy handling.  The
          % load routine and interpreter will be set, and the waveform will
          % be loaded in the following section, along with any user-defined
          % load functions.
          case {'file','sac','seisan'}
            myLoadRoutine = eval(['@load_',ds_type]);
            ds = setinterpreter(ds,myLoadRoutine); %update interpeter funct
            
            % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            % both winston and antelope are database types, which require
            % fancier handling.  Their waveforms will be loaded right here.
            
          case {'winston'}
            myLoadRoutine = eval(['@load_',ds_type]);
            w = myLoadRoutine( makeDataRequest(ds,scnls,startt,endt) );
          case {'antelope'}
            myLoadRoutine = eval(['@load_',ds_type]);
            w = myLoadRoutine( makeDataRequest(ds,scnls,startt,endt) ,COMBINE_WAVES);
            
            % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            % Future pre-defined load types would have case statments here
            % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            
            % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            % There was no interpreter set, but there was no default type
            % set, either.
          case {'irisdmcws'}
            myLoadRoutine = eval(['@load_',ds_type]);
            w = myLoadRoutine( makeDataRequest(ds, scnls, startt, endt) , COMBINE_WAVES);
                
          otherwise
            error('Waveform:waveform:noDatasourceInterpreter',...
              'user defined datasources should be associated with an interpreter');
        end
      end
      
      
      % -------------------------------------------------------------------
      % if the datasource is file based, or if it requires a user-defined
      % intepreter function, then do what follows.  Otherwise, we're done
      
      if ~isVoidInterpreter(ds)
        myLoadFunc = get(ds,'interpreter');
        
        %user_defined datasource
        for j = 1:numel(startt)
          myStartTime = startt(j);
          myEndTime = endt(j);
          
          % grab all files for date range, discarding duplicates
          fn = getfilename(ds, scnls,subdivide_files_by_date(ds,myStartTime, myEndTime));
          fn = unique(fn);
          
          %load all waveforms for these files
          clear somew
          for i=1:numel(fn)
            possiblefiles = dir(fn{i});
            if isempty(possiblefiles)
              disp(['no file:',fn{i}]);
              continue,
            end
            
            %             if ~exist(fn{i},'file'),
            %               disp(['no file:',fn{i}]);
            %               continue,
            %             end
            %            w = myLoadFunc(fn{i});
            
            [PATHSTR,NAME,EXT] = fileparts(fn{i});
            for nfiles = 1:numel(possiblefiles)
              w(nfiles) = myLoadFunc(fullfile(PATHSTR,possiblefiles(nfiles).name));
            end
            if isempty(w)
              warning('Waveform:waveform:noData','no data retrieved');
              return
            end
            %combine and get rid of exterreneous waveforms
            w = w(ismember(w,scnls)); %keep only appropriate station/chan
            if isempty(w)
              warning('Waveform:waveform:noData','no relevent data retrieved');
              return
            end
            % subset and consolidate
            [wstarts, wends] = gettimerange(w);
            w = w(wstarts < myEndTime & wends > myStartTime);
            if numel(w) > 0 %9/23/2009 condition
              w = extract(w,'time',myStartTime,myEndTime);
              somew(i) = {w(:)'};
            else
              disp('empty waveform')
              continue;
            end
          end
          if ~exist('somew','var')
            w = waveform; w = w([]);
          else
            if COMBINE_WAVES,
              w = combine([somew{:}]);
            else
              w = [somew{:}];
            end
          end
          allw(j) = {w};
        end %each start time
        w = [allw{:}];
        
        
      end %~isVoidInterpreter
      
    else
      %old waveform way of doing things
      warning(updateWarningID,updateWarningMessage);
      w = waveform(datasource('uaf_continuous'),...
        scnlobject(varargin{1},varargin{2}),...
        datenum(varargin{3}),...
        datenum(varargin{4}));
    end
    
  case 5
    if ischar(varargin{5})
      
      warning(updateWarningID,updateWarningMessage);
      ds = datasource('antelope',varargin{5});
      scnl = scnlobject(varargin{1},varargin{2});
      % INPUT: waveform (station, channel, starttime, endtime,
      % alternatedirectory)
      w = waveform(ds,scnl,varargin{3}, varargin{4});
      
    else
      % Building a waveform from input pieces
      % INPUT: waveform (station, channel, frequency, starttime,
      % data)
      
      w = set(waveform,...
        'station',  varargin{1},...
        'channel',varargin{2},...
        'Freq',     varargin{3},...
        'start',    varargin{4},...
        'data',     varargin{5});
    end;
    w = addhistory(set(w,'history',{}),'CREATED');
  case 8
    DEFAULT_CHAN = 'EHZ';
    DEFAULT_STATION = 'UNK';
    DEFAULT_START = datenum([1970 1 1 0 0 0]);
    DEFAULT_END = DEFAULT_START + datenum([0,0,0,0,5,0]); %five minutes
    
    % the following are for WINSTON access...
    DEFAULT_NETWORK = '';
    DEFAULT_LOCATION = '';
    DEFAULT_SERVER = 'churchill.giseis.alaska.edu';
    DEFAULT_PORT = 16022;
    warning(updateWarningID,updateWarningMessage);
    
    % INPUT: waveform (station, channel, start, end, network,
    %                  location, server, port)
    MyDefaults = {DEFAULT_STATION, DEFAULT_CHAN, DEFAULT_START, ...
      DEFAULT_END, DEFAULT_NETWORK, DEFAULT_LOCATION,...
      DEFAULT_SERVER, DEFAULT_PORT}; %#ok<NASGU>
    
    MyVars = {'station', 'channel', 'Tstart', 'Tend', 'netwk', ...
      'location', 'server', 'port'};
    
    %Fill in all the variables with the appropriate default values
    for N = 1:argCount
      if isempty(varargin{N}),
        eval([MyVars{N},' = MyDefaults{N};'])
      else
        eval([MyVars{N},' = varargin{N};'])
      end
    end
    theseSCNLs = scnlobject(station,channel,netwk,location);
    
    mydatasource = datasource('winston',server,port);
    w = waveform(mydatasource,theseSCNLs,datenum(Tstart),datenum(Tend));
    
  otherwise
    
    disp('Invalid arguments in waveform constructor:');
    disp(varargin);
    disp('valid ways of calling waveform include: ');
    disp('   w = WAVEFORM() creates a default waveform');
    disp('   w = WAVEFORM(datasource, scnls, starttimes, endtimes)  *preferred*');
    disp('   w = WAVEFORM(station, channel, samplefreq, starttime, data)');
end

%%
function tf = isVoidInterpreter(ds)
tf = strcmpi(func2str(get(ds,'interpreter')),'void_interpreter');

function datarequest = makeDataRequest(ds, scnls, st, ed)
datarequest = struct(...
  'dataSource', ds, ...
  'scnls', scnls, ...
  'startTimes', st,...
  'endTimes',ed);

function w = genericWaveform()
%create a fresh waveform.  All calls to the waveform object, aside
%from the "copy" call (case nargin==1) will be initated HERE.
%Thereafter, the waveform will be modified by set/get.
%THIS_VERSION = 1.2;
%DEFAULT_UNIT = 'Counts';
%DEFAULT_FREQ = nan;
%DEFAULT_CHAN = '';
%DEFAULT_STATION = '';
%DEFAULT_START = 719529; % which is equiv to datenum('1/1/1970');
w.scnl = scnlobject;%(DEFAULT_STATION,DEFAULT_CHAN);
w.Fs = nan;
w.start = 719529;
w.data = double([]);
w.units = 'Counts'; %units for data (nm? counts?)
w.version = 1.2; %version of waveform object (internal)
w.misc_fields = {}; %add'l fields, such as "comments", or "trig"
w.misc_values = {}; %values for these fields
w.history = {'created', now};
w = class(w, 'waveform');

%w = addhistory(w,'CREATED'); %got rid of "created" add-history.



function s = updateWarningMessage()

updateMessageBase = ...
  ['Instead, please call the waveform constructor with '...
  ' a datasource and snclobject. \n'...
  'USAGE: w = waveform(datasource, scnlobjects, starttimes, endtimes)\n'...
  '   ...modifying request and proceeding.'];
s = sprintf('%s',updateMessageBase);