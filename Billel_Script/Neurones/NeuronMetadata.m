function [type str] = NeuronMetadata(metadata)
%NEURONMETADATA Summary of this function goes here
%   Return full metadata of a neuron given rat/jour/shank/n
    
    load('Z:\All-Rats\Structures\structures.mat')
    load('Z:\All-Rats\AllRats-FinalType.mat')
    
    type = finalType(ismember(finalType(:,1:4),metadata,'rows'),5);
    
    
    
    index = ratsessionindex(xmlpath == session,:);
end

