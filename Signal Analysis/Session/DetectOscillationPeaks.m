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

bandwidth = [4 8];

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


filtered_lfp = FilterLFP(lfp);
[peaks] = findpeaks(filtered_lfp(:,2),0);
[troughs] = findpeaks(-filtered_lfp(:,2),0);

peaks.times = filtered_lfp(peaks.loc,1);
troughs.times = filtered_lfp(troughs.loc,1);


%correction for multiple detection of peaks : 

figure;
hold
plot(lfp(:,1),lfp(:,2))
plot(filtered_lfp(:,1),filtered_lfp(:,2))

scatter(peaks.times,filtered_lfp(peaks.loc,2));
scatter(troughs.times,filtered_lfp(troughs.loc,2));


peaks.intervals = [];
troughs.intervals = [];

%Should be working twice as fast but not sure Actually > 10 times faster
%Problems when two peaks are detected in a row ... What to do ? 
% Solution 1 pre-process in order to spot duplicate and take mean of the
% peak.
% tic
% if peaks.times(1) > troughs.times(1)
%     for i = 1:size(peaks.times,1)
%         previous_troughs = troughs.times(troughs.times<peaks.times(i));
%         previous_troughs = previous_troughs(end);
%         if sum(troughs.times>peaks.times(i))
%             next_troughs = troughs.times(troughs.times>peaks.times(i));
%             next_troughs = next_troughs(1);
%         else
%             disp(i)
%             disp(size(troughs.times))
%             disp(size(peaks.times))
%             break
%         end
%         delta_previous = peaks.times(i) - previous_troughs;
%         delta_next = next_troughs - peaks.times(i);
%         
%         peaks.intervals = [peaks.intervals ; (peaks.times(i) - delta_previous/2)  (peaks.times(i) + delta_next/2)];
%     end
% else
% end
% toc
% troughs.intervals = InvertIntervals(peaks.intervals,peaks.intervals(1,1),peaks.intervals(end,end));
% % 


%Note : the previous code was complicated and got a lot of artefact
%therefore trying an easier solution to the problème : tresholding at 0
%post filter

peaks.intervals = filtered_lfp(:,2) > 0;
troughs.intervals = filtered_lfp(:,2)<0;

peaks.intervals = ToIntervals(filtered_lfp(:,1),peaks.intervals);
troughs.intervals = ToIntervals(filtered_lfp(:,1),troughs.intervals);

% PlotIntervals(peaks.intervals,'color','r');
% PlotIntervals(troughs.intervals,'color','g');

end


