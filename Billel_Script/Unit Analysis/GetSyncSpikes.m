function [SyncSpikes] = GetSyncSpikes(session,str,type)
    [binned events] = GetBinnedSpikes(session,str,type);
    SyncSpikes = TransitionSync(binned,events,[-200 50]); 
end

