load('Z:\All-Rats\Structures\structures.mat')
% load('Z:\All-Rats\Billel\ThetaModAll.mat')

bla_blamod = (stats.bla.p<0.01 & stats.bla.r >0.04 & ismember(metadata(:,1:3),BLA(:,1:3),'rows')')
bla_hpcmod = (stats.hpc.p<0.01 & stats.hpc.r >0.04 & ismember(metadata(:,1:3),BLA(:,1:3),'rows')')

hpc_blamod = (stats.bla.p<0.01 & stats.bla.r >0.04 & ismember(metadata(:,1:3),Hpc(:,1:3),'rows')')
hpc_hpcmod = (stats.hpc.p<0.01 & stats.hpc.r >0.04 & ismember(metadata(:,1:3),Hpc(:,1:3),'rows')')

amy_blamod = (stats.bla.p<0.01 & stats.bla.r >0.04 & ismember(metadata(:,1:3),amy(:,1:3),'rows')')
amy_hpcmod = (stats.hpc.p<0.01 & stats.hpc.r >0.04 & ismember(metadata(:,1:3),amy(:,1:3),'rows')')

stats.bla

% figure;
% histogram(rad2deg(stats.bla.mode(bla_blamod)),'BinWidth',5);
% figure;
% histogram(rad2deg(stats.bla.mode(hpc_blamod)),'BinWidth',5);
% figure;
% histogram(rad2deg(stats.hpc.mode(hpc_hpcmod)),'BinWidth',5);
% figure;
% histogram(rad2deg(stats.hpc.mode(bla_hpcmod)),'BinWidth',5);
% title('BLA cells hpc theta mode')
% 
% figure;
% histogram(rad2deg(stats.bla.m(bla_blamod)),'BinWidth',5);
% figure;
% histogram(rad2deg(stats.bla.m(hpc_blamod)),'BinWidth',5);
% figure;
% histogram(rad2deg(stats.hpc.m(hpc_hpcmod)),'BinWidth',5);
% figure;
% histogram(rad2deg(stats.hpc.m(bla_hpcmod)),'BinWidth',5);
% title('BLA cells Hpc theta m')


% figure;
% histogram(rad2deg(stats.bla.m(amy_hpcmod)),'BinWidth',5);
% figure;
% histogram(rad2deg(stats.hpc.m(amy_hpcmod)),'BinWidth',5);
% title('Amy cells Hpc theta m')

figure;
histogram(rad2deg(stats.bla.mode(amy_hpcmod)),'BinWidth',10);
hold
figure
histogram(rad2deg(stats.hpc.mode(amy_hpcmod)),'BinWidth',10);
hold
histogram(rad2deg(stats.hpc.mode(amy_hpcmod))+360,'BinWidth',10);
title('Amy cells Hpc theta mode')