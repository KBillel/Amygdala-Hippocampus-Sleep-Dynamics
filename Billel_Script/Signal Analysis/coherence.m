function [coh,f] = coherence(session,channel_HPC,channel_BLA,range)



load('D:\Matlab\Billel\indexing.mat')
index = ratsessionindex(xmlpath == session,:);

rat = index(1);
jour = index(2);
session = char(session);
load('Z:\All-Rats\Structures\structures.mat')
load('Z:\All-Rats\AllRats-FinalType.mat')

cd(session)
% if exist('Billel/Coherence/coherence.mat')
%  load('coherence.mat')
%  return
% end

SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')


coh.rem = 0;
coh.run = 0;

load('States.mat');
load('runintervals.mat')

[trackruntimes,trackquiettimes] = getTrackTimes(runintervals);


remLFP_BLA = GetLFP(channel_BLA,'restrict',Rem);
remLFP_BLA(:,1) = 1:size(remLFP_BLA); 
remLFP_HPC = GetLFP(channel_HPC,'restrict',Rem);
remLFP_HPC(:,1) = 1:size(remLFP_HPC); 

runLFP_BLA = GetLFP(channel_BLA,'restrict',trackruntimes);
runLFP_BLA(:,1) = 1:size(runLFP_BLA); 
runLFP_HPC = GetLFP(channel_HPC,'restrict',trackruntimes);
runLFP_HPC(:,1) = 1:size(runLFP_HPC); 




[coh.rem,phase,f] = MTCoherence(remLFP_BLA,remLFP_HPC,'range',range,'frequency',1250);
[coh.run,phase,f] = MTCoherence(runLFP_BLA,runLFP_HPC,'range',range,'frequency',1250);


mkdir('Billel/Coherence');
cd('Billel/Coherence');
save('coherence.mat','coh');