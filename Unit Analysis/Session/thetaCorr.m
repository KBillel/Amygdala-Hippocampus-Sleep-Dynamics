function [corrM]  = thetaCorr(session)
    load('D:\Matlab\Billel\indexing.mat')
    load('Z:\All-Rats\Structures\structures.mat')
    
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);
    session = char(session);
    
    cd(session)
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
    load('States.mat')
    
    
    spks.all = GetSpikes('output','full');
    spks.all = SpksId(spks.all);
    
    lfp.rem = GetLFP(13,'restrict',[Rem(1,1)+0 Rem(2,2)]);
    
    [peaks,troughs] = DetectOscillationPeaks(lfp.rem);
    
    lfp.rem = SpksId(lfp.rem);
    
    
end
