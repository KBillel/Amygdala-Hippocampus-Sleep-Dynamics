function [] = PlotNeuronPhase(spks,lfp,band)
    spks = spks(spks(:,1)<lfp(end,1),:);
    spks = spks(spks(:,1)<lfp(end,1),:);
    
    [phase,amplitude,unwrapped] = Phase(FilterLFP(lfp,'passband',band),spks(:,1));
    [dist,binned,stats] = CircularDistribution(phase(:,2));
    figure;
    PlotCircularDistribution(dist);
    disp(stats)
end