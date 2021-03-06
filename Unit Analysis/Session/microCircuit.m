function [] = microCircuit(session,nmin)
    
    
    load('D:\Matlab\Billel\indexing.mat')
    index = ratsessionindex(xmlpath == session,:);

    rat = index(1);
    jour = index(2);
    session = char(session);
    load('Z:\All-Rats\Structures\structures.mat')
    load('Z:\All-Rats\AllRats-FinalType.mat')
    load('Z:\All-Rats\Billel\NREM-REM\NREM_REM_ALL_Pooled.mat')
    
    cd(session)
    %SetCurrentSession([session '\' session(end-13:end) '.xml']);
   
    load([session(end-13:end) '-MonoSynConvClick.mat'])
    load('States.mat')

    for i = 1:size(FinalExcCellList,1)
        shank = FinalExcCellList(i,1);
        clu = FinalExcCellList(i,2);
        
        post_syn = FinalExcMonoSyn(ismember(FinalExcMonoSyn(:,1:2),[shank clu],'rows'),3:4)
       
        n_post = size(post_syn,1);
        
        if n_post < nmin
            break
        end
        pre_activity = NREM_REM_ALL_Pooled.activity(ismember(NREM_REM_ALL_Pooled.metadata(:,1:4),[rat jour shank clu],'rows'),:);
        
        post_activity = NREM_REM_ALL_Pooled.activity(ismember(NREM_REM_ALL_Pooled.metadata(:,1:4),[repmat([rat jour],n_post,1) post_syn],'rows'),:);
        figure;    
        plot(zscore(pre_activity'),'col','red','LineWidth',3)
        hold
        plot(zscore(post_activity'),'col','black')
        title(['CellExt shank:' num2str(shank) 'clue:' num2str(clu)])

    end
    
    
    for i = 1:size(FinalInhCellList,1)
        shank = FinalInhCellList(i,1);
        clu = FinalInhCellList(i,2);
        
        post_syn = FinalInhMonoSyn(ismember(FinalInhMonoSyn(:,1:2),[shank clu],'rows'),3:4)
        n_post = size(post_syn,1);
        if n_post < nmin
            break
        end
        
        pre_activity = NREM_REM_ALL_Pooled.activity(ismember(NREM_REM_ALL_Pooled.metadata(:,1:4),[rat jour shank clu],'rows'),:);
        
        post_activity = NREM_REM_ALL_Pooled.activity(ismember(NREM_REM_ALL_Pooled.metadata(:,1:4),[repmat([rat jour],n_post,1) post_syn],'rows'),:);
        figure;
        plot(zscore(pre_activity'),'col','red','LineWidth',3)
        hold
        plot(Smooth(post_activity,[0 0])','col','black')
        PlotIntervals([31 42])
        title(['CellInh shank:' num2str(shank) 'clue:' num2str(clu)])
    end
end

