function [t,ccg] = Auto_CCG_States(session)
load('D:\Matlab\Billel\indexing.mat')

index = ratsessionindex(xmlpath == session,:);
rat = index(1);
jour = index(2);
session = char(session);
load('Z:\All-Rats\Structures\structures.mat')

cd(session)
load('States.mat')
SetCurrentSession([session '\' session(end-13:end) '.xml']);    
spks.all = GetSpikes('output','full');
spks.all = SpksId(spks.all);

spks.sws = spks.all(InIntervals(spks.all(:,1),sws),:);
spks.rem = spks.all(InIntervals(spks.all(:,1),Rem),:);
spks.wake = spks.all(InIntervals(spks.all(:,1),wake),:);

for i = 1:length(unique(spks.all(:,4)))
    if (isempty(spks.sws(spks.sws(:,4)==i)) || isempty(spks.rem(spks.rem(:,4)==i)) || isempty(spks.wake(spks.wake(:,4)==i)))
%         disp(unique(spks.all(spks.all(:,4)==i,:),rows))
        spks.all(spks.all(:,4)==i,:) = []; 
    end
end

spks.all = SpksId(spks.all);
spks.sws = spks.all(InIntervals(spks.all(:,1),sws),:);
spks.rem = spks.all(InIntervals(spks.all(:,1),Rem),:);
spks.wake = spks.all(InIntervals(spks.all(:,1),wake),:);


metadata(:,3:5) = unique(spks.all(:,2:4),'rows');
metadata(:,1) = rat;
metadata(:,2) = jour;

[ccg_sws,t] = CCG(spks.sws(:,1),spks.sws(:,4));
ccg_rem = CCG(spks.rem(:,1),spks.rem(:,4));
ccg_wake = CCG(spks.wake(:,1),spks.wake(:,4));

auto_ccg_wake = [];
auto_ccg_rem = [];
auto_ccg_sws = [];

for i = 1:size(metadata,1)
    auto_ccg_wake = [auto_ccg_wake ;ccg_wake(:,i,i)'];
    auto_ccg_rem = [auto_ccg_rem ; ccg_rem(:,i,i)'];
    auto_ccg_sws = [auto_ccg_sws ; ccg_sws(:,i,i)'];
end

auto_ccg_states = [auto_ccg_wake auto_ccg_sws auto_ccg_rem];

mkdir('Billel')
cd('Billel')
mkdir('Auto_CCG_State')
cd('Auto_CCG_State')
save ('auto_ccg_states','t','auto_ccg_wake','auto_ccg_sws','auto_ccg_rem','auto_ccg_states','metadata')
end