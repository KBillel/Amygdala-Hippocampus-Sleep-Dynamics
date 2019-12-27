function [CorrMatrix,EV,REV] = StateCorrMatrix(session,str,pre,post,varargin)

% StateCorrMatrix - Calculates the correlation matrix between hpc and str
% for REM peak / REM troughs and run.
%  USAGE
%
%    [CorrMatrix] = StateCorrMatrix(session,str,pre,post,varargin)
%
%    session	Complete path to session
%    str    	structure name (ex : 'BLA')
%    pre		subsession number for presleep
%    post		subsession number for postsleep
%    <options>  optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties            Values
%    -------------------------------------------------------------------------
%     'binsize'		size of bin for binning spike trains in seconds. Default : 0.025s
%     'savevar'		save variable (Default 'off')		
%    =========================================================================
%
%  OUTPUT
%    CorrMatrix		Correlation matrices for pre/run/post (CorrMatrix.pre .run .post)
%
%    See also : binspikes, corrcoef, corr
%
% December 2019, Billel Khouader
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

% Check number of inputs
if nargin < 3,
  error('Incorrect number of parameters (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).');
end

% Check varargin
if mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters  (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).');
end

savevar = 'off';
binSize = 0.025;

% Parse options
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i) ' is not a property (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).']);
	end
	switch(lower(varargin{i})),
		case 'binsize',
			binSize = (varargin{i+1});
		case 'savevar',
			savevar = (varargin{i+1});
		otherwise,
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).']);
	end
end
    
load('D:\Matlab\Billel\indexing.mat')
load('Z:\All-Rats\Structures\structures.mat')


index = ratsessionindex(xmlpath == session,:);
rat = index(1);
jour = index(2);
session = char(session);
str_name = str;

cd(session)

if exist(['Billel/CorrMatrix/CorrMatrix' str_name '_' num2str(binSize) '.mat'])
    load(['Billel/CorrMatrix/CorrMatrix' str_name '_' num2str(binSize) '.mat'])
    [EV.peaks,REV.peaks] = ExplainedVariance(CorrMatrix.run.matrix,CorrMatrix.pre.rem.peaks.matrix,CorrMatrix.post.rem.peaks.matrix);
    [EV.troughs,REV.troughs] = ExplainedVariance(CorrMatrix.run.matrix,CorrMatrix.pre.rem.troughs.matrix,CorrMatrix.post.rem.troughs.matrix)
    return
end

SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')
load('runintervals.mat')

% Get pre/post sleep intervals
presleep=RunIntervals(pre);
postsleep=RunIntervals(post);
run=runintervals(2,:);

% Load LFP and get detect peaks and troughs.
lfp.all.rem = GetLFP(GetRippleChannel,'restrict',Rem);
lfp.pre.rem = Restrict(lfp.all.rem,presleep);
lfp.post.rem = Restrict(lfp.all.rem,postsleep);

[peaks.pre,troughs.pre] = DetectOscillationPeaks(lfp.pre.rem);
[peaks.post,troughs.post] = DetectOscillationPeaks(lfp.post.rem);

% Load str.
str = eval(str);
str = str(str(:,1)==rat & str(:,2)==jour,:);
Hpc = Hpc(Hpc(:,1)==rat & Hpc(:,2)==jour,:);

% Load spikes and sort them pre/run/post
spks.all = GetSpikes('output','full');

%HPC
spks.hpc.all = spks.all(ismember(spks.all(:,2),Hpc(:,3),'rows'),:);
spks.hpc.all = SpksId(spks.hpc.all);
spks.hpc.pre.all = Restrict(spks.hpc.all,presleep); 
spks.hpc.post.all = Restrict(spks.hpc.all,postsleep);
spks.hpc.pre.rem = Restrict(spks.hpc.pre.all,Rem);
spks.hpc.post.rem = Restrict(spks.hpc.post.all,Rem);
spks.hpc.run = Restrict(spks.hpc.all,run);

nHPC = max(spks.hpc.all(:,4));

