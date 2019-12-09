function FRStatesPlot(input,label)

    pyr = input.type == "Pyr";
    int = input.type == "Int";

    rem_wake_pyr = ratio(input.FR_REM(pyr),input.FR_WAKE(pyr));
    sws_wake_pyr = ratio(input.FR_SWS(pyr),input.FR_WAKE(pyr));
    rem_sws_pyr = ratio(input.FR_REM(pyr),input.FR_SWS(pyr));

    rem_wake_int = ratio(input.FR_REM(int),input.FR_WAKE(int));
    sws_wake_int = ratio(input.FR_SWS(int),input.FR_WAKE(int));
    rem_sws_int = ratio(input.FR_REM(int),input.FR_SWS(int));
    
    
    
    
 %Density Scatter Plot

    plot0(rem_sws_pyr,rem_wake_pyr,[label ' PYR']);
    plot0(rem_sws_int,rem_wake_int,[label ' INT']);
    
    
end

function r = ratio(x,y)
    r = (x-y)./(x+y);
end

function plot0(x,y,name)
    figure;
    hold
    scatter_kde(x,y,'filled','MarkerSize',25);
    plot([0 0],[-1 1],'col','red')
    plot([-1 1],[0 0],'col','red')
    xlabel('rem-sws/rem+sws')
    ylabel('rem-wake/rem+wake')
    title(name)
end

% function plot1(x,y,name)
%     figure;
%     hold
%     scatter()
% end


