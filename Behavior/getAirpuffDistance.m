function [d] = getAirpuffDistance(session)
cd(session)
pos = GetCleanPositions;
load('airpuff.mat')
load([session(end-13:end) '-laps.mat'])
load('runintervals.mat')
pos = Restrict(pos,runintervals);
PlotXY(pos(:,2:3))
hold
line([airpuff.loc airpuff.loc],[0 500])
disp(airpuff.loc)
d = [pos(:,1) abs(pos(:,3)-airpuff.loc)];
d = Restrict(d,runintervals);
