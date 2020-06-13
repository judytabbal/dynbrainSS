function sign_flip=go_viewNetworkComponents_general_sim_separated(opt,results,varargin)

% set some defaults
opt.components = ft_getopt(opt,'components',1:results.NICs);
opt.threshold  = ft_getopt(opt,'threshold',0.9);

if opt.threshold > 1 || opt.threshold < 0
    error('threhsold can only be between 0 and 1');
end

% there may be some statsitical thresholds to overlay, check
if nargin == 3;
    stat_thresh = varargin{1}.thresholds;
end


for ii = opt.components(1):opt.components(end)    
    figure()
    mode = results.maps(:,:,ii);
    % if the key connections are all anticorrelated, do a sign flip of the
    % map and signal
    modescale = max(abs(mode(:)));
    threshmode = mode.*(abs(mode) >= opt.threshold*modescale);
    if mean(threshmode(:)) < 0;
        flip = -1;
    else
        flip = 1;
    end
    
    sign_flip(ii)=flip;

    set(gcf,'Units','normalized')
    set(gcf,'Position',[0.1844    0.4722    0.6401    0.3889]);
    
    subplot(1,2,1)
    go_view_brainnetviewer_interface(flip*mode,opt.threshold,opt.label);

    subplot(1,2,2)
    IC = results.signals(ii,:);

    plot(results.time,flip*IC,'linewidth',2,'color','k');
    
    if exist('stat_thresh','var');
        hold on
        fill([results.time fliplr(results.time)],[stat_thresh.upper(ii,:) fliplr(stat_thresh.lower(ii,:))]',[0.5 0.5 0.5],'FaceAlpha',0.5,'EdgeColor','none');
        hold off
    end
     
    grid off
    set(gcf,'color','w')
    set(gca,'xlim',[min(results.time) max(results.time)])
    xlabel('time / s')
    ylabel('trial averaged IC')
end

end

