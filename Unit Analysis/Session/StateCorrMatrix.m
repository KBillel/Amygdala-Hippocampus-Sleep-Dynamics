function [outputArg1,outputArg2] = StateCorrMatrix(session,str,pre,post,binSize)
%STATECORRMATRIX Calculate CorrMatrix between str and hpc for differente
%brain state and save them in a variable
%CorrMatrix
%   - pre
%       -theta/thetaPeaks/thetaTroughs
%   - run
%       -run/runPeaks/runTroughs
%   - post
%       -theta/thetaPeaks/thetaTroughs

    

    load('D:\Matlab\Billel\indexing.mat')
    load('Z:\All-Rats\Structures\structures.mat')
    
    
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);
    session = char(session);
    
    cd(session)
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
    load('States.mat')
    load('runintervals.mat')
    
    % Get pre/post sleep intervals
    presleep=RunIntervals(pre);
    postsleep=RunIntervals(post);
    run=runintervals(2,:);
    
    % Load LFP and get detect peaks and troughs.
    lfp.all.rem = GetLFP(GetRippleChannel,'restrict',Rem);
    lfp.pre.rem = Restrict(lfp.all.rem(presleep));
    lfp.post.rem = Restrict(lfp.all.rem(postsleep));
    
    [peaks.pre,troughs.pre] = DetectOscillationPeaks(lfp.rem.pre);
    [peaks.post,troughs.post] = DetectOscillationPeaks(lfp.rem.post);
    
    % Load str.
    str = eval(str);
    str = str(str(:,1)==rat,:);
    Hpc = Hpc(Hpc(:,1)==rat,:);
    
    % Load spikes and sort them pre/run/post
    spks.all = GetSpikes('output','full');
    
    %HPC
    spks.hpc.all = spks.all(ismember(spks.all(:,2:3),Hpc(:,2:3),'rows'),:);
    spks.hpc.all = SpksId(spks.hpc.all);
    spks.hpc.pre.all = Restrict(spks.hpc.all,presleep); 
    spks.hpc.post.all = Restrict(spks.hpc.all,postsleep);
    spks.hpc.pre.rem = Restrict(spks.hpc.pre.all,Rem);
    spks.hpc.post.rem = Restrict(spks.hpc.post.all,Rem);
    spks.hpc.run = Restrict(spks.hpc.all,run);
    
    %STR
    spks.str.all = spks.all(ismember(spks.all(:,2:3),str(:,2:3),'rows'),:);
    spks.str.all = SpksId(spks.str.all);
    spks.str.pre.all = Restrict(spks.str.all,presleep); 
    spks.str.post.all = Restrict(spks.str.all,postsleep);
    spks.str.pre.rem = Restrict(spks.str.pre.all,Rem);
    spks.str.post.rem = Restrict(spks.str.post.all,Rem);
    spks.str.run = Restrict(spks.str.all,run);

    
    %MConstruction of zSpikeMatrix:
    %HPC:  
    [binMatrix.hpc.pre.rem.peaks] = zscore(BinArround(spks.hpc.pre.rem,peaks.pre.times(:,1)),0,2);
    [binMatrix.hpc.pre.rem.troughs] = zscore(BinArround(spks.hpc.pre.rem,troughs.pre.times(:,1)),0,2);
    [binMatrix.hpc.run] = zscore(SpikeTrain([spks.hpc.run(:,1) spks.hpc.run(:,4)],binSize,[run(1,1) run(end,end)])',0,2);
    [binMatrix.hpc.post.rem.peaks] = zscore(BinArround(spks.hpc.post.rem,peaks.post.times(:,1)),0,2);
    [binMatrix.hpc.post.rem.troughs = zscore(BinArround(spks.hpc.post.rem,troughs.post.times(:,1)),0,2);
        
    %STR:
    [binMatrix.str.pre.rem.peaks] = zscore(BinArround(spks.str.pre.rem,peaks.pre.times(:,1)),0,2);
    [binMatrix.str.pre.rem.troughs] = zscore(BinArround(spks.str.pre.rem,troughs.pre.times(:,1)),0,2);
    [binMatrix.str.run] = zscore(SpikeTrain([spks.str.run(:,1) spks.str.run(:,4)],binSize,[run(1,1) run(end,end)])',0,2);
    [binMatrix.str.post.rem.peaks] = zscore(BinArround(spks.str.post.rem,peaks.post.times(:,1)),0,2);
    [binMatrix.str.post.rem.troughs = zscore(BinArround(spks.str.post.rem,troughs.post.times(:,1)),0,2);
    
    [CorrMatrix.pre.rem.peaks.matrix,CorrMatrix.pre.peaks.pval] = corr(binMatrix.hpc.pre.rem.peaks,binMatrix.str.pre.rem.peaks);
    [CorrMatrix.pre.rem.troughs.matrix,CorrMatrix.pre.troughs.pval] = corr(binMatrix.hpc.pre.rem.troughs,binMatrix.str.pre.rem.troughs);
    [CorrMatrix.run.rem.matrix,CorrMatrix.run.pval] = corr(binMatrix.hpc.run',binMatrix.str.run');
    [CorrMatrix.post.rem.peaks.matrix,CorrMatrix.post.peaks.pval] = corr(binMatrix.hpc.post.rem.peaks,binMatrix.str.post.rem.peaks);
    [CorrMatrix.post.rem.troughs.matrix,CorrMatrix.post.troughs.pval] = corr(binMatrix.hpc.post.rem.troughs,binMatrix.str.post.rem.troughs);
end
    

