function [EV,REV,CorrMatrix] = ExplainedVariance_Theta(session,structure,pre,post,varargin)% Explained Variance_Ultimate - Calculates the explained variance and reverse explained variances for pre/run/post sessions (Kudrimoti 1999, Lansink 2009)
%  USAGE
%
%    [EV,REV,CorrMatrix] = ExplainedVariance_Theta(session,structure,pre,post,varargin)
%
%    session		Complete path to session
%    structure		structure name (ex : 'BLA')
%    pre		subsession number for presleep
%    post		subsession number for postsleep
%    <options>      	optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties            Values
%    -------------------------------------------------------------------------
%     'binsize'		size of bin for binning spike trains in seconds. Default : 0.05s
%     'savefig'		save figure (Default 'off')
%     'savevar'		save variable (Default 'on')		
%    =========================================================================
%
%  OUTPUT
%
%    EV           	Explained Variance
%    REV            	Reverse Explained variance
%    CorrMatrix		Correlation matrices for pre/run/post (CorrMatrix.pre .run .post)
%
%  NOTE
%
%
%  SEE
%
%    See also : binspikes, corrcoef, corr
%
% December 2019, Billel Khouader
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

%Default
binsize = 0.05;
savefig = 'off';
savevar = 'off';

% Check number of inputs
if nargin < 4,
  error('Incorrect number of parameters (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).');
end

% Check varargin
if mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters  (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).');
end

% Parse options
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i) ' is not a property (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).']);
	end
	switch(lower(varargin{i})),
		case 'type',
			type = lower(varargin{i+1});
		case 'binsize',
			binsize = (varargin{i+1});
		case 'savevar',
			savevar = (varargin{i+1});
		case 'savefig',
			savefig = (varargin{i+1});
		otherwise,
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).']);
	end
end

load('D:\Matlab\Billel\indexing.mat')
load('Z:\All-Rats\Structures\structures.mat')
load('Z:\All-Rats\AllRats-FinalType.mat')

index = ratsessionindex(xmlpath == session,:);

rat = index(1);
jour = index(2);
session = char(session);

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')

spks.all = GetSpikes('output','full'); %GetAllSpikes
spks.all = SpksId(spks.all);







