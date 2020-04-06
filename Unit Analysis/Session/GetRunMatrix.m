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


spks.all = SpksId(GetSpikes('output','full'))
BLA = BLA(ismember(BLA(:,1:2),[rat jour],'rows'),:)
spks.amy_all = spks.all(ismember(spks.all(:,2),BLA(:,3),'rows'),:);
spks.amy_run = Restrict(spks.amy_all,sws)
spks.amy_run = SpksId(spks.amy_run)

[Qrun,bins] = SpikeTrain([spks.amy_run(:,1) spks.amy_run(:,4)],binSize,[0 runintervals(end,end)]);
isrun = InIntervals(bins,sws);
Qrun = Qrun(isrun,:);

imagesc(corrcoef(Qrun))