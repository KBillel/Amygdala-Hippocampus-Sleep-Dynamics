function [corrM]  = thetaCorr(session,str)
    load('D:\Matlab\Billel\indexing.mat')
    load('Z:\All-Rats\Structures\structures.mat')
    
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);
    session = char(session);
    
    cd(session)
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
    load('States.mat')
    
    lfp.rem = GetLFP(13,'restrict',Rem);
    
    [peaks,troughs] = DetectOscillationPeaks(lfp.rem);
    spks.all = GetSpikes('output','full');
    spks.rem.all = Restrict(spks.all,Rem);
    
    str = eval(str);
    str = str(str(:,1)==rat,:);
    Hpc = Hpc(Hpc(:,1)==rat,:);
    
    spks.rem.hpc = spks.rem.all(ismember(spks.rem.all(:,2:3),Hpc(:,2:3),'rows'),:);
    spks.rem.str = spks.rem.all(ismember(spks.rem.all(:,2:3),str(:,2:3),'rows'),:);
    
    spks.rem.hpc = SpksId(spks.rem.hpc);
    spks.rem.str = SpksId(spks.rem.str);
    
    
    [binMatrix_peaks_hpc] = BinArround(spks.rem.hpc,peaks.times(:,1));
    zMatrix_Peaks_hpc = zscore(binMatrix_peaks_hpc,0,2);
    
    [binMatrix_peaks_str] = BinArround(spks.rem.str,peaks.times(:,1));
    zMatrix_Peaks_str = zscore(binMatrix_peaks_str,0,2);
    
    
    [binMatrix_Troughs_hpc] = BinArround(spks.rem.hpc,troughs.times(:,1));
    zMatrix_Troughs_hpc = zscore(binMatrix_Troughs_hpc,0,2);
    
    [binMatrix_Troughs_str] = BinArround(spks.rem.str,troughs.times(:,1));
    zMatrix_Troughs_str = zscore(binMatrix_Troughs_str,0,2);
    
    [corrM_Peaks pPeaks] = corr(zMatrix_Peaks_hpc',zMatrix_Peaks_str');
    figure;
    imagesc(corrM_Peaks)
    title('Peaks')
    clim([-0.04 0.04])
    
    [corrM_Troughs pTroughs] = corr(zMatrix_Troughs_hpc',zMatrix_Troughs_str');
    figure;
    imagesc(corrM_Troughs)
    title('Troughs')
    clim([-0.04 0.04])
     
    
%     [binMatrix_peaks] = BinArround(spks.rem,peaks.times(:,1));
%     zMatrix_peaks = zscore(binMatrix_peaks,0,2);
%     [corrM_Peaks pPeaks] = corr(zMatrix_peaks');
%     figure;
%     imagesc(corrM_Peaks)
%     title('Peaks')
%     clim([-0.1 0.1])
%     
%     [binMatrix_Troughs] = BinArround(spks.rem,troughs.times(:,1));
%     zMatrix_Troughs = zscore(binMatrix_Troughs,0,2);
%     [corrM_Troughs pTroughs] = corr(zMatrix_Troughs');
%     figure;
%     imagesc(corrM_Troughs)
%     title('Troughs')
%     clim([-0.1 0.1])
    

end
