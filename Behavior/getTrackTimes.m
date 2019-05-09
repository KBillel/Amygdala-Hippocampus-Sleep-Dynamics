function [trackruntimes,trackquiettimes] = getTrackTimes(runintervals)
   
    pos=GetPositions('coordinates','real','pixel',0.43,'discard','none');
    CleanPos(pos);
    pos(:,2:3)=[];
    pos=InterpolateNaNPos(pos);
    v = LinearVelocity(pos,10);
    
    
    [trackruntimes,in]=Threshold(v,'>=',5,'min',2,'max',0.5);
    [trackquiettimes,in]=Threshold(v,'<=',3,'min',2,'max',0.5);
    
    trackquiettimes=Restrict(trackquiettimes,runintervals);
    trackruntimes=Restrict(trackruntimes,runintervals);

    