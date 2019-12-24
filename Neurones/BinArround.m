function [activity] = BinArround(spks,times,varargin)
%BINARROUND Summary of this function goes here
%   This function binspikes arround provided timestamp.
% =========================================================================
%     Properties    Values
%    ----------------------------------------------------------------------
%     'nBins'   Number of bins to be used
%     'binSize' Size of the bin to be used
% =========================================================================

if nargin < 1 | mod(length(varargin),2) ~= 0,
    error('Incorrect number of parameters (type ''help <a href="matlab:help BinArround">BinArround</a>'' for details).');
end

nBins = 1;
binSize = 0.05;
fBin = 1/binSize;

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help BinArround">BinArround</a>'' for details).']);
    end
    switch(lower(varargin{i}))
        case 'nbins'
            nBins = varargin{i+1};
            if ~nBins>0
                error('Incorrect value for property ''nBins'' (type ''help <a href="matlab:help BinArround">BinArround</a>'' for details).');
            end
        case 'binsize'
            binSize = varargin{i+1}
            if ~binSize>0
                error('Incorrect value for property ''binSize'' (type ''help <a href="matlab:help BinArround">BinArround</a>'' for details).');
            end
            
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help BinArround">BinArround</a>'' for details).']);
    end
end

intervals = [times-(binSize/2) times+(binSize/2)];
spks_restricted = Restrict(spks,intervals);


idx = unique(spks(:,4));
activity = [];

for i = 1:max(idx)
    activity =[activity ;CountInIntervals(spks_restricted(spks_restricted(:,4) == i,:),intervals)'];
end

end

