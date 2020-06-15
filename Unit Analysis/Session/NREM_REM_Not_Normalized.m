function [binned events] = NREM_REM_Not_Normalized(session,window)
  
    load('D:\Matlab\Billel\indexing.mat')
    load('Z:\All-Rats\AllRats-FinalType.mat')
    
    index = ratsessionindex(xmlpath == session,:);
    
    rat = index(1);
    jour = index(2);
    session = char(session);
    
    cd(session)
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
    load('States.mat')
    
    
    spks = GetSpikes('output','full'); %GetAllSpikes
    spks = SpksId(spks);

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
    
    neurons =  [];
    neurons.activity = [];
    neurons.metadata = [];
    neurons.metadatastr = ["Rat" "Jour" "Shank" "N" "Id" "Type"];
    idx = unique(spks(:,4));
    
    for i = 1:length(idx)
        shank = unique(spks(spks(:,4) == idx(i),2));
        clu = unique(spks(spks(:,4) == idx(i),3));
        type = finalType(ismember(finalType(:,1:4),[rat jour shank clu],'rows'),5);
        
        metadata = [rat jour shank clu idx(i) type];
       neurons.metadata = [neurons.metadata ; metadata];
       
       for j = 1:size(events,1)
           disp(metadata)
           disp(events(j,:))
       end
       
       
    end
        
end

