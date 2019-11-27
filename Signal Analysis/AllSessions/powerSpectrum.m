function [spectreREM, spectreRUN, spectreSWS,spectreQUIET,f] = powerSpectrumAll(sessions,channel,range,days)

spectreREM = [];
spectreRUN = [];
spectreSWS = [];
spectreQUIET = [];

y = 0;
y2 = 0;
y3 = 0;
y4 = 0;
for i = days
    cd(sessions(i,:))
    SetCurrentSession([sessions(i,:) '\' sessions(i,end-13:end) '.xml'],'spikes','off');
    load('States.mat');
    load('runintervals.mat')
%     if exist([sessions(i,end-13:end) '-TrackRunTimes.mat'])
    load([sessions(i,end-13:end) '-TrackRunTimes.mat']);
    load([sessions(i,end-13:end) '-QuietTimes.mat']);
%     
    [trackruntimes,trackquiettimes] = getTrackTimes(runintervals);
%     end

    remLFP = GetLFP(channel,'restrict',Rem);
    remLFP(:,1) = 1:size(remLFP); 
    runLFP = GetLFP(channel,'restrict',trackruntimes);
    runLFP(:,1) = 1:size(runLFP); 
    swsLFP = GetLFP(channel,'restrict',sws);
    swsLFP(:,1) = 1:size(swsLFP);
    quietLFP = GetLFP(channel,'restrict',trackquiettimes);
    quietLFP(:,1) = 1:size(quietLFP); 
    
%     remLFP(:,2) = zLFP(remLFP(:,2));
%     runLFP(:,2) = zLFP(runLFP(:,2));
%     swsLFP(:,2) = zLFP(swsLFP(:,2));
%     quietLFP(:,2) = zLFP(quietLFP(:,2));

    [y, frem]    = MTSpectrum(Detrend(remLFP),'frequency',1250,'range',range);
    [y2, frun]   = MTSpectrum(Detrend(runLFP),'frequency',1250,'range',range);
    [y3, fsws]   = MTSpectrum(Detrend(swsLFP),'frequency',1250,'range',range);
    [y4, fquiet] = MTSpectrum(Detrend(quietLFP),'frequency',1250,'range',range);
    
    spectreREM=[spectreREM;y];
    spectreRUN=[spectreRUN;y2];
    spectreSWS=[spectreSWS;y3];
    spectreQUIET=[spectreQUIET;y4];
    f = fquiet;
    
    disp(["Session " i "was treated correctly"])
end

figure; 
plot(frem,mean(spectreREM));
line(frun,mean(spectreRUN),'col','red');
line(frun,mean(spectreSWS),'col','green');
line(frun,mean(spectreQUIET),'col','black');
legend('REM','RUN','SWS','QUIET');
xlabel('Frequency');
ylabel('Power');
title('PowerSpectrum of REM&RUN&SWS&QUIET');