load('D:\Matlab\Billel\indexing.mat')

pall.bla.rem = []
pall.hpc.rem = []


for i = 1:size(xmlpath,1)
cd(xmlpath(i))

    if exist('Billel/Power/Power.mat')
        load('Billel/Power/Power.mat')

        pall.bla.rem = [pall.bla.rem ; p.bla.rem]
        pall.hpc.rem = [pall.hpc.rem ; p.hpc.rem]
    end
end