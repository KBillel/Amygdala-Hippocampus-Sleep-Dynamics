load('D:\Matlab\Billel\indexing.mat')

distall.hpc = [];
distall.bla = [];

statsall.hpc.p = [];
statsall.bla.p = [];

statsall.hpc.m = [];
statsall.bla.m = [];

statsall.hpc.k = [];
statsall.bla.k = [];

statsall.hpc.mode = [];
statsall.bla.mode = [];

statsall.hpc.r = [];
statsall.bla.r = [];

metadataall = [];


for i = 1:size(xmlpath,1)
    cd(xmlpath(i))
    disp([num2str(i/size(xmlpath,1)*100) '%' repmat('#',1,floor(i/size(xmlpath,1)*100)) repmat('0',1,floor(100-(i/size(xmlpath,1))*100))])
    if exist('Billel/ThetaMod/ThetaMod.mat')
        load('Billel/ThetaMod/ThetaMod.mat')
        
        distall.hpc = [distall.hpc dist.hpc];
        distall.bla = [distall.bla dist.bla];

        statsall.hpc.p = [statsall.hpc.p stats.hpc.p];
        statsall.bla.p = [statsall.bla.p stats.bla.p];

        statsall.hpc.m = [statsall.hpc.m stats.hpc.m];
        statsall.bla.m = [statsall.bla.m stats.bla.m];
        
        statsall.hpc.mode = [statsall.hpc.mode stats.hpc.mode];
        statsall.bla.mode = [statsall.bla.mode stats.bla.mode];

        statsall.hpc.r = [statsall.hpc.r stats.hpc.r];
        statsall.bla.r = [statsall.bla.r stats.bla.r];

        metadataall = [metadataall ; metadata];
    end
end