% function lineCells=read_ascii2cell(file)
% txtCells=read_ascii2cell(file)
% ouvre un fichier texte et le sort en un vecteur cell, ou chaque ligne est
% dans une cellule 

file='conf_mvt.m'
fid = fopen(file);
TLINE=1;
i=1;

% TO BE USED IN FUTURE:
% while ~feof(fid)
while TLINE~=-1
    tline = fgetl(fid);
    if strcmp(tline,'')
        lineCells{i}='';
    else
        TLINE=tline;
        lineCells{i}=TLINE;
    end
        
        i=i+1;
end
fclose(fid);

lineCells=lineCells(1:length(lineCells)-1)';

% if isempty(varargin)
%     disp('WARNING: input a configuration file with webcamera information.Execution aborted.')
%     return
% else
%     lineCells=read_ascii2cell(varargin{1});
    for i=1:numel(lineCells)
        try
            eval(lineCells{i})
        catch
            disp('WARNING: error in input script')
        end
    end
% % end 
