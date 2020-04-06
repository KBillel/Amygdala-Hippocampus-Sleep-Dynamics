function [binMatrix] = BinInIntervals(spks,intervals,varargin)

% BinInIntervals - Calculates the binMatrix for each individual neurons for
% all 3D intervals that are given.

%  USAGE
%
%    [binMatrix] = BinInIntervals(spks,intervals,varargin)
%
%    spks       spks as output by SpksID
%    Intervals  Tables containing in first column names of state, and in second column intervals corresponding to that brain state 
%    <options>  optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties            Values
%    -------------------------------------------------------------------------
%     'zscore'		true/false
%     'binSize'     binSize (s), default = 0.025s
%    =========================================================================
%
%  OUTPUT
%    binMatrix	3D matrix (neurons,time,BrainState)
%
%    See also : SpikeTrain, BinArround
%
% January 2020, Billel Khouader
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.


    % Check number of inputs
    if nargin < 2,
      error('Incorrect number of parameters (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).');
    end
    
    % Check varargin
    if mod(length(varargin),2) ~= 0,
      error('Incorrect number of parameters  (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).');
    end
    % Default variable
    
    zscr = false;
    binSize = 0.025;
    
    % Parse options
    for i = 1:2:length(varargin),
        if ~ischar(varargin{i}),
            error(['Parameter ' num2str(i) ' is not a property (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).']);
        end
        switch(lower(varargin{i})),
            case 'binsize',
                binSize = (varargin{i+1});
            case 'zscore',
                zscr = (varargin{i+1});
            otherwise,
                error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).']);
        end
    end
    
    nNeurons = max(spks(:,4));
    binMatrix = struct([]);
    for i = 1:size(intervals,2)
        interval = intervals(i).times;
        binMatrix(i).states = intervals(i).states;
        binMatrix(i).learning = intervals(i).learning;

        if size(interval,2) == 2
            spksi = Restrict(spks,interval);
            [binMatrix(i).data, bins] = SpikeTrain([spksi(:,1) spksi(:,4)],binSize,[interval(1,1) interval(end,end)],'nNeurons',nNeurons);

            matrix = binMatrix(i).data';
            binMatrix(i).data = matrix(:,InIntervals(bins,interval));
        else 
            binMatrix(i).data = BinArround(spks,interval,'nNeurons',nNeurons,'binSize',binSize);
        end
        
        if zscr
            binMatrix(i).data = zscore(binMatrix(i).data,0,2);
        end
    end
    
end

