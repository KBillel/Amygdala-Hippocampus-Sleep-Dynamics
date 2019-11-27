function [FR] = FRStates(session,str,type)
    %Author  : Billel Khouader
	%This function calculates firing in states in a given session
	% INPUT : session,str,type
	% OUTPUT : FR
	
	
	cd(session);
    load('States.mat')
    [binned events] = GetBinnedSpikes(session,str,type);
    
    RemL = sum(Rem(:,2)-Rem(:,1));
    swsL = sum(sws(:,2)-sws(:,1));
    wakeL = sum(wake(:,2)-wake(:,1));    
    
    FR.Rem = [];
    FR.sws = [];
    FR.wake = [];
    FR.metadata = [];
    FR.metadatastr = ["Rat" "Jour" "Shank" "N" "Id" "Type"];
    
    for i = 1:length(binned.metadata(:,1))
        FR.Rem = [FR.Rem ; sum(binned.activity(i,InIntervals(binned.t,Rem)))/RemL];
        FR.sws = [FR.sws ; sum(binned.activity(i,InIntervals(binned.t,sws)))/swsL];
        FR.wake = [FR.wake ; sum(binned.activity(i,InIntervals(binned.t,wake)))/wakeL];
        FR.metadata = [FR.metadata ; binned.metadata(i,:)];
    end 
    
end

