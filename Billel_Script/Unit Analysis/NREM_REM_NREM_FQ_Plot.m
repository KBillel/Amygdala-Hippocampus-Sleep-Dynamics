function [input] = NREM_REM_NREM_FQ_Plot(input)
%Code is divided in 2 main part, first part is calculating correlation between \delta firing rate pre-post REM and correlate it with thetapower during this REM episode.
%2nd part is generalisation for all frequencies.

%%% Only for theta
    N_N_dActivity = [];
    for i = 1:size(input,1)
        if isempty(input{i}.activity)
            continue
        end
        
        input{i}.dActivity = [mean(input{i}.activity(1:30,:,:),1) ;mean(input{i}.activity(31:40,:,:),1) ;mean(input{i}.activity(41:70,:,:),1)];
        input{i}.dActivity = permute(input{i}.dActivity,[2 1 3]);
        x = input{i}.dActivity(:,3,:)-input{i}.dActivity(:,1,:); %Calcul differences firing rates après-avant épisode REM
  
        for k = 1:size(x,3)
            for j = 1:size(x,1)
                N_N_dActivity = [N_N_dActivity ; x(j,:,k) mean(input{i}.remPower(k,6<input{i}.f & input{i}.f<8)) input{i}.remlength(k)]; 
            end
        end
    end
    N_N_dActivity = rmmissing(N_N_dActivity);
    b= [];

    idx = unique(N_N_dActivity(:,2));
    
    for i = 1:size(idx)
        b = [b; mean(N_N_dActivity(N_N_dActivity(:,2)==idx(i),1)) idx(i) mean(N_N_dActivity(N_N_dActivity(:,2)==idx(i),3))];
    end
    
    
    thetapower = fitlm(b(:,2),b(:,1))
    x_power = min(b(:,2)):0.1:max(b(:,2));
    y_power = thetapower.Coefficients.Estimate(1) + thetapower.Coefficients.Estimate(2)*x_power;
    [r_power p_power] = corr(b(:,2),b(:,1));
    
    rem_length = fitlm(b(:,3),b(:,1))
    x_length = 0:0.1:max(b(:,3));
    y_length = rem_length.Coefficients.Estimate(1) + rem_length.Coefficients.Estimate(2)*x_length;
    [r_length p_length] = corr(b(:,3),b(:,1));
    
    figure;
    scatter(b(:,2),b(:,1),'.')
    hold
    plot(x_power,y_power)
    xlabel('REM Theta Power')
    ylabel('\Delta Firing rates')
%     text(max(b(:,2))-2,0.1,['R^2 = ' num2str(thetapower.Rsquared.Adjusted)])
%     text(max(b(:,2))-2,0.0,['p = ' num2str(thetapower.Coefficients.pValue(2))])
    text(max(b(:,2))-2,0.1,['r = ' num2str(r_power)])
    text(max(b(:,2))-2,0.0,['p = ' num2str(p_power)])

    figure;
    scatter(b(:,3),b(:,1),'.')
    hold
    plot(x_length,y_length)
    
    xlabel('REM Length')
    ylabel('\Delta Firing rates')
%     text(300,0.1,['R^2 = ' num2str(rem_length.Rsquared.Adjusted)])
%     text(300,0.0,['p = ' num2str(rem_length.Coefficients.pValue(2))])
    text(300,0.1,['r = ' num2str(r_length)])
    text(300,0.0,['p = ' num2str(p_length)])
    
    
    %%% For all Frequencies : 
    N_N_dActivity = [];
    for i = 1:size(input,1)       
        x = input{i}.dActivity(:,3,:)-input{i}.dActivity(:,1,:);
        for k = 1:size(x,3) 
            powerInterval = [];
            for v = 0:1:95
                powerInterval = [powerInterval mean(input{i}.remPower(k,v<input{i}.f & input{i}.f<v+5))];
            end
            
            for j = 1:size(x,1)
                N_N_dActivity = [N_N_dActivity ; x(j,:,k) powerInterval];
        
            end
        end
    end
    
    
    N_N_dActivity = rmmissing(N_N_dActivity);
    
    b = [];

    idx = unique(N_N_dActivity(:,2:end),'rows');

    for i = 1:size(idx)
        b = [b; mean(N_N_dActivity(N_N_dActivity(:,2:end)==idx(i),1),1) idx(i,:)];
    end
    
    R = [];
    r = [];
    p = [];
    for i = 2:(size(b,2))
        lm = fitlm(b(:,i),b(:,1));
        R = [R lm.Rsquared.Adjusted];
        r = [r corr(b(:,i),b(:,1))];
        p = [p lm.Coefficients.pValue(2)];
    end
    
    
    figure;
%     plot(0:1:95,p);
    hold
    plot(0:1:95,r)
end

