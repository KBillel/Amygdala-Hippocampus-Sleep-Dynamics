BLA_PYR_ALL.activity = [];
BLA_PYR_ALL.metadata = [];
BLA_PYR_ALL.metadatastr = BLA_PYR{1}.metadatastr;
for i = 28:28
    input{i}.mean_activity = mean(input{i}.activity,3)';
    BLA_PYR_ALL.activity = [BLA_PYR_ALL.activity ; input{i}.mean_activity]
    BLA_PYR_ALL.metadata = [BLA_PYR_ALL.metadata ; input{i}.metadata]
    
end