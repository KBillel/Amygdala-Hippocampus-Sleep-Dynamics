function [] = ThetaMod(session,channel_HPC,channel_BLA)
    load('D:\Matlab\Billel\indexing.mat')
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);
    
    

    load('Z:\All-Rats\Structures\structures.mat')
    load('Z:\All-Rats\AllRats-FinalType.mat')
   
    cd(session)
    if exist('Billel/ThetaMod/ThetaMod.mat')
        load('Billel/ThetaMod/ThetaMod.mat')
        return
    end
    
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
    load('States.mat')
    
    spks.all = GetSpikes('output','full');
    
    spks.rem = spks.all(InIntervals(spks.all,Rem),:);
    spks.rem = SpksId(spks.rem);
    
    
    lfp.bla.rem = GetLFP(channel_BLA,'restrict',Rem);
    lfp.hpc.rem = GetLFP(channel_HPC,'restrict',Rem);
    
    
    mkdir('Billel/ThetaMod');
    cd('Billel/ThetaMod');
    
    %Sometimes spks are right after the end of REM and still counted in REM : 
    spks.rem = spks.rem(spks.rem(:,1)<lfp.hpc.rem(end,1),:);
    spks.rem = spks.rem(spks.rem(:,1)<lfp.bla.rem(end,1),:);
    
    [phase.hpc,amplitude.hpc,unwrapped.hpc] = Phase(FilterLFP(lfp.hpc.rem),spks.rem(:,1));
    [dist.hpc,binned.hpc,stats.hpc] = CircularDistribution(phase.hpc(:,2),'groups',spks.rem(:,4));
    dist.hpc = [];
    binned.hpc = [];
    stats.hpc = [];
    [phase.bla,amplitude.bla,unwrapped.bla] = Phase(FilterLFP(lfp.bla.rem),spks.rem(:,1));
    [dist.bla,binned.bla,stats.bla] = CircularDistribution(phase.bla(:,2),'groups',spks.rem(:,4));
    
    n = length(unique(spks.rem(:,2:4)));
    metadata = [repmat(rat,n,1) repmat(jour,n,1) unique(spks.rem(:,2:4),'rows')];
    
    if rat == 9
        phase.hpc = [];
        amplitude.hpc = [];
        unwrapped.hpc = [];
        dist.hpc = [];
        binned.hpc=[];
        stats.hpc=[];
    end
    
    
    save('ThetaMod','phase' ,'amplitude' ,'unwrapped' ,'dist' ,'binned' ,'stats','metadata')   
end

