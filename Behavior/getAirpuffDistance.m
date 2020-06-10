function [d] = getAirpuffDistance(session)
pixelSize = 0.43;

cd(session)
pos = GetCleanPositions;
load('airpuff.mat')
load([session(end-13:end) '-laps.mat'])
load('runintervals.mat')
pos = Restrict(pos,runintervals);
d = [pos(:,1) abs(pos(:,2)-airpuff.loc*pixelSize)];
d = Restrict(d,runintervals);
