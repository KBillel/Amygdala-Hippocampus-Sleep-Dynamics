load('Rat08-20130713-LapType.mat')
load('States.mat')

pre = 2;
post = 4;
spks = SpksId(GetSpikes('output','full'));
spks_aplaps = Restrict(spks,aplaps.run);
spks_rem = Restrict(spks,Rem);

presleep  = RunIntervals(pre);
postsleep = RunIntervals(post);

spks_rem_pre = Restrict(spks_rem,presleep);
spks_rem_post = Restrict(spks_rem,postsleep);

Z_aplaps = [];

for i = 1:size(unique(spks(:,4)))
    Z_aplaps = [Z_aplaps ; binspikes(spks_aplaps(spks_aplaps(:,4)==i),40,[0 spks_aplaps(end,1)])'];
end

Z_Rem_pre = [];

for i = 1:size(unique(spks(:,4)))
    Z_Rem_pre = [Z_Rem_pre ; binspikes(spks_rem_pre(spks_rem_pre(:,4)==i),40,[0 spks(end,1)])'];
end

Z_Rem_post = [];

for i = 1:size(unique(spks(:,4)))
    Z_Rem_post = [Z_Rem_post ; binspikes(spks_rem_post(spks_rem_post(:,4)==i),40,[0 spks(end,1)])'];
end



AssemblyTemplates = assembly_patterns(Z_aplaps);
time_projection_post = assembly_activity(AssemblyTemplates,Z_Rem_post);
time_projection_pre = assembly_activity(AssemblyTemplates,Z_Rem_pre);