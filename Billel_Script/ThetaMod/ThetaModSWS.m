function [] = ThetaModSWS(session,channel_HPC,channel_BLA)
    load('D:\Matlab\Billel\indexing.mat')
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);
    

    load('Z:\All-Rats\Structures\structures.mat')
    load('Z:\All-Rats\AllRats-FinalType.mat')
   
    cd(session)
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
    load('States.mat')
    
    spks.all = GetSpikes('output','full');
    spks.sws = spks.all(InIntervals(spks.all,sws),:);
    spks.sws = SpksId(spks.sws);
    
    spks.rem = spks.all(InIntervals(spks.all,Rem),:);
    spks.rem = SpksId(spks.rem);
    
    lfp.bla.sws = GetLFP(channel_BLA,'restrict',sws);
    lfp.hpc.sws = GetLFP(channel_HPC,'restrict',sws);
    
    
    mkdir('Billel/ThetaMod');
    cd('Billel/ThetaMod');
    

    [phase.hpc,amplitude.hpc,unwrapped.hpc] = Phase(FilterLFP(lfp.hpc.sws),spks.sws(:,1));
    [dist.hpc,binned.hpc,stats.hpc] = CircularDistribution(phase.hpc(:,2),'groups',spks.sws(:,4));
 
    [phase.bla,amplitude.bla,unwrapped.bla] = Phase(FilterLFP(lfp.bla.sws),spks.sws(:,1));
    [dist.bla,binned.bla,stats.bla] = CircularDistribution(phase.bla(:,2),'groups',spks.sws(:,4));
    
    n = length(unique(spks.sws(:,2:4)));
    metadata = [repmat(rat,n,1) repmat(jour,n,1) unique(spks.sws(:,2:4),'rows')];
    
    save('ThetaModSWS','phase' ,'amplitude' ,'unwrapped' ,'dist' ,'binned' ,'stats','metadata')
end