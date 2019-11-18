function [binned events] = REM(session,str,type,keep)
    type_name = type;
    str_name = str;
    if strcmp(type,'pyr')
        type = 1;
    else
        type = 2;
    end
    
    nREM = 12;
    
    load('D:\Matlab\Billel\indexing.mat')
    index = ratsessionindex(xmlpath == session,:);

    rat = index(1);
    jour = index(2);
    session = char(session);
    load('Z:\All-Rats\Structures\structures.mat')
    str = eval(str);
    
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
    
    for i=1:length(Rem(:,1))
        if (Rem(i,2)-Rem(i,1)>50)
            events = [events ;  Rem(i,1) Rem(i,2)];
        end
    end
    
    binned = [];
    binned.activity = [];
    binned.metadata = [];
    binned.metadatastr = ["Rat" "Jour" "Shank" "N" "Id" "Type"];
    idx = unique(spks_type_str(:,4));
    
    for i = 1:length(idx)
        binned.metadata = [binned.metadata ; [rat jour unique(spks_type_str(spks_type_str(:,4) == idx(i),2:4),'rows') type]];
        for j = 1:size(events,1)
            
            REM_L = (events(j,2)-events(j,1))/nREM;
            REM_Activity = Bin(spks_type_str(spks_type_str(:,4)==idx(i),1),[events(j,1) events(j,2)],nREM,'trim')';
            REM_Activity(isnan(REM_Activity)) = [];
            REM_FR = Accumulate(REM_Activity)/REM_L';

            if length(REM_FR)~= nREM
                REM_FR(length(REM_FR)+1:nREM,1) = 0;
            end
            
            binned.activity(:,i,j) = [REM_FR'];
        end
    end
    
    
    if keep == 1
        mkdir('Billel/Transitions')
        cd('Billel/Transitions')

        save(['REM_' str_name '_' type_name],'binned','events')
    end

    
end