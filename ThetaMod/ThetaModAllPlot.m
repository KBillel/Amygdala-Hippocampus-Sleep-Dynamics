load('Z:\All-Rats\Structures\structures.mat')
load('Z:\All-Rats\Billel\Theta\ThetaModAll.mat')

bla_hpcmod = (stats.hpc.p<0.01 & stats.hpc.r >0.04 & ismember(metadata.hpc(:,1:3),BLA(:,1:3),'rows')');
hpc_hpcmod = (stats.hpc.p<0.01 & stats.hpc.r >0.04 & ismember(metadata.hpc(:,1:3),Hpc(:,1:3),'rows')');
% amy_hpcmod = (stats.hpc.p<0.01 & stats.hpc.r >0.04 & ismember(metadata.hpc(:,1:3),amy(:,1:3),'rows')');

bla_blamod = (stats.bla.p<0.01 & stats.bla.r >0.04 & ismember(metadata.bla(:,1:3),BLA(:,1:3),'rows')');
hpc_blamod = (stats.bla.p<0.01 & stats.bla.r >0.04 & ismember(metadata.bla(:,1:3),Hpc(:,1:3),'rows')');
% amy_blamod = (stats.bla.p<0.01 & stats.bla.r >0.04 & ismember(metadata.bla(:,1:3),amy(:,1:3),'rows')');


phasePlot(stats.hpc.m(hpc_hpcmod))
phasePlot(stats.bla.m(hpc_blamod))
phasePlot(stats.hpc.m(bla_hpcmod))
phasePlot(stats.bla.m(bla_blamod))
% phasePlot(stats.hpc.m(amy_hpcmod))
% phasePlot(stats.bla.m(amy_blamod))



function phasePlot(stats)
    figure;
    hold;
    histogram(rad2deg(stats),'BinWidth',10,'Normalization','probability','FaceColor','b')
    histogram(rad2deg(stats)+360,'BinWidth',10,'Normalization','probability','FaceColor','b')
    histogram(rad2deg(stats)+720,'BinWidth',10,'Normalization','probability','FaceColor','b')
    xlim([0 720])
end