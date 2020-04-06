function [spectrogram] = EventsMeanSpectrogram(session,winSize)
    nwaveletwindows = 100;
    channel = str2num(GetRippleChannel);
    fMax = 100;
    
    

%CD into current session
    cd(session)
    SetCurrentSession([session '\' session(end-13:end) '.xml']);
 
    %Load sleep intervals 
    load('States.mat')
    events =  GetRippleEvents(); events = events(InIntervals(events,sws),:);
    events = events(:,3);
    lfp.sws = GetLFP(channel);
    lfp.sws = Detrend(lfp.sws);
    
    for i = 1:size(events,1)
        
        if ~ismember(events(i),lfp.sws(:,1))
            [~,I]=min(abs(lfp.sws(:,1)-events(i)));
            events(i)=lfp.sws(I,1);
        end
        
        event_lfp = Restrict(lfp.sws,[events(i)-winSize events(i)+winSize]);
        event_lfp(:,1) = event_lfp(:,1)-events(i);
        
        [airwave{i},f{i},t{i},coh,wphases,raw,coi,scale,priod,scalef]=getWavelet(event_lfp(:,2),1250,0.1,fMax,nwaveletwindows,0);

        
        
        progressbar(i,size(events,1),'# ETAPE 1 Calculate wavelet')
        disp(size(event_lfp,1))
        disp(size(airwave{i}))
    end
    
    Plot0(event_lfp,airwave,f)
    
end

function [] = progressbar(i,m,step)
        clc
        disp(step)
        p = round(i/m*100,2);
        disp([num2str(p) '%'])
        disp([repmat('/',1,floor(p/2)) repmat('-',1,50-floor(p/2))])
end


function [] = Plot0(event_lfp,airwave,f)
    airwave(1) = [];
    f(1) = [];
    fMax = size(f{1},2)
    
    meanairwave=airwave{1};
    for i=2:size(airwave,2)
        
        if size(airwave{i},2)==12501
            disp('haha')
            meanairwave=meanairwave+airwave{i};
            progressbar(i,size(airwave,2),'# ETAPE 2 Build mean airwave')
        end

    end
    meanairwave=meanairwave./size(airwave,2);
       
    
    fig = figure;
    [C,h] = contourf(event_lfp(:,1),f{1},meanairwave,100);
    for q=1:length(h)
      set(h(q),'LineStyle','none');
    end
    line([0,0],[0,fMax],'col','r')
end