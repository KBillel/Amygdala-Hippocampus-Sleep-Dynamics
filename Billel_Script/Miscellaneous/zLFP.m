function [zscored] = zLFP(lfp)
m = mean(lfp);
s = std(lfp);
zscored = (lfp-m)/s;