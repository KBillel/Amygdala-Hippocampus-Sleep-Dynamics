function  [third,NRN] = PlotThird(input)


third = [mean(input.activity(:,1:10),2) mean(input.activity(:,11:20),2) mean(input.activity(:,21:30),2) mean(input.activity(:,31:34),2) mean(input.activity(:,35:38),2) mean(input.activity(:,38:42),2) mean(input.activity(:,43:52),2) mean(input.activity(:,53:62),2) mean(input.activity(:,63:72),2)];
NRN = [mean(input.activity(:,1:30),2) mean(input.activity(:,31:42),2) mean(input.activity(:,43:72),2)];
figure;
yyaxis('left')
errorbar(mean(third),sem(third))
ylabel('Frequency (Hz)')
xlabel('Normalized Time')
PlotIntervals([3.5 6.5])