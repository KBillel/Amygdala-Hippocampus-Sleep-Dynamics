function [spectrogram,t,f] = MTCoherogrampt(spks1,spks2,varargin)
%MTSpectrogrampt 
%    The spectrogram is computed using the <a href="http://www.chronux.org">chronux</a> toolbox.
% =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'show'        plot spectrogram (default = 'off')
%    =========================================================================
% Make sure chronux is installed and functional

%This function is not working and I don't know why. 
% CheckChronux('mtcohgrampt');

% Defaults

show = 'off';

movingwin = [2 0.1];
params.Fs=1250;
params.fpass = [0 100];
params.tapers = [5 9];
params.err = 0;
params.trialave = 1;

fscorr = 1;

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

[C,phi,S12,S1,S2,t,f]=cohgrampt(spks1,spks2,movingwin,params,fscorr);

if strcmp(lower(show),'on')
    figure;
    subplot(211)
    plot_matrix(C,t,f);
%     plot_matrix(S)'
    caxis([-5 6]);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Magnitude of Coherency');
    subplot(212)
    plot(f,nanmean(C));
end

end


