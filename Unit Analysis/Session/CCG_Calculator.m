function [t,ccg] = CCG_Calculator(session,pre,post)

load('D:\Matlab\Billel\indexing.mat')
load('States.mat')
load('D:\Matlab\Billel\EV_BLA_CROSS\HighContribCells.mat')
pairs = HighContrib;
index = ratsessionindex(xmlpath == session,:);

rat = index(1);
jour = index(2);
session = char(session);
load('Z:\All-Rats\Structures\structures.mat')
cd(session)
load([session(10:end) '-TrackRunTimes'])

if exist('Billel/HighContribCCG/Figs')
    rmdir('Billel/HighContribCCG/Figs','s')
end

if 1==1
    SetCurrentSession([session '\' session(end-13:end) '.xml']);    
    spks.all = GetSpikes('output','full');
    pairs = pairs(ismember(pairs(:,1:2),[rat jour],'rows'),:);
    spks.all = spks.all((ismember(spks.all(:,2:3),unique(pairs(:,3:4),'rows'),'rows') | ismember(spks.all(:,2:3),unique(pairs(:,5:6),'rows'),'rows')),:);
    spks.all = SpksId(spks.all);

    if isempty(pairs)
        return;
    end
    
    presleep  = RunIntervals(pre);
    postsleep = RunIntervals(post);

    spks.pre.all  = spks.all(spks.all(:,1)<presleep(2),:);
    spks.post.all = spks.all(spks.all(:,1)>postsleep(1),:);
    
    
    spks.pre.sws = spks.pre.all(InIntervals(spks.pre.all(:,1),sws),:);
    spks.pre.rem = spks.pre.all(InIntervals(spks.pre.all(:,1),Rem),:);
    spks.pre.run = spks.pre.all(InIntervals(spks.pre.all(:,1),trackruntimes),:);
    
    spks.post.sws = spks.post.all(InIntervals(spks.post.all(:,1),sws),:);
    spks.post.rem = spks.post.all(InIntervals(spks.post.all(:,1),Rem),:);
    spks.post.run = spks.post.all(InIntervals(spks.post.all(:,1),trackruntimes),:);
    
    % Fake spks - CCG needs all cells to have spks therefore we add fake
    % spks at 1s interval 
    spks.pre.sws = [(1:length(unique(spks.all(:,4))))' [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.pre.sws];
    spks.pre.rem = [(1:length(unique(spks.all(:,4))))' [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.pre.rem];
    spks.pre.run = [(1:length(unique(spks.all(:,4))))' [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.pre.run];
    spks.post.sws = [(1:length(unique(spks.all(:,4))))' [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.post.sws];
    spks.post.rem = [(1:length(unique(spks.all(:,4))))' [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.post.rem];
    spks.post.run = [(1:length(unique(spks.all(:,4))))' [zeros(length(unique(spks.all(:,4))),2) unique(spks.all(:,4))] ; spks.post.run];
    %Fake spks
    
    %Calcul of CCG
    [ccg.pre.sws, t]  = CCG(spks.pre.sws(:,1),spks.pre.sws(:,4));
    [ccg.post.sws, t] = CCG(spks.post.sws(:,1),spks.post.sws(:,4));  
    [ccg.pre.rem, t]  = CCG(spks.pre.rem(:,1),spks.pre.rem(:,4));
    [ccg.post.rem, t] = CCG(spks.post.rem(:,1),spks.post.rem(:,4));
    [ccg.pre.run, t]  = CCG(spks.pre.run(:,1),spks.pre.run(:,4));
    [ccg.post.run, t] = CCG(spks.post.run(:,1),spks.post.run(:,4));
    

    [units,~,i] = unique(spks.all(:,2:3),'rows');
    units(:,3) = 1:length(units);

    for i = 1:size(pairs,1)
        pairs(i,7) = unique(units(ismember(units(:,1:2),pairs(i,3:4),'rows'),3));
        pairs(i,8) = unique(units(ismember(units(:,1:2),pairs(i,5:6),'rows'),3));
    end
    
    pairs_id = [pairs(:,7) pairs(:,8)];

    mkdir('Billel')
    cd('Billel')
    mkdir('HighContribCCG')
    cd('HighContribCCG')
    save([session(10:end) '-HighContribCCG.mat'],'t','ccg','pairs');
    mkdir('Figs')
    cd('Figs')
    
    for i = 1:size(pairs,1)
        name = [session(10:end) '-' 'HPC' '-' int2str(pairs(i,3)) '.' int2str(pairs(i,4)) '-' 'BLA' '-' int2str(pairs(i,5)) '.' int2str(pairs(i,6))];
        name = string(name);
        name = char(strrep(name," ",""));
        
        figure;
        subplot(2,3,1);
        PlotCCG(t,ccg.pre.sws(:,pairs(i,7),pairs(i,8)));
        title(['PRE SWS' name]);
        subplot(2,3,4);
        PlotCCG(t,ccg.post.sws(:,pairs(i,7),pairs(i,8)));
        title(['POST SWS' name]);
        
        subplot(2,3,2);
        PlotCCG(t,ccg.pre.rem(:,pairs(i,7),pairs(i,8)));
        title(['PRE REM ' name]);
        subplot(2,3,5);
        PlotCCG(t,ccg.post.rem(:,pairs(i,7),pairs(i,8)));
        title(['POST REM ' name]);
        
        subplot(2,3,3);
        PlotCCG(t,ccg.pre.run(:,pairs(i,7),pairs(i,8)));
        title(['PRE RUN ' name]);
        
        subplot(2,3,6);
        PlotCCG(t,ccg.post.run(:,pairs(i,7),pairs(i,8)));
        title(['POST RUN ' name]);
       

        savefig([name '.fig'])
        close();  
    end
    
else
    load(['Billel/HighContribCCG/' session(10:end) '-HighContribCCG.mat'])
    cd('Billel/HighContribCCG')
    rmdir('Figs','s')
    mkdir('Figs')
    cd('Figs')
    
    for i = 1:size(pairs,1)
        name = [session(10:end) '-' 'HPC' '-' int2str(pairs(i,3)) '.' int2str(pairs(i,4)) '-' 'BLA' '-' int2str(pairs(i,5)) '.' int2str(pairs(i,6))];
        name = string(name);
        name = char(strrep(name," ",""));
        
        figure;
        subplot(2,1,1);
        PlotCCG(t_pre,ccg_pre(:,pairs(i,7),pairs(i,8)));
        title(['PRE' name]);
        subplot(2,1,2);
        PlotCCG(t_post,ccg_post(:,pairs(i,7),pairs(i,8)));
        title(['POST' name]);

        savefig([name '.fig'])
        close();  
    end

end