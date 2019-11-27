function [spectrogram,t,f] = MTSpectrogrampt(spks,varargin)
%MTSpectrogrampt 
%    The spectrogram is computed using the <a href="http://www.chronux.org">chronux</a> toolbox.
% =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'show'        plot spectrogram (default = 'off')
%    =========================================================================
% Make sure chronux is installed and functional

%This function is not working and I don't know why. 
% CheckChronux('mtspecgrampt');

% Defaults
show = 'off';

movingwin = [2 0.1];
params.Fs=1250;
params.fpass = [0 100];
params.tapers = [5 9];
params.err = 0;
params.trialave = 1;

if nargin < 1 | mod(length(varargin),2) ~= 0,
    error('Incorrect number of parameters (type ''help <a href="matlab:help MTSpectrogrampt">MTSpectrogrampt</a>'' for details).');
end

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help MTSpectrogram">MTSpectrogram</a>'' for details).']);
    end
    switch(lower(varargin{i}))
        case 'show'
            show = varargin{i+1};
            if ~isastring(show,'on','off')
                error('Incorrect value for property ''show'' (type ''help <a href="matlab:help MTSpectrogram">MTSpectrogram</a>'' for details).');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help MTSpectrogrampt">MTSpectrogrampt</a>'' for details).']);
    end
end

% Check for discontinuities and update t accordingly
% gaps = diff(spks(:,1)) > 5*nanmedian(diff(spks(:,1)));
% if any(gaps)
% 	n = length(spks(:,1));
% 	t = interp1(1:n,spks(:,1),linspace(1,n,length(t))');
% end

[S,t,f,R] = mtspecgrampt_optimized(spks,movingwin,params);
spectrogram = S./repmat(R,[1 size(S,2)]);

if strcmp(lower(show),'on')
    figure;
    subplot(211)
    plot_matrix(spectrogram,t,f);
%     plot_matrix(S)'
    caxis([-5 6]);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Power Spectrogram');
    subplot(212)
    plot(t,nanmean(spectrogram))
end
end

