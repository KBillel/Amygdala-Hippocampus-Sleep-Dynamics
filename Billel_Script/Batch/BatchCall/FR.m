FR_BLA_PYR = StartBatch('D:\Matlab\Billel\Function\FRStates.m','D:\Matlab\Billel\Batch\GetSyncSpikes.batch');
FR_BLA_INT = StartBatch('D:\Matlab\Billel\Function\FRStates.m','D:\Matlab\Billel\Batch\GetSyncSpikesInt.batch');
FR_HPC_PYR = StartBatch('D:\Matlab\Billel\Function\FRStates.m','D:\Matlab\Billel\Batch\GetSyncSpikesHpcPyr.batch');
FR_HPC_INT = StartBatch('D:\Matlab\Billel\Function\FRStates.m','D:\Matlab\Billel\Batch\GetSyncSpikesHpcInt.batch');

FR_BLA_INT = GetBatch(FR_BLA_INT);
FR_BLA_PYR = GetBatch(FR_BLA_PYR);
FR_HPC_INT = GetBatch(FR_HPC_INT);
FR_HPC_PYR = GetBatch(FR_HPC_PYR);

FR_HPC_INT.Rem = [];
FR_HPC_INT.sws = [];
FR_HPC_INT.wake = [];

for i = 1:length(FR_HPC_Int)
    FR_HPC_INT.Rem = [FR_HPC_INT.Rem ;FR_HPC_Int{i}.Rem];
    FR_HPC_INT.sws= [FR_HPC_INT.sws ;FR_HPC_Int{i}.sws];
    FR_HPC_INT.wake = [FR_HPC_INT.wake ;FR_HPC_Int{i}.wake];
end

subplot(3,1,1)
sws = histogram(log(FR_HPC_PYR.sws),100,'FaceColor','red','FaceAlpha',0.5)
hold
subplot(3,1,2)
histogram(log(FR_HPC_PYR.wake),100,'FaceColor','green','FaceAlpha',0.5,'BinEdges',sws.BinEdges)
subplot(3,1,3)
histogram(log(FR_HPC_PYR.Rem),100,'FaceColor','blue','FaceAlpha',0.5,'BinEdges',sws.BinEdges)