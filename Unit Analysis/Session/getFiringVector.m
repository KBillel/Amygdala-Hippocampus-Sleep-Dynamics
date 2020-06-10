function [firingVector] = getFiringVector(session,varargin)

%  getFiringVector - This function calculate firingVector as described by
%  Clawson2019
% 
%  USAGE
%
%    [firingVector] = getFiringVector(session,str,varargin)
%
%    session	Complete path to session
%    str    	structure name (ex : 'BLA')
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
%    [firingVector] Matrice of firing features during time.
%
%    See also : binspikes, corrcoef, corr
%
% May 2019, Billel Khouader
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

if nargin < 1,
  error('Incorrect number of parameters (type ''help <a href="matlab:help FunctionName">FunctionName</a>'' for details).');
end



savevar = 'off';
binSize = 0.050;
force = true;

load('D:\Matlab\Billel\indexing.mat')
load('Z:\All-Rats\Structures\structures.mat')
load('Z:\All-Rats\Billel\AllNeurons.mat')

index = ratsessionindex(xmlpath == session,:);
rat = index(1);
jour = index(2);
session = char(session);

cd(session);

SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat') 


interval = [sws(1,1) Rem(4,2)]


spks.all = GetSpikes('output','full');
spks.all = SpksId(spks.all);
spks.t = Restrict(spks.all,interval);
spks.t = SpksId(spks.t);
nALL = max(spks.t(:,4));
metadata = [repmat(rat,nALL,1) repmat(jour,nALL,1) unique(spks.t(:,2:4),'rows')];

[spks_train,bins] = SpikeTrain([spks.t(:,1) spks.t(:,4)],binSize,interval);
binarize_spks_train = spks_train >0;

tic
region = [];
type = [];
for i = 1:nALL
    ident = metadata(metadata(:,5)==i,1:4);
    region = [region; x.region(sum(x.ident == ident,2) == 4)]
    type = [type; x.type(sum(x.ident == ident,2)==4)];
end
toc
type = char(type);
region = char(region);

isrem = InIntervals(bins,Rem);
issws = InIntervals(bins,sws);
iswake = InIntervals(bins,wake);
end