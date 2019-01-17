function w = clearhistory(w)
%CLEARHISTORY reset history of a waveform
%   waveform = clearhistory(waveform)
%   clears the history, leaving current date/time. To remove history 
%   altogether, use 'delfield'
%
%   Input Argument
%       WAVEFORM: a waveform object   N-DIMENSIONAL
%
%
%   Control of whether or not history is added automatically lies within
%   the waveform constructor (in a global variable called WAVEFORM_HISTORY)
%
%
% See also WAVEFORM/ADDHISTORY, WAVEFORM/DELFIELD, WAVEFORM/ADDFIELD.

% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2010-06-24 15:33:04 -0700 (Thu, 24 Jun 2010) $
% $Revision: 241 $

[w.history] = deal({});
%w = addhistory(w,uint8(0));
w = addhistory(w,'Cleared History');
