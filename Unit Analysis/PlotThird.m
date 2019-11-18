function  [third,NRN] = PlotThird(input)

third = [mean(input.activity(:,1:10),2) mean(input.activity(:,11:20),2) mean(input.activity(:,21:30),2) mean(input.activity(:,31:35),2) mean(input.activity(:,35:40),2) mean(input.activity(:,41:50),2) mean(input.activity(:,51:60),2) mean(input.activity(:,61:70),2)];
NRN = [mean(input.activity(:,1:30),2) mean(input.activity(:,31:40),2) mean(input.activity(:,41:70),2)];
figure;
plot(mean(third))