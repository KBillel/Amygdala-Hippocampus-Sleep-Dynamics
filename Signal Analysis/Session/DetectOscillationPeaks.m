function [peaks,troughs] = DetectOscillationPeaks(lfp,varargin)
%MTSpectrogrampt 
%    The spectrogram is computed using the <a href="http://www.chronux.org">chronux</a> toolbox.
% =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'bandwidth'   Bandwidth to filter the oscillation
%    =========================================================================
% Need improvement :
% - Way too slow
% - Some peaks and troughs are counted multiple times. 
% Defaults

bandwidth = [4 12];

if nargin < 1 | mod(length(varargin),2) ~= 0,
    error('Incorrect number of parameters (type ''help <a href="matlab:help DetectOscillationsPeaks">MTSpectrogrampt</a>'' for details).');
end

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help MTSpectrogram">MTSpectrogram</a>'' for details).']);
    end
    switch(lower(varargin{i}))
        case 'bandwidth'
            bandwidth = varargin{i+1};
            if size(bandwith)~= 2 
                error('Incorrect value for property ''bandwith'' (type ''help <a href="matlab:help MTSpectrogram">MTSpectrogram</a>'' for details).');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help MTSpectrogrampt">MTSpectrogrampt</a>'' for details).']);
    end
end


filtered_lfp = lfp;%Filter(lfp,'passband',bandwidth);
[peaks] = findpeaks(filtered_lfp(:,2),0);
[troughs] = findpeaks(-filtered_lfp(:,2),0);

peaks.times = filtered_lfp(peaks.loc,1);
troughs.times = filtered_lfp(troughs.loc,1);
% 
% plot(filtered_lfp(:,1),filtered_lfp(:,2))
% hold
% scatter(peaks.time,filtered_lfp(peaks.loc,2));
% scatter(troughs.time,filtered_lfp(troughs.loc,2));


peaks.intervals = [];
troughs.intervals = [];

%%%%%Working but reaaaaly slow
for i = 1:size(peaks.loc)-1
    t_peak = filtered_lfp(peaks.loc(i),1);
    t_next_troughs = troughs.times(troughs.times > t_peak);
    t_trough = t_next_troughs(1);

    peaks.intervals = [peaks.intervals ; [t_peak t_peak + (t_trough-t_peak)/2]];
    troughs.intervals = [troughs.intervals ;[t_trough - (t_trough-t_peak)/2 t_trough]];
end

for i = 1:size(troughs.loc)-1
    t_trough = filtered_lfp(troughs.loc(i),1);
    t_next_peaks = peaks.times(t_trough < peaks.times);
    t_peak = t_next_peaks(1);
    
    troughs.intervals = [troughs.intervals ;[t_trough t_trough + (t_peak-t_trough)/2]];
    peaks.intervals = [peaks.intervals ; [t_peak -  (t_peak-t_trough)/2 t_peak]];
    
    
end
%%%%%Working but reaaaaly slow


%Should be working twice as fast but not sure
if peaks.times(1) > troughs.times(1)
    for i = 1:size(peaks.times,1)-1
        
        previous_troughs = troughs.times<peaks.times(i);
        next_troughs = troughs.times>peaks.times(i);
        
        
        delta_previous = peaks.times(i) - troughs.times(previous_troughs)
        delta_next = troughs.times(next_troughs) - peaks.times(i);
        
        peaks.intervals = [troughs.intervals ; (peaks.times(i) - delta_previous/2)  (peaks.times(i) + delta_next/2)]
    end
else
    
    
end

% PlotIntervals(peaks.intervals,'color','r');
% PlotIntervals(troughs.intervals,'color','g');
end


