function [results, loc] = ismember(mywave,anythingelse)
%ISMEMBER waveform implementation of ismember
% currently only works for comparison to scnlobjects
%
% TRUE for each waveform that matches any scnl in the anythingelse array.

% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2010-02-12 19:12:02 -0800 (Fri, 12 Feb 2010) $
% $Revision: 200 $

if ~isa(anythingelse,'scnlobject')
  error('Waveform:ismember:classMismatch',...
    'Waveform does not know how to determine if it is a member of a %s class',...
    class(anythingelse));
end
[results, loc]  = ismember(get(mywave,'scnlobject'),anythingelse);
