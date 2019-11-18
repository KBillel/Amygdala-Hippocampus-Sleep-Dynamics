% TimeNormalizedHPCINT.activity = []
% TimeNormalizedHPCINT.metadata = []
% TimeNormalizedHPCINT.metadatastr = ["Rat","Jour","Shank","N","Id","Type"]
% for i = 1:length(HPC_INT)
%     TimeNormalizedHPCINT.activity = [TimeNormalizedHPCINT.activity ; HPC_INT{i}.activity(:,:)]
%     TimeNormalizedHPCINT.metadata = [TimeNormalizedHPCINT.metadata ; HPC_INT{i}.metadata]
% end
% 
% HPC_INT = StartBatch('D:\Matlab\Billel\Function\BinNormalized.m','D:\Matlab\Billel\Batch\GetSyncSpikesHPCPyr.batch')
% HPC_INT = StartBatch('D:\Matlab\Billel\Function\BinNormalized.m','D:\Matlab\Billel\Batch\GetSyncSpikesHPCInt.batch')
% BLA_PYR = StartBatch('D:\Matlab\Billel\Function\BinNormalized.m','D:\Matlab\Billel\Batch\GetSyncSpikesBLAPyr.batch')
% BLA_INT = StartBatch('D:\Matlab\Billel\Function\BinNormalized.m','D:\Matlab\Billel\Batch\GetSyncSpikesBLAInt.batch')

% input = BLA_PYR;
% 
% BLA_PYR_ALL.activity = [];
% BLA_PYR_ALL.metadata = [];
% BLA_PYR_ALL.metadatastr = HPC_PYR{1}.metadatastr;
% for i = 1:length(input)
% input{i}.mean_activity = mean(input{i}.activity,3)'
% BLA_PYR_ALL.activity = [BLA_PYR_ALL.activity ; input{i}.mean_activity]
% BLA_PYR_ALL.metadata = [BLA_PYR_ALL.metadata ; input{i}.metadata]
% end
figure;
hold
plot((mean(Q_BLA_PYR_ALL{1}.activity)/Q_BLA_PYR_ALL{1}.norm)*100)
plot((mean(Q_BLA_PYR_ALL{2}.activity)/Q_BLA_PYR_ALL{2}.norm)*100)
plot((mean(Q_BLA_PYR_ALL{3}.activity)/Q_BLA_PYR_ALL{3}.norm)*100)
plot((mean(Q_BLA_PYR_ALL{4}.activity)/Q_BLA_PYR_ALL{4}.norm)*100)
plot((mean(Q_BLA_PYR_ALL{5}.activity)/Q_BLA_PYR_ALL{5}.norm)*100)
plot((mean(BLA_INT_ALL.activity)/BLA_INT_ALL.norm)*100)
