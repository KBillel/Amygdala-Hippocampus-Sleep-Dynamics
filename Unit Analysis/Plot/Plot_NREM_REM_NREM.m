function [] = Plot_NREM_REM_NREM(input,str,rat,save)

    activity_pyr = input.activity(strcmpi(input.region,str)& strcmpi(input.type,"pyr")& input.metadata(:,1) == rat,:);
    activity_int = input.activity(strcmpi(input.region,str)& strcmpi(input.type,"int")& input.metadata(:,1) == rat,:);
    
    L = size(activity_pyr,2);
    disp(L);
%     tosave = figure;
%     hold;
%     
%     yyaxis('left')
%     plot(mean(activity_pyr));
%     plot(mean(activity_pyr)+sem(activity_pyr));
%     plot(mean(activity_pyr)-sem(activity_pyr));
%     ylim([0.7 1.6])
%     PlotIntervals([31 42]);
%     yyaxis('right')
%     plot(mean(activity_int));
%     plot(mean(activity_int)+sem(activity_int));
%     plot(mean(activity_int)-sem(activity_int));
%     ylim([2 8.5])
%     title([rat str ' neurons n = ' num2str(size(activity_pyr,1)) ' + ' num2str(size(activity_int,1))])
%     xlim([0 L])
    
    
    
    PlotQuantileNeurons(input,str,rat,'on',L);
    PlotIntervals([31 42]);
    xlim([0 L])
    title([num2str(rat) str ' neurons n = ' num2str(size(activity_pyr,1)) ' + ' num2str(size(activity_int,1))])
    qu = gcf
    
    
    if save == 1;
%         saveas(tosave,[str 'all'],'svg')
        saveas(qu,[num2str(rat) str 'quantiles'],'svg')
    end
end

