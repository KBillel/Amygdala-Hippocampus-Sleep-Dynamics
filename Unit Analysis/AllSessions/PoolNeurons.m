function [pooled] = poolNeurons(input)

pooled.activity = [];
pooled.metadata = [];
pooled.metadatastr = input{1}.metadatastr;
for i = 1:length(input)
    if ~isempty(input{i}.activity)
        input{i}.mean_activity = mean(input{i}.activity,3)';
        pooled.activity = [pooled.activity ; input{i}.mean_activity];
        pooled.metadata = [pooled.metadata ; input{i}.metadata] ;
    end
end