%STR
spks.str.all = spks.all(ismember(spks.all(:,2),str(:,3),'rows'),:);
spks.str.all = SpksId(spks.str.all);
spks.str.pre.all = Restrict(spks.str.all,presleep); 
spks.str.post.all = Restrict(spks.str.all,postsleep);
spks.str.pre.rem = Restrict(spks.str.pre.all,Rem);
spks.str.post.rem = Restrict(spks.str.post.all,Rem);
spks.str.run = Restrict(spks.str.all,run);

nSTR = max(spks.str.all(:,4));


%MConstruction of zSpikeMatrix:
%HPC:  
[binMatrix.hpc.pre.rem.peaks] = zscore(BinArround(spks.hpc.pre.rem,peaks.pre.times(:,1),'nNeurons',nHPC,'binSize',binSize),0,2);
[binMatrix.hpc.pre.rem.troughs] = zscore(BinArround(spks.hpc.pre.rem,troughs.pre.times(:,1),'nNeurons',nHPC,'binSize',binSize),0,2);
[binMatrix.hpc.run] = zscore(SpikeTrain([spks.hpc.run(:,1) spks.hpc.run(:,4)],binSize,[run(1,1) run(end,end)],'nNeurons',nHPC)',0,2);
[binMatrix.hpc.post.rem.peaks] = zscore(BinArround(spks.hpc.post.rem,peaks.post.times(:,1),'nNeurons',nHPC,'binSize',binSize),0,2);
[binMatrix.hpc.post.rem.troughs] = zscore(BinArround(spks.hpc.post.rem,troughs.post.times(:,1),'nNeurons',nHPC,'binSize',binSize),0,2);

%STR:
[binMatrix.str.pre.rem.peaks] = zscore(BinArround(spks.str.pre.rem,peaks.pre.times(:,1),'nNeurons',nSTR,'binSize',binSize),0,2);
[binMatrix.str.pre.rem.troughs] = zscore(BinArround(spks.str.pre.rem,troughs.pre.times(:,1),'nNeurons',nSTR,'binSize',binSize),0,2);
[binMatrix.str.run] = zscore(SpikeTrain([spks.str.run(:,1) spks.str.run(:,4)],binSize,[run(1,1) run(end,end)],'nNeurons',nSTR)',0,2);
[binMatrix.str.post.rem.peaks] = zscore(BinArround(spks.str.post.rem,peaks.post.times(:,1),'nNeurons',nSTR,'binSize',binSize),0,2);
[binMatrix.str.post.rem.troughs] = zscore(BinArround(spks.str.post.rem,troughs.post.times(:,1),'nNeurons',nSTR,'binSize',binSize),0,2);

[CorrMatrix.pre.rem.peaks.matrix,CorrMatrix.pre.rem.peaks.pval] = corr(binMatrix.hpc.pre.rem.peaks',binMatrix.str.pre.rem.peaks');
[CorrMatrix.pre.rem.troughs.matrix,CorrMatrix.pre.rem.troughs.pval] = corr(binMatrix.hpc.pre.rem.troughs',binMatrix.str.pre.rem.troughs');
[CorrMatrix.run.matrix,CorrMatrix.run.pval] = corr(binMatrix.hpc.run',binMatrix.str.run');
[CorrMatrix.post.rem.peaks.matrix,CorrMatrix.post.rem.peaks.pval] = corr(binMatrix.hpc.post.rem.peaks',binMatrix.str.post.rem.peaks');
[CorrMatrix.post.rem.troughs.matrix,CorrMatrix.post.rem.troughs.pval] = corr(binMatrix.hpc.post.rem.troughs',binMatrix.str.post.rem.troughs');


[EV.peaks,REV.peaks] = ExplainedVariance(CorrMatrix.run.matrix,CorrMatrix.pre.rem.peaks.matrix,CorrMatrix.post.rem.peaks.matrix);
[EV.troughs,REV.troughs] = ExplainedVariance(CorrMatrix.run.matrix,CorrMatrix.pre.rem.troughs.matrix,CorrMatrix.post.rem.troughs.matrix);

if strcmpi(savevar,'on')
    mkdir('Billel/CorrMatrix')
    cd('Billel/CorrMatrix')
    save(['CorrMatrix' str_name '_' num2str(binSize) '.mat'],'CorrMatrix')
end

end
    

