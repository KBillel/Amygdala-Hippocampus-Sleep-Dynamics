function [binned events] = GetBinnedSpikes(session,str,type)
%Author : Billel Khouader
%GetBinnedSpikes : This function returns binned spikes for an entire
%session with metadata for strct you want. 

load('D:\Matlab\Billel\indexing.mat')
session = string(session);
index = ratsessionindex(xmlpath == session,:);

rat = index(1);
jour = index(2);
session = char(session);
load('Z:\All-Rats\Structures\structures.mat')
str = eval(str);

if strcmp(type,'pyr')
    type = 1;
else
    type = 2;
end

load('Z:\All-Rats\AllRats-FinalType.mat')

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')
perTransition = [];

spks = GetSpikes('output','full'); %GetAllSpikes

z = [];

spks(spks(:,3)==0 | spks(:,3) == 1,:) = [];
[units,~,i] = unique(spks(:,2:3),'rows');
spks(:,4) = i;

%rename the neurons with easier indexing


str_spks = spks(ismember(spks(:,2),str(str(:,1)==rat & str(:,2)==jour,3),'rows'),:);
%Only keep spks that are in the structures we care

finalType_pyr = finalType(ismember(finalType(:,[1 2 5]),[rat jour type],'rows'),:);
finalType_pyr_str = finalType_pyr(ismember(finalType_pyr(:,3),str_spks(:,2),'rows'),:);
%In final type, only keep neurons from str and the right type.

spks_pyr_str = spks(ismember(spks(:,2:3),finalType_pyr_str(:,3:4),'rows'),:);
%In spks only keep neurons in the CleanFinalType (Str and Type)
tstop = spks_pyr_str(end,1);


binned = [];
binned.activity = [];
binned.metadata = [];
binned.metadatastr = ["Rat" "Jour" "Shank" "N" "Id" "Type"];
idx = unique(spks_pyr_str(:,4));
[~,t] = binspikes(spks_pyr_str(spks_pyr_str(:,4)==idx(1),1),10,[0 tstop]);

for i = 1:length(idx)
    binned.metadata = [binned.metadata ; [rat jour unique(spks_pyr_str(spks_pyr_str(:,4) == idx(i),2:4),'rows') type]];
    binned.activity = [binned.activity ; binspikes(spks_pyr_str(spks_pyr_str(:,4)==idx(i),1),10,[0 tstop])'];
    %For each neurons, bin spikes from strat to stop of transition
    %epoch
end

%binned.activity = zscore(binned.activity')';
binned.t = t;
% events = [Rem(Rem(:,2)-Rem(:,1)>50,1)]; %Only keep events when Rem was longer than 50s
events = [];

for i=1:length(sws(:,1))
    in = sws(i,2)+50;
    for j = 1:length(Rem(:,1))
        if (Rem(j,1)<in) & (in<Rem(j,2))
            events = [events ; sws(i,1) Rem(j,1) Rem(j,2)];
        end
    end
    
end




    
    
    