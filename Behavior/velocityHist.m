function [v] = velocityHist(('Z:\Rat09\Rat09-20140326'))


v = [];

cd(session)
SetCurrentSession([session '\' session(end-13:end) '.xml'],'spikes','off');
load('runintervals.mat')

pos = GetCleanPositions('show','off');
v = LinearVelocity(pos);
v = v(InIntervals(v(:,1),runintervals),2);



