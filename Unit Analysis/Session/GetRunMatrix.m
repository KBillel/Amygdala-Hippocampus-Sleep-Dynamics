function [Qrun] = GetRunMatrix(session,binSize)

load('D:\Matlab\Billel\indexing.mat')
load('Z:\All-Rats\Billel\AllNeurons.mat')
load('Z:\All-Rats\Structures\structures.mat')

index = ratsessionindex(xmlpath == session,:);

rat = index(1);
jour = index(2);
session = char(session);

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('runintervals.mat')
load('States.mat')



intervals = runintervals;


% Load spikes in the BLA.
spks.all = SpksId(GetSpikes('output','full'))
BLA = BLA(ismember(Hpc(:,1:2),[rat jour],'rows'),:)
spks.amy_all = spks.all(ismember(spks.all(:,2),BLA(:,3),'rows'),:);
spks.amy_run = Restrict(spks.amy_all,intervals)
spks.amy_run = SpksId(spks.amy_run)


AirpuffDistance = getAirpuffDistance(session);

% Calulate Run matrix
[Qrun,bins] = SpikeTrain([spks.amy_run(:,1) spks.amy_run(:,4)],binSize,[AirpuffDistance(1,1) AirpuffDistance(end,1)]);
isrun = InIntervals(bins,intervals);
Qrun = Qrun(isrun,:);

imagesc(corrcoef(Qrun))