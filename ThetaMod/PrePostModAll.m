load('D:\Matlab\Billel\indexing.mat')

distall.pre.hpc = [];
distall.pre.bla = [];

statsall.pre.hpc.p = [];
statsall.pre.bla.p = [];

statsall.pre.hpc.m = [];
statsall.pre.bla.m = [];

statsall.pre.hpc.k = [];
statsall.pre.bla.k = [];

statsall.pre.hpc.mode = [];
statsall.pre.bla.mode = [];

statsall.pre.hpc.r = [];
statsall.pre.bla.r = [];

distall.post.hpc = [];
distall.post.bla = [];

statsall.post.hpc.p = [];
statsall.post.bla.p = [];

statsall.post.hpc.m = [];
statsall.post.bla.m = [];

statsall.post.hpc.k = [];
statsall.post.bla.k = [];

statsall.post.hpc.mode = [];
statsall.post.bla.mode = [];

statsall.post.hpc.r = [];
statsall.post.bla.r = [];

metadataall = [];

somme = [];

for i = 1:size(xmlpath,1)
    cd(xmlpath(i))
    
    if exist('Billel/ThetaMod/PrePostThetaMod.mat')
        load('Billel/ThetaMod/PrePostThetaMod.mat')
      
        distall.pre.hpc = [distall.pre.hpc dist.pre.hpc];
        distall.pre.bla = [distall.pre.bla dist.pre.bla];

        statsall.pre.hpc.p = [statsall.pre.hpc.p stats.pre.hpc.p];
        statsall.pre.bla.p = [statsall.pre.bla.p stats.pre.bla.p];

        statsall.pre.hpc.m = [statsall.pre.hpc.m stats.pre.hpc.m];
        statsall.pre.bla.m = [statsall.pre.bla.m stats.pre.bla.m];
        
        statsall.pre.hpc.mode = [statsall.pre.hpc.mode stats.pre.hpc.mode];
        statsall.pre.bla.mode = [statsall.pre.bla.mode stats.pre.bla.mode];

        statsall.pre.hpc.r = [statsall.pre.hpc.r stats.pre.hpc.r];
        statsall.pre.bla.r = [statsall.pre.bla.r stats.pre.bla.r];
        
        distall.post.hpc = [distall.post.hpc dist.post.hpc];
        distall.post.bla = [distall.post.bla dist.post.bla];

        statsall.post.hpc.p = [statsall.post.hpc.p stats.post.hpc.p];
        statsall.post.bla.p = [statsall.post.bla.p stats.post.bla.p];

        statsall.post.hpc.m = [statsall.post.hpc.m stats.post.hpc.m];
        statsall.post.bla.m = [statsall.post.bla.m stats.post.bla.m];
        
        statsall.post.hpc.mode = [statsall.post.hpc.mode stats.post.hpc.mode];
        statsall.post.bla.mode = [statsall.post.bla.mode stats.post.bla.mode];

        statsall.post.hpc.r = [statsall.post.hpc.r stats.post.hpc.r];
        statsall.post.bla.r = [statsall.post.bla.r stats.post.bla.r];

        metadataall = [metadataall ; metadata];
        
        somme = [ somme ; sum(stats.pre.bla.p < 0.01 & stats.pre.bla.r > 0.04) sum(stats.post.bla.p < 0.01 & stats.post.bla.r > 0.04)]
        
    end
    
    stats = statsall;
    metadata = metadataall;
    dist = distall;
    
end