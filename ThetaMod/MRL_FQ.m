function [neurons] = MRL_FQ(session,channel_BLA,keep)
% Mean Resultant Lenght Frequecie -- Calculated Continuous MRL for a range 
%of frequencies for all neurons in a session relative to the HPC and to the
%BLA.
    
    load('D:\Matlab\Billel\indexing.mat')
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);
    session = char(session);
    
    cd(session)
        
    if exist('Billel/AllMod/AllMod.mat')
        load('Billel/AllMod/AllMod.mat')
        return
    end
    
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
    load('States.mat')


    spks.all = GetSpikes('output','full'); %GetAllSpikes
    
    spks.sws = spks.all(InIntervals(spks.all,sws),:);
    spks.rem = spks.all(InIntervals(spks.all,Rem),:);
    
    spks.rem = SpksId(spks.rem);
    spks.sws = SpksId(spks.sws);

    lfp.bla.rem = GetLFP(channel_BLA,'restrict',Rem);
    lfp.hpc.rem = GetLFP(GetRippleChannel,'restrict',Rem);
    lfp.bla.sws = GetLFP(channel_BLA,'restrict',sws);
    lfp.hpc.sws = GetLFP(GetRippleChannel,'restrict',sws);
    
    %Sometimes spks are right after the end of REM and still counted in REM : 
    spks.rem = spks.rem(spks.rem(:,1)<lfp.hpc.rem(end,1),:);
    spks.rem = spks.rem(spks.rem(:,1)<lfp.bla.rem(end,1),:);
    
    spks.sws = spks.sws(spks.sws(:,1)<lfp.hpc.sws(end,1),:);
    spks.sws = spks.sws(spks.sws(:,1)<lfp.bla.sws(end,1),:);
    
    lfp.bla.frem = [lfp.bla.rem(:,1)];
    lfp.hpc.frem = [lfp.hpc.rem(:,1)];
    lfp.hpc.fsws = [lfp.bla.sws(:,1)];
    lfp.bla.fsws = [lfp.hpc.sws(:,1)];
    
    lfp.f = [];
    
    for f = 0:5:100
       clc
       disp(['Rat : ' num2str(rat) ' Jour : ' num2str(jour) ' Filtering Signals' num2str(f) '-' num2str(f+5) ' Hz'])
       disp([num2str(f) '%' repmat('#',1,f) repmat('0',1,100-f)])
       filter = FilterLFP(lfp.hpc.sws,'passband',[f f+5]);
       lfp.hpc.fsws = [lfp.hpc.fsws filter(:,2)];
       
       filter = FilterLFP(lfp.hpc.rem,'passband',[f f+5]);
       lfp.hpc.frem = [lfp.hpc.frem filter(:,2)];
       
       filter = FilterLFP(lfp.bla.sws,'passband',[f f+5]);
       lfp.bla.fsws = [lfp.bla.fsws filter(:,2)];

       filter = FilterLFP(lfp.bla.rem,'passband',[f f+5]);
       lfp.bla.frem = [lfp.bla.frem filter(:,2)];
       
       lfp.f = [lfp.f f];
    end
    
    
    neurons.hpc.sws.r = [];
    neurons.hpc.rem.r = [];
    neurons.bla.sws.r = [];
    neurons.bla.rem.r = [];
    
    neurons.hpc.sws.p = [];
    neurons.hpc.rem.p = [];
    neurons.bla.sws.p = [];
    neurons.bla.rem.p = [];
    
    neurons.f = lfp.f;
    
    nsws = size(unique(spks.sws(:,2:3),'rows'),1);
    nrem = size(unique(spks.rem(:,2:3),'rows'),1);
    
    neurons.hpc.sws.metadata = [repmat(rat,nsws,1) repmat(jour,nsws,1) unique(spks.sws(:,2:3),'rows')];
    neurons.hpc.rem.metadata = [repmat(rat,nrem,1) repmat(jour,nrem,1) unique(spks.rem(:,2:3),'rows')];
    neurons.bla.sws.metadata = [repmat(rat,nsws,1) repmat(jour,nsws,1) unique(spks.sws(:,2:3),'rows')];
    neurons.bla.rem.metadata = [repmat(rat,nrem,1) repmat(jour,nrem,1) unique(spks.rem(:,2:3),'rows')];
    
    for i = 1:(size(lfp.f,2)-1)
        clc
        disp(['Rat : ' num2str(rat) ' Jour : ' num2str(jour) ' Calculating Phase relation'])
        disp([num2str((i/(size(lfp.f,2)-1))*100) '%' repmat('#',1,ceil((i/(size(lfp.f,2)-1))*100)) repmat('0',1,ceil(100-(i/(size(lfp.f,2)-1))*100))])
        phase.hpc.sws = Phase([lfp.hpc.fsws(:,1) lfp.hpc.fsws(:,i+1)],spks.sws(:,1));
        phase.hpc.rem = Phase([lfp.hpc.frem(:,1) lfp.hpc.frem(:,i+1)],spks.rem(:,1));
        phase.bla.sws = Phase([lfp.bla.fsws(:,1) lfp.bla.fsws(:,i+1)],spks.sws(:,1)); 
        phase.bla.rem = Phase([lfp.bla.frem(:,1) lfp.bla.frem(:,i+1)],spks.rem(:,1));
        
        [~,~,stats.hpc.sws] = CircularDistribution(phase.hpc.sws(:,2),'groups',spks.sws(:,4));
        [~,~,stats.hpc.rem] = CircularDistribution(phase.hpc.rem(:,2),'groups',spks.rem(:,4));
        [~,~,stats.bla.sws] = CircularDistribution(phase.bla.sws(:,2),'groups',spks.sws(:,4));
        [~,~,stats.bla.rem] = CircularDistribution(phase.bla.rem(:,2),'groups',spks.rem(:,4));

        neurons.hpc.sws.r = [neurons.hpc.sws.r  stats.hpc.sws.r'];
        neurons.hpc.rem.r = [neurons.hpc.rem.r  stats.hpc.rem.r'];
        neurons.bla.sws.r = [neurons.bla.sws.r  stats.bla.sws.r'];
        neurons.bla.rem.r = [neurons.bla.rem.r  stats.bla.rem.r'];
        
        neurons.hpc.sws.p = [neurons.hpc.sws.p  stats.hpc.sws.p'];
        neurons.hpc.rem.p = [neurons.hpc.rem.p  stats.hpc.rem.p'];
        neurons.bla.sws.p = [neurons.bla.sws.p  stats.bla.sws.p'];
        neurons.bla.rem.p = [neurons.bla.rem.p  stats.bla.rem.p'];
    end
    
    if keep == 1
        mkdir('Billel/AllMod');
        cd('Billel/AllMod');
        save('AllMod','neurons')
    end
end







