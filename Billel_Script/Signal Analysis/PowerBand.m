function [power] = PowerBand(session,channel_hpc,channel_bla,pre,post,keep)   
    load('D:\Matlab\Billel\indexing.mat')
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);
    
    cd(session);
    SetCurrentSession([session '\' session(end-13:end) '.xml'],'spikes','off');
    load('States.mat');
    

    p.bla.rem = []
    for i = 1:size(Rem,1)
        lfp.bla.rem = GetLFP(channel_bla,'restrict',[Rem(i,1) Rem(i,2)  ]);
        [p.current,f] = MTSpectrum(Detrend(lfp.bla.rem),'range',[0 20]);
        p.bla.rem = [p.bla.rem ; rat jour mean(p.current(6<f<8)) i];
    end
    
     p.hpc.rem = []
    for i = 1:size(Rem,1)
        lfp.hpc.rem = GetLFP(channel_hpc,'restrict',[Rem(i,1) Rem(i,2)  ]);
        [p.current,f] = MTSpectrum(Detrend(lfp.hpc.rem),'range',[0 20],'show','on');
        
        p.hpc.rem = [p.hpc.rem ; rat jour mean(p.current(6<f<8)) i];
    end
    
    if keep == 1
        mkdir('Billel/Power');
        cd('Billel/Power');
        save('Power','p')
    end
    
   
    
end