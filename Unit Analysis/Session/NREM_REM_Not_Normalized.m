function [neurons, events] = NREM_REM_Not_Normalized(session,binSize,windowSize,keep)

    
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
% This loop is to exctract from the data NREM-REM transition checking for 
% REM > 50s
% SMS> 50s
% No interval between NREM and REM epochs (less than 2s)
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
    
    
    
    nBin = windowSize/binSize;
    nBin = floor(nBin);
    if nBin ~= windowSize/binSize
        disp(['Could not make ' num2str(binSize) 's bins because of the size of the windows'])
        binSize = windowSize/nBin;
        disp(['Using ' num2str(binSize) 's instead'])
    end
    
    
    neurons =  [];
    neurons.activity = [];
    neurons.metadata = [];
    neurons.metadatastr = ["Rat" "Jour" "Shank" "N" "Id" "Type"];
    neurons.windowSize = windowSize;
    neurons.binSize = binSize;
    neurons.nBin = nBin;
    
    idx = unique(spks(:,4));
    
    

    
    for i = 1:length(idx)
        shank = unique(spks(spks(:,4) == i,2));
        clu = unique(spks(spks(:,4) == i,3));
        type = finalType(ismember(finalType(:,1:4),[rat jour shank clu],'rows'),5);
        
        metadata = [rat jour shank clu i type];
        neurons.metadata = [neurons.metadata ; metadata];
       
        for j = 1:size(events,1)
%             disp(metadata);
%             disp(events(j,:));
           
            win = windowSize/2;
           
            start = events(j,2)-win;
            stop  = events(j,2)+win;
            
           
            activity = Bin(spks(spks(:,4) == i,1),[start stop],nBin,'trim')';
%             disp(activity) 
            activity(isnan(activity)) = [];
            firingRates = Accumulate(activity)/binSize';
            if length(firingRates)~= nBin
                firingRates(length(firingRates)+1:nBin,1) = 0;
            end
            
            neurons.activity(:,i,j) = firingRates;
           
        end
       
    end
    
    if keep == 1
        mkdir('Billel/Transitions')
        cd('Billel/Transitions')

        save('NREM_REM_Not_Normalized','neurons','events')
    end
end

