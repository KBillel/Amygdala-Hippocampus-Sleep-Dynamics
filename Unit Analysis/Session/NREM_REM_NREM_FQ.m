function [binned events] = NREM_REM_NREM(session,str,type,keep)
%Author : Khouader Billel
%BinNormalized : This function returns binned spikes for an entire
%session with metadata for strct you want. 

% EN COURS : Ajouter calcul power fq
 
type_name = type;
str_name = str;
if strcmp(type,'pyr')
    type = 1;
else
    type = 2;
end


nSWS = 30;
nREM = 10;

load('D:\Matlab\Billel\indexing.mat')
index = ratsessionindex(xmlpath == session,:);

rat = index(1);
jour = index(2);
session = char(session);
load('Z:\All-Rats\Structures\structures.mat')
str = eval(str);


load('Z:\All-Rats\Structures\structures.mat')
load('Z:\All-Rats\AllRats-FinalType.mat')

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')

perTransition = [];

spks = GetSpikes('output','full'); %GetAllSpikes

spks = SpksId(spks);

%rename the neurons with easier indexing


str_spks = spks(ismember(spks(:,2),str(str(:,1)==rat & str(:,2)==jour,3),'rows'),:);
%Only keep spks that are in the structures we care

finalType_type = finalType(ismember(finalType(:,[1 2 5]),[rat jour type],'rows'),:);
finalType_type_str = finalType_type(ismember(finalType_type(:,3),str_spks(:,2),'rows'),:);
%In final type, only keep neurons from str and the right type.

spks_type_str = spks(ismember(spks(:,2:3),finalType_type_str(:,3:4),'rows'),:);
%In spks only keep neurons in the CleanFinalType (Str and Type)
tstop = spks_type_str(end,1);

events = [];

for i=1:length(sws(:,1))
    if (sws(i,2)-sws(i,1)>50)
        in = sws(i,2)+2;
        for j = 1:length(Rem(:,1))
            if ((Rem(j,1)<in) & (in<Rem(j,2)) & Rem(j,2)-Rem(j,1) > 50)
                in2 = Rem(j,2) + 2;
                if length(sws(:,1)) ~= i
                    if (sws(i+1,1)<in2) & (in2<sws(i+1,2) & (sws(i+1,2)-sws(i+1,1)>50))
                        events = [events ; sws(i,1) sws(i,2) Rem(j,1) Rem(j,2) sws(i+1,1) sws(i+1,2)];
                    end
                end
            end
        end  
    end  
end



power = [];

binned = [];
binned.activity = [];
binned.power = [];
binned.remlength=[];
binned.metadata = [];
binned.metadatastr = ["Rat" "Jour" "Shank" "N" "Id" "Type"];
idx = unique(spks_type_str(:,4));
binned.power = [];
% [~,t] = binspikes(spks_pyr_str(spks_pyr_str(:,4)==idx(1),1),10,[0 tstop]);
% 
% for i = 1:length(idx)
%     binned.metadata = [binned.metadata ; [rat jour unique(spks_pyr_str(spks_pyr_str(:,4) == idx(i),2:4),'rows') type]];
%     binned.activity = [binned.activity ; binspikes(spks_pyr_str(spks_pyr_str(:,4)==idx(i),1),10,[0 tstop])'];
%     %For each neurons, bin spikes from strat to stop of transition
%     %epoch
% end

for i = 1:length(idx)
        binned.metadata = [binned.metadata ; [rat jour unique(spks_type_str(spks_type_str(:,4) == idx(i),2:4),'rows') type]];
    for j = 1:size(events,1)
        
        SWS_L = (events(j,2)-events(j,1))/nSWS;
        REM_L = (events(j,4)-events(j,3))/nREM;
        SWS_L2 = (events(j,6)-events(j,5))/nSWS;
        
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
        
        SWS_Activity2 = Bin(spks_type_str(spks_type_str(:,4)==idx(i),1),[events(j,5) events(j,6)],nSWS,'trim')';
        SWS_Activity2(isnan(SWS_Activity2)) = [];
        SWS_FR2 = Accumulate(SWS_Activity2)/SWS_L2';
        
        if length(SWS_FR2)~= nSWS
            SWS_FR2(length(SWS_FR2)+1:nSWS,1) = 0;
        end
        
        binned.activity(:,i,j) = [SWS_FR' REM_FR' SWS_FR2'];
        
    end
end

for j = 1:size(events,1)
    lfp = GetLFP(str2double(GetRippleChannel),'restrict',[events(j,3) events(j,4)]);
    [spectre,f] = MTSpectrum(Detrend(lfp),'range',[0 100]);

    binned.power = [binned.power ; spectre];
    binned.f = f;
    binned.remlength = [binned.remlength ;events(j,4)-events(j,3)];
end

binned.swsPower = [];
for i = 1:size(sws,1)
    lfp = GetLFP(str2double(GetRippleChannel),'restrict',[sws(i,1) sws(i,2)]);
    [spectre,f] = MTSpectrum(Detrend(lfp),'range',[0 100]);
    binned.swsPower = [binned.swsPower ; spectre];
end

[z, mu,std] = zscore(binned.swsPower);
binned.remPower = (binned.power-mu)./std;

if keep == 1
    mkdir('Billel/Transitions')
    cd('Billel/Transitions')

    save(['NREM_REM_NREM_FQ_' str_name '_' type_name],'binned','events')
end




%binned.activity = zscore(binned.activity')';
%binned.t = t;
% events = [Rem(Rem(:,2)-Rem(:,1)>50,1)]; %Only keep events when Rem was longer than 50s

