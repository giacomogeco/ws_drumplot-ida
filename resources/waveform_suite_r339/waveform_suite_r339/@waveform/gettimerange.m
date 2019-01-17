function [startTimeList endTimeList] = gettimerange(w)
%GETTIMERANGE returns the list of start and end times from a waveform array
%[startTimeList endTimeList] = gettimerange(w)

% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2010-02-16 15:55:19 -0800 (Tue, 16 Feb 2010) $
% $Revision: 204 $

%specialized function that doesn't do much, ideal candidate for deprication
startTimeList = get(w,'start');
endTimeList = get(w,'end');