function [] = Plot_NREM_REM_NREM(input,str)
    activity_pyr = input.activity(strcmpi(input.region,str)& strcmpi(input.type,"pyr"),:);
    activity_int = input.activity(strcmpi(input.region,str)& strcmpi(input.type,"int"),:);

    tosave = figure;
    hold;
    yyaxis('left')
    plot(mean(activity_pyr));
    yyaxis('right')
    plot(mean(activity_int));
    title([str ' neurons n = ' num2str(size(activity_pyr,1)) ' + ' num2str(size(activity_int,1))])
    PlotQuantileNeurons(input,str,'on');
    qu = gcf
    saveas(tosave,[str 'all'],'png')
    saveas(qu,[str 'quantiles'],'png')
end

