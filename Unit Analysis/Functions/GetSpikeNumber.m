function n = GetSpikeNumber(spks,range)

% GetSpikeNumber - Return the number of spikes in a given interval.
% USAGE : 
% Range = [0 0.075 0.150 0.225 ...]
% n = GetSpikeNumber(spks,range)
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

n = zeros(length(range)-1,1);
for i = 1:length(range)-1
    n1 = find(spks > range(i),1);
    n2 = find(spks > range(i+1),1);
    n(i)= n2-n1;
end

