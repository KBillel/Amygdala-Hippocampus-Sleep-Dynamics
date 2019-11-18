function [] = powerVideo(lfp);
frame = [];
wave = figure;
potentiel = figure;

for i = 1:10000
    dt = 6500;
    
    t1 = (dt*i/50)+1;
    t2 = t1+dt;
    
%     [power f] = MTSpectrum(Detrend(lfp(t1:t2,:)),'show','off','range',[0 100],'window',1);
%     frame = [frame; power];
%     plot(f,log(power));
%     legend(num2str(t1/1250))
%     ylim([-1 4]);

    figure(wave)
    cwt(lfp(t1:t2,2),1250);
    clim([0 300])
    
    figure(potentiel);
    subplot(3,1,1)
    title("Raw")
    PlotXY(lfp(t1:t2,:))
    hold('on')
    PlotXY(FilterLFP(lfp(t1:t2,:)),'red')
    hold('off')
    xlim([lfp(t1,1) lfp(t2,1)])
    ylim([-2000 2000])
    subplot(3,1,2)
    title('Theta')
    PlotXY(FilterLFP(lfp(t1:t2,:)))
    xlim([lfp(t1,1) lfp(t2,1)])
    ylim([-500 500])
    subplot(3,1,3)
    
    title("Ripples")
    PlotXY(FilterLFP(lfp(t1:t2,:),'passband',[150 250]))
    xlim([lfp(t1,1) lfp(t2,1)])
    ylim([-250 250])


    drawnow 
end