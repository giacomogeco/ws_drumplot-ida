function w = uminus(w)
%-  Unary minus for waveforms.
%   -A negates the elements of A.
%
%   B = UMINUS(W) is called for the syntax '-W' when W is an waveform.

% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2010-02-12 19:12:02 -0800 (Fri, 12 Feb 2010) $
% $Revision: 200 $

for n=1:numel(w)
    w(n).data = -w(n).data;
end
w = addhistory(w,'multiplied by -1');
