function A = mtimes(A, B)
%MTIMES (*) Overloaded Matrix multiply for waveforms (UNIMPLEMENTED!).
%     X*Y is the matrix product of X and Y.  Any scalar (a 1-by-1 matrix)
%     may multiply anything.  Otherwise, the number of columns of X must
%     equal the number of rows of Y.
%  
%     C = MTIMES(A,B) is called for the syntax 'A * B' when A or B is an
%     object.
%  
%     Currently, for all practical purposes this is the same as A .* B
%     But this part could change...
%
%     See also TIMES, MTIMES.
   
% AUTHOR: Celso Reyes, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2010-02-16 15:55:19 -0800 (Tue, 16 Feb 2010) $
% $Revision: 204 $

if ~isa(A,'waveform');
    C = B; B = A; A = C; clear C;
end
%A is now a waveform or waveform array
for n=1:numel(A);
    A(n) = set(A(n),'data',A(n).data * double(B));
end
A = addhistory(A,'multiplied (*) by %s', num2str(B));