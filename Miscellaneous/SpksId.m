function [spks] = SpksId(spks)
z = [];
spks(spks(:,3)==0 | spks(:,3) == 1,:) = [];
[units,~,i] = unique(spks(:,2:3),'rows');
spks(:,4) = i;
end