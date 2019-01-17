function w = abs(w)
%ABS Absolute value for the waveform object
%   waveform = abs(waveform)
%   equivelent to running "abs" on the data within the waveform.
%
%   Input Argument
%       WAVEFORM: waveform object       N-DIMENSIONAL
%
%  input waveform may be N-dimensional
% See also ABS.
   
% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2010-02-16 15:55:19 -0800 (Tue, 16 Feb 2010) $
% $Revision: 204 $

for n=1:numel(w)
    w(n).data = abs(w(n).data);
end
w(n) = addhistory(w(n), 'Absolute value of data');