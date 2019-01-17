function W = smooth(W, varargin)
% SMOOTH overloaded smooth function for waveform
% Differs from MATLAB's smooth function in that it takes one or more
% waveforms instead of a data vector.  
%
% See Also smooth

% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2010-02-16 15:55:19 -0800 (Tue, 16 Feb 2010) $
% $Revision: 204 $

for n = 1:numel(W)
    W(n) = set(W(n),'data',smooth(W(n).data,varargin{:}));
end
W = addhistory(W,{'Smoothed with these arguments',varargin});
