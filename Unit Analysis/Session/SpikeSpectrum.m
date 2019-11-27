function [spectrum,f] = SpikeSpectrum (session,str,type,keep)

type_name = type;
str_name = str;
if strcmp(lower(type),'pyr')
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
load('Z:\All-Rats\Billel\Theta\ThetaModulatedCells.mat')
str = eval(str);


load('Z:\All-Rats\AllRats-FinalType.mat')

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml']);
load('States.mat')

spks = GetSpikes('output','full'); %GetAllSpikes
%rename the neurons with easier indexing
spks = SpksId(spks);

%In finalType only keep neurons with good [Rat Jour Type] & [Shank] in the
%right str.
if size(str,2)==4
    type_str = finalType(ismember(finalType(:,[1 2 5]),[rat jour type],'rows') & ismember(finalType(:,3:4),str(str(:,1)==rat & str(:,2)==jour,3:4),'rows'),:);
else
    type_str = finalType(ismember(finalType(:,[1 2 5]),[rat jour type],'rows') & ismember(finalType(:,3),str(str(:,1)==rat & str(:,2)==jour,3),'rows'),:);
end

%Only keep spks from cells in type_str.
spks_type_str = spks(ismember(spks(:,2:3),type_str(:,3:4),'rows'),:);



spks_rem = Restrict(spks_type_str,Rem);
spks_sws = Restrict(spks_type_str,sws);
if ~isempty(spks_type_str)
    [spectrogram.rem,t,f.rem] = MTSpectrogrampt(spks_rem(:,1));
    [spectrogram.sws,t,f.sws] = MTSpectrogrampt(spks_sws(:,1));
end
spectrum.rem = nanmean(spectrogram.rem);
spectrum.sws = nanmean(spectrogram.sws);

if keep == 1
    mkdir('Billel/SpikeSpectrum')
    cd('Billel/SpikeSpectrum')

    save(['Pop' str_name '_' type_name],'spectrum','f')
end


    
    