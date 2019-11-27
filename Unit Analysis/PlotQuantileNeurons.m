function [quantiled] = PlotQuantileNeurons(input,str,show)
    L = 72;
    
    pyr = strcmpi(input.region,str)& strcmpi(input.type,"pyr");
    int = strcmpi(input.region,str)& strcmpi(input.type,"int")
    
    neurons.activity_pyr = input.activity(pyr,:);
    neurons.activity_int = input.activity(int,:);
    
    neurons.metadata_pyr = input.metadata(pyr,:);
    neurons.metadata_int = input.metadata(int,:);
    
    neurons.sum = sum(neurons.activity_pyr,2)
    q = quantile(neurons.sum,4);
    q = [0 q inf];
    
    int_norm = mean(mean(neurons.activity_int(:,20:30)));
    
    for i = 1:(length(q))-1
        quantiled{i}.activity = neurons.activity_pyr(neurons.sum>q(i) & neurons.sum<q(i+1),:)
        quantiled{i}.metadata = neurons.metadata_pyr(neurons.sum>q(i) & neurons.sum<q(i+1),:)
        quantiled{i}.FR = [q(i) q(i+1)]/L
        quantiled{i}.norm = mean(mean(quantiled{i}.activity(:,20:30)))
    end
    
    if show == 'on'
        figure;
        hold;
        plot((mean(neurons.activity_int))/(int_norm) * 100)
        for i = 1:(length(q)-1)
            plot((mean(quantiled{i}.activity))/(quantiled{i}.norm) *100);
        end
        xlabel('Time Normalized')
        ylabel('Firing rates')
        legend('interneurons','1','2','3','4','5')
    end
end

