function [spectrum,f] = SpikeSpectrum (session,str,type,keep)
type_name = type;
str_name = str;
if strcmp(type,'pyr')
    type = 1;
else
    type = 2;
end

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

spks = GetSpikes('output','full'); %GetAllSpikes
%rename the neurons with easier indexing
spks = SpksId(spks);

%Only keep spks that are in the structures we care
str_spks = spks(ismember(spks(:,2),str(str(:,1)==rat & str(:,2)==jour,3),'rows'),:);

%In final type, only keep neurons from str and the right type.
finalType_type = finalType(ismember(finalType(:,[1 2 5]),[rat jour type],'rows'),:);
finalType_type_str = finalType_type(ismember(finalType_type(:,3),str_spks(:,2),'rows'),:);

%In spks only keep neurons in the CleanFinalType (Str and Type)
spks_type_str = spks(ismember(spks(:,2:3),finalType_type_str(:,3:4),'rows'),:);

spks_rem = Restrict(spks_type_str,Rem);
spks_sws = Restrict(spks_type_str,sws);
[spectrogram.rem,t,f.rem] = MTSpectrogrampt(spks_rem(:,1));
[spectrogram.sws,t,f.sws] = MTSpectrogrampt(spks_sws(:,1));

spectrum.rem = nanmean(spectrogram.rem);
spectrum.sws = nanmean(spectrogram.sws);

if keep == 1
    mkdir('Billel/SpikeSpectrum')
    cd('Billel/SpikeSpectrum')

    save(['Pop' str_name '_' type_name],'spectrum','f')
end


    
    