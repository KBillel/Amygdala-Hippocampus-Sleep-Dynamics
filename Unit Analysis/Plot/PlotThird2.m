function PlotThird2(input,str,keep)

inputpyr.activity = input.activity(strcmpi(input.region,str) & strcmpi(input.type,'pyr'),:);
inputint.activity = input.activity(strcmpi(input.region,str) & strcmpi(input.type,'int'),:);

inputpyr.activity = zscore(inputpyr.activity')';
inputint.activity = zscore(inputint.activity')';

inputpyr.third = [mean(inputpyr.activity(:,1:30),2) mean(inputpyr.activity(:,31:42),2) mean(inputpyr.activity(:,43:72),2)];
inputint.third = [mean(inputint.activity(:,1:30),2) mean(inputint.activity(:,31:42),2) mean(inputint.activity(:,43:72),2)];
inputpyr.thirdsem = sem(inputpyr.third);
inputint.thirdsem = sem(inputint.third);
inputpyr.sem = sem(inputpyr.activity);
inputint.sem = sem(inputint.activity);


n_pyr = size(inputpyr.activity,1);
n_int = size(inputint.activity,1);

% plot(cv(inputpyr.activity));


%%%%%% Statistics
disp('Sign rank test for Pyramidal neurons :')
p_pyr = signrank(inputpyr.third(:,1),inputpyr.third(:,3));
disp(p_pyr)
disp('Sign rank test for Interneurons neurons :')
p_int = signrank(inputint.third(:,1),inputint.third(:,3));
disp(p_int)

%%%%%% Plots
figure;
int = figure;
d = [inputint.third(:,1) inputint.third(:,3)];
violin(d);
ylim([-2 2])
title([str  'int neurons n = ' num2str(n_int) ' and p = ' num2str(p_int)])
pyr = figure;
pyr.PaperPositionMode = 'auto'
d = [inputpyr.third(:,1) inputpyr.third(:,3)];
violin(d);
ylim([-2 2])
title([str  'pyr neurons n = ' num2str(n_pyr) ' and p = ' num2str(p_pyr)])



if keep == 1;
    saveas(pyr,[str 'pyr'],'svg')
    saveas(int,[str 'int'],'svg')
end
    










% q = quantile(mean(inputpyr.activity,2),0.05)
% restrict = ismember(inputpyr.metadata(:,1:4),theta(:,1:4),'rows');
% r = ratio(inputpyr.third(restrict,3),inputpyr.third(restrict,1))
% plot0(r,"10%")
% 
% 
% r = ratio(inputpyr.third(~restrict,3),inputpyr.third(~restrict,1))
% plot0(r,"90%")




% figure;
% yyaxis left
% plot(mean(inputpyr.third))
% hold('on')
% plot(mean(inputpyr.third) + inputpyr.thirdsem)
% plot(mean(inputpyr.third) - inputpyr.thirdsem)
% ylim(lim_pyr)
% yyaxis right
% plot(mean(inputint.third))
% hold('on')
% plot(mean(inputint.third) + inputint.thirdsem)
% plot(mean(inputint.third) - inputint.thirdsem)
% ylim(lim_int)
% title(name)
% 
% figure;
% yyaxis left
% plot(mean(inputpyr.activity))
% hold('on')
% plot(mean(inputpyr.activity) + inputpyr.sem)
% plot(mean(inputpyr.activity) - inputpyr.sem)
% ylim(lim_pyr)
% yyaxis right
% plot(mean(inputint.activity))
% hold('on')
% plot(mean(inputint.activity) + inputint.sem)
% plot(mean(inputint.activity) - inputint.sem)
% ylim(lim_int)
% xlim([1 length(mean(inputint.activity))])
% title(name)


% plot(mean(input.third) + input.sem,'red')
% plot(mean(input.third) - input.sem,'red')

% signrank(input.third(:,1),input.third(:,3))
end


function r = ratio(x,y)
    r = (x-y)./(x+y);
end

function plot0(x,name)
    figure;
    hold
    histogram(x)
    xlabel('/rem+sws')
    title(name)
end

function cv = cv(x)
    cv = nanstd(x)./nanmean(x);
end