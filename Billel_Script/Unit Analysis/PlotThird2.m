function PlotThird2(inputpyr,inputint,name,theta)

lim_pyr = [0.8 1.5];
lim_int = [2 12.8];


inputpyr.third = [mean(inputpyr.activity(:,1:30),2) mean(inputpyr.activity(:,31:40),2) mean(inputpyr.activity(:,41:70),2)];
inputint.third = [mean(inputint.activity(:,1:30),2) mean(inputint.activity(:,31:40),2) mean(inputint.activity(:,41:70),2)];
inputpyr.thirdsem = sem(inputpyr.third);
inputint.thirdsem = sem(inputint.third);
inputpyr.sem = sem(inputpyr.activity);
inputint.sem = sem(inputint.activity);

signrank(inputpyr.third(:,1),inputpyr.third(:,3))
figure;
d = [inputpyr.third(:,1) inputpyr.third(:,3)];
d = d(d(:,1)~=0 & d(:,2)~=0,:);
violin(log10(d));
ylim([-3 3])


q = quantile(mean(inputpyr.activity,2),0.05)
restrict = ismember(inputpyr.metadata(:,1:4),theta(:,1:4),'rows');
r = ratio(inputpyr.third(restrict,3),inputpyr.third(restrict,1))
plot0(r,"10%")


r = ratio(inputpyr.third(~restrict,3),inputpyr.third(~restrict,1))
plot0(r,"90%")


signrank(inputint.third(:,1),inputint.third(:,3))
figure;
d = [inputint.third(:,1) inputint.third(:,3)];
d = d(d(:,1)~=0 & d(:,2)~=0,:);
violin(log10(d));
ylim([-3 3])

figure;
yyaxis left
plot(mean(inputpyr.third))
hold('on')
plot(mean(inputpyr.third) + inputpyr.thirdsem)
plot(mean(inputpyr.third) - inputpyr.thirdsem)
ylim(lim_pyr)
yyaxis right
plot(mean(inputint.third))
hold('on')
plot(mean(inputint.third) + inputint.thirdsem)
plot(mean(inputint.third) - inputint.thirdsem)
ylim(lim_int)
title(name)




figure;

yyaxis left
plot(mean(inputpyr.activity))
hold('on')
plot(mean(inputpyr.activity) + inputpyr.sem)
plot(mean(inputpyr.activity) - inputpyr.sem)
ylim(lim_pyr)

yyaxis right
plot(mean(inputint.activity))
hold('on')
plot(mean(inputint.activity) + inputint.sem)
plot(mean(inputint.activity) - inputint.sem)
ylim(lim_int)
xlim([1 length(mean(inputint.activity))])
title(name)


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