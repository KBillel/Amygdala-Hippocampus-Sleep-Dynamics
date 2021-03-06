function [quantiled] = QuantileNeurons(neurons,show)
    neurons.sum = sum(neurons.activity,2)
    q = quantile(neurons.sum,4);
    q = [0 q inf];
    
    for i = 1:(length(q))-1
        quantiled{i}.activity = neurons.activity(neurons.sum>q(i) & neurons.sum<q(i+1),:)
        quantiled{i}.metadata = neurons.metadata(neurons.sum>q(i) & neurons.sum<q(i+1),:)
        quantiled{i}.FR = [q(i) q(i+1)]/40
        quantiled{i}.norm = mean(mean(quantiled{i}.activity(:,20:30)))
    end
    
    if show == 'on'
        figure;
        hold;
        for i = 1:(length(q)-1)
            plot((mean(quantiled{i}.activity))/(quantiled{i}.norm) *100);
        end
    end
end

