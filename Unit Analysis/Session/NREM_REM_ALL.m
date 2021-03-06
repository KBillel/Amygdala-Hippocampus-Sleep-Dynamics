function [binned events] = NREM_REM_ALL(session)
%Author : Khouader Billel
%BinNormalized : This function returns binned spikes for an entire
%session with metadata for strct you want. 
%Var: 
%Session : Path to the session


keep = 0;


nSWS = 30;
nREM = 12;

load('D:\Matlab\Billel\indexing.mat')
load('Z:\All-Rats\Billel\AllNeurons.mat')
index = ratsessionindex(xmlpath == session,:);

rat = index(1);
jour = index(2);
session = char(session);

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')

perTransition = [];

spks = GetSpikes('output','full'); %GetAllSpikes

spks = SpksId(spks);

%rename the neurons with easier indexing


%Only keep spks from cells in type_str.
spks_type_str = spks;

if isempty(spks_type_str)
    return
end

tstop = spks_type_str(end,1);

events = [];

for i=1:length(sws(:,1))
    if (sws(i,2)-sws(i,1)>50)
        in = sws(i,2)+2;
        for j = 1:length(Rem(:,1))
            if ((Rem(j,1)<in) & (in<Rem(j,2)) & Rem(j,2)-Rem(j,1) > 50)                      
                events = [events ; sws(i,1) sws(i,2) Rem(j,1) Rem(j,2)];
            end
        end  
    end  
end

if isempty(events)
    return
end


binned = [];
binned.activity = [];
binned.metadata = [];
binned.metadatastr = ["Rat" "Jour" "Shank" "N" "Id" "Type"];
idx = unique(spks_type_str(:,4));
% [~,t] = binspikes(spks_pyr_str(spks_pyr_str(:,4)==idx(1),1),10,[0 tstop]);
% 
% for i = 1:length(idx)
%     binned.metadata = [binned.metadata ; [rat jour unique(spks_pyr_str(spks_pyr_str(:,4) == idx(i),2:4),'rows') type]];
%     binned.activity = [binned.activity ; binspikes(spks_pyr_str(spks_pyr_str(:,4)==idx(i),1),10,[0 tstop])'];
%     %For each neurons, bin spikes from strat to stop of transition
%     %epoch
% end

for i = 1:length(idx)
        type = 555; %not working
%         type = x.type(ismember(x.ident,spks_type_str(:,1:4),'rows'));
%         if strcmp(lower(type),'pyr')
%             type = 1;
%         else
%             type = 2;
%         end
        binned.metadata = [binned.metadata ; [rat jour unique(spks_type_str(spks_type_str(:,4) == idx(i),2:4),'rows') type]];
    for j = 1:size(events,1)
        
        SWS_L = (events(j,2)-events(j,1))/nSWS;
        REM_L = (events(j,4)-events(j,3))/nREM;
        
        SWS_Activity = Bin(spks_type_str(spks_type_str(:,4)==idx(i),1),[events(j,1) events(j,2)],nSWS,'trim')';
        SWS_Activity(isnan(SWS_Activity)) = [];
        SWS_FR = Accumulate(SWS_Activity)/SWS_L';
        
        if length(SWS_FR)~= nSWS
            SWS_FR(length(SWS_FR)+1:nSWS,1) = 0;
        end
        
        
        REM_Activity = Bin(spks_type_str(spks_type_str(:,4)==idx(i),1),[events(j,3) events(j,4)],nREM,'trim')';
        REM_Activity(isnan(REM_Activity)) = [];
        REM_FR = Accumulate(REM_Activity)/REM_L;
        
        if length(REM_FR)~= nREM
            REM_FR(length(REM_FR)+1:nREM,1) = 0;
        end
        
        binned.activity(:,i,j) = [SWS_FR' REM_FR'];
    end
end

if keep == 1
    mkdir('Billel/Transitions')
    cd('Billel/Transitions')

    save('NREM_REM_ALL','binned','events')
end




%binned.activity = zscore(binned.activity')';
%binned.t = t;
% events = [Rem(Rem(:,2)-Rem(:,1)>50,1)]; %Only keep events when Rem was longer than 50s

