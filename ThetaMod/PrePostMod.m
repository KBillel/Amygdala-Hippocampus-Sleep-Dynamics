function [] = PrePostMod(session,channel_HPC,channel_BLA,pre,post,keep)

load('D:\Matlab\Billel\indexing.mat')
index = ratsessionindex(xmlpath == session,:);
rat = index(1);
jour = index(2);


load('Z:\All-Rats\Structures\structures.mat')
load('Z:\All-Rats\AllRats-FinalType.mat')

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')




presleep  = RunIntervals(pre);
postsleep = RunIntervals(post);


lfp.bla.rem.all = GetLFP(channel_BLA,'restrict',Rem);
lfp.hpc.rem.all = GetLFP(channel_HPC,'restrict',Rem);

lfp.bla.rem.pre = lfp.bla.rem.all(InIntervals(lfp.bla.rem.all,presleep),:);
lfp.bla.rem.post = lfp.bla.rem.all(InIntervals(lfp.bla.rem.all,postsleep),:);

lfp.hpc.rem.pre = lfp.hpc.rem.all(InIntervals(lfp.hpc.rem.all,presleep),:);
lfp.hpc.rem.post = lfp.hpc.rem.all(InIntervals(lfp.hpc.rem.all,postsleep),:);

spks.all = GetSpikes('output','full');
spks.all = SpksId(spks.all);

spks.pre.all  = spks.all(spks.all(:,1)<presleep(2),:);
spks.post.all = spks.all(spks.all(:,1)>postsleep(1),:);

spks.pre.sws = spks.pre.all(InIntervals(spks.pre.all(:,1),sws),:);
spks.pre.rem = spks.pre.all(InIntervals(spks.pre.all(:,1),Rem),:);


spks.post.sws = spks.post.all(InIntervals(spks.post.all(:,1),sws),:);
spks.post.rem = spks.post.all(InIntervals(spks.post.all(:,1),Rem),:);

spks.pre.rem = [repmat(spks.pre.rem(1,1),length(unique(spks.all(:,4))),1) [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.pre.rem];
spks.post.rem = [repmat(spks.post.rem(1,1),length(unique(spks.all(:,4))),1) [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.post.rem];

%Sometimes spks are right after the end of REM and still counted in REM : 
spks.pre.rem = spks.pre.rem(spks.pre.rem(:,1)<lfp.hpc.rem.pre(end,1),:);
spks.post.rem = spks.post.rem(spks.post.rem(:,1)<lfp.hpc.rem.post(end,1),:);


%Phasemodulation Pre learning
[phase.pre.hpc,amplitude.pre.hpc,unwrapped.pre.hpc] = Phase(FilterLFP(lfp.hpc.rem.pre),spks.pre.rem(:,1));
[dist.pre.hpc,binned.pre.hpc,stats.pre.hpc] = CircularDistribution(phase.pre.hpc(:,2),'groups',spks.pre.rem(:,4));

[phase.pre.bla,amplitude.pre.bla,unwrapped.pre.bla] = Phase(FilterLFP(lfp.bla.rem.pre),spks.pre.rem(:,1));
[dist.pre.bla,binned.pre.bla,stats.pre.bla] = CircularDistribution(phase.pre.bla(:,2),'groups',spks.pre.rem(:,4));

%Phasemodulation Post Learning
[phase.post.hpc,amplitude.post.hpc,unwrapped.post.hpc] = Phase(FilterLFP(lfp.hpc.rem.post),spks.post.rem(:,1));
[dist.post.hpc,binned.post.hpc,stats.post.hpc] = CircularDistribution(phase.post.hpc(:,2),'groups',spks.post.rem(:,4));

[phase.post.bla,amplitude.post.bla,unwrapped.post.bla] = Phase(FilterLFP(lfp.bla.rem.post),spks.post.rem(:,1));
[dist.post.bla,binned.post.bla,stats.post.bla] = CircularDistribution(phase.post.bla(:,2),'groups',spks.post.rem(:,4));

n = length(unique(spks.all(:,2:4)));
metadata = [repmat(rat,n,1) repmat(jour,n,1) unique(spks.all(:,2:4),'rows')];

if keep == 1
    mkdir('Billel/ThetaMod');
    cd('Billel/ThetaMod');

    save('PrePostThetaMod','phase' ,'amplitude' ,'unwrapped' ,'dist' ,'binned' ,'stats','metadata')   
end

