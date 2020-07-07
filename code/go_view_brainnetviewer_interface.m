function [edge_thresh,node_size]=go_view_brainnetviewer_interface(C,thresh,label_id)

%C: 78*78 map, threshold matrix
edge_thresh=C;
C(eye(size(C))==1) = 0;
limit = max(abs(C(:)))*thresh;
mask = abs(C) >= limit;
cLims = [-max(abs(C(:))) max(abs(C(:)))];
C(~mask) = NaN;
edge_thresh(~mask)=0;

% Set nodes to only visible if a node survives thersholding
sphereWidths = sum(~isnan(C))*0.5;
sphereWidths = 7*sphereWidths./max(sphereWidths(:));
node_size=sphereWidths;
ind_nonode=find(node_size==0);

% Find survived nodes index and set corresponding labels
index_labels= find(~(sphereWidths==0)); 
load aal_labels.mat
name_labels={};
for i=1:length(index_labels)
    name_labels{i}=aal_labels{index_labels(i)}; 
end

% Find survived nodes position (centroids coordinates)
load aalviewer
mnipos = aalviewer.centroids;
mnipos_labels=mnipos(index_labels,:);

% Set brain surface prop (following brainnetviewer)
load surface_bnv
load Surfmatrix
load EC
load Viewer
surface_bnv_tri=Surfmatrix.tri{1,2};
surface_bnv_coord=Surfmatrix.coord{1,2};
Brain=trisurf(surface_bnv_tri,surface_bnv_coord(:,1),surface_bnv_coord(:,2),surface_bnv_coord(:,3),'EdgeColor','none');
whitebg(gcf,[1 1 1]);
set(gcf,'Color',[1 1 1],'InvertHardcopy','off');
eval(['material ','dull',';'])
eval(['shading ','interp',';'])
set(Brain,'FaceColor',[0.95 0.95 0.95]);
set(Brain,'FaceAlpha',0.2);
eval(['lighting ','phong',';']);axis tight; axis vis3d off;
cam=camlight('left');
% set(cam,'style','infinite');
rot = rotate3d;                 % Create rotate3d-handle
rot.ActionPostCallback = @RotationCallback; % assign callback-function
rot.Enable = 'on';              % no need to click the UI-button

% Compute nodes weights (following brainnetviewer computation)
sphereWidths_new = sphereWidths; 
if min(sphereWidths_new)<0
   sphereWidths_new=sphereWidths_new-min(sphereWidths_new);
end
if min(sphereWidths_new)<1
   sphereWidths_new=sphereWidths_new+1;
end
while max(sphereWidths_new)/min(sphereWidths_new)>10
      sphereWidths_new=log(sphereWidths_new);
      if min(sphereWidths_new)<1
         sphereWidths_new=sphereWidths_new+1;
      end
end
if max(sphereWidths_new)~=min(sphereWidths_new)
   node_k=5/(max(sphereWidths_new)-min(sphereWidths_new));
   node_b=7-node_k*max(sphereWidths_new);
else
   node_k=0;
   node_b=4;
end
sphereWidths_new=sphereWidths_new*node_k+node_b;
sphereWidths_new(ind_nonode)=0;

% Compute edge colors
hold on
cmap      = colormap(RdBu);
if cLims(1) > 0
    cmap = cmap(129:end,:);
    isSingleColour = true;
elseif cLims(2) < 0
    cmap = cmap(1:128,:);
    isSingleColour = true;
else    
    isSingleColour = false;
end
emap = (linspace(-2,2,length(cmap))).^2;

[i,j] = find(~isnan(C));
for p=length(i):-1:1,
    colorInd(p) = closest(C(i(p),j(p)),linspace(cLims(1),cLims(2),size(cmap,1)));
end

Cu=triu(C);
Cu(find(Cu==0))=nan;
[i2,j2] = find(~isnan(Cu));

% Compute edge weights
for mm=1:length(i2)
    value_edge(mm)=C(i2(mm),j2(mm));
end
value_edge=value_edge';

% Plot Spheres
for ii = 1:length(aalviewer.centroids);
    [x y z] = sphere(50);
%     sw = sphereWidths(ii);
    sw=sphereWidths_new(ii).*0.8;
    surf(sw*x+aalviewer.centroids(ii,1),sw*y+aalviewer.centroids(ii,2),sw*z+aalviewer.centroids(ii,3),'edgecolor','none','facecolor','k','facealpha',1);
end

% Plot edges
for p=1:length(i),
    edgecolour  = cmap(colorInd(p),:);
    edgeWeight = 1.4*emap(colorInd(p));
    line(mnipos([i(p) j(p)],1),mnipos([i(p) j(p)],2),mnipos([i(p) j(p)],3),'color',edgecolour,'linewidth',edgeWeight)
end

set(gca,'clim',cLims);
colormap(RdBu);
hc = colorbar;
FONTSIZE = 14;
if isSingleColour,
    YTicks = [cLims(1) cLims(2)];
else
    YTicks = [cLims(1) 0 cLims(2)];
end%if

set(hc, ...
    'FontName', 'Helvetica', ...
    'FontSize', FONTSIZE, ...
    'Box', 'on', ...
    'TickDir', 'in', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 2);
% YTL = get(hc,'yticklabel');
% set(hc,'yticklabel',[repmat(' ',size(YTL,1),1), YTL]);

% Plot labels if required
if(label_id==1)
    hold on
    text(mnipos_labels(:,1),mnipos_labels(:,2),mnipos_labels(:,3),name_labels);
end

axis vis3d
axis equal
axis off
hold off
rotate3d('on')
set(gcf,'color','w')
set(gcf,'renderer','opengl')

end

function i = closest(a,k)
%CLOSEST finds index of vector a closest to k
assert(isscalar(k) | isscalar(a));

[~,i] = min(abs(a-k));
end


function [cmap] = RdBu(varargin)

switch nargin
    case 0
        ncols = 256;
        pn = 'div';
        deep = 0;
    case 1
        ncols = varargin{1};
        pn = 'div';
        deep = 0;
    otherwise
        ncols = varargin{1};
        if sum(strcmp('type',varargin));
            pn = varargin{find(strcmp('type',varargin))+1};
        else
            pn = 'div';
        end
        if sum(strcmp('deep',varargin));
            deep = 1;
        end
end


if rem(ncols,2)~=0;
    error('Can only accept even numbers');
end

ncols = ncols./2;


% colours
lo        = [5 48 97] / 255;
bottom    = [5 113 176] / 255;
botmiddle = [146 197 222] / 255;
middle    = [247 247 247] / 255;
topmiddle = [244 165 130] / 255;
top       = [202   0  32] / 255;
hi        = [103 0 31] / 255;

% Find ratio of negative to positive
if strncmp(pn,'div',3) || strncmp(pn,'neg',3)
    
    
    % Just negative
    if deep
        neg = [lo; bottom; botmiddle; middle];
    else
        neg = [bottom; botmiddle; middle];
    end
    len = length(neg);
    oldsteps = linspace(0, 1, len);
    newsteps = linspace(0, 1, ncols);
    neg128 = zeros(ncols, 3);
    
    for i=1:3
        % Interpolate over RGB spaces of colormap
        neg128(:,i) = min(max(interp1(oldsteps, neg(:,i), newsteps)', 0), 1);
    end
    
    cmap = neg128;
    
end

if strncmp(pn,'div',3) || strncmp(pn,'pos',3)
    % Just positive
    if deep
        pos = [middle; topmiddle; top; hi];
    else
        pos = [middle; topmiddle; top];
    end
    len = length(pos);
    oldsteps = linspace(0, 1, len);
    newsteps = linspace(0, 1, ncols);
    pos128 = zeros(ncols, 3);
    
    for i=1:3
        % Interpolate over RGB spaces of colormap
        pos128(:,i) = min(max(interp1(oldsteps, pos(:,i), newsteps)', 0), 1);
    end
    cmap = pos128;
end

if strmatch(pn,'div')
    % And put 'em together
    cmap = [neg128; pos128];
end
end

% Sub function for callback
function RotationCallback(~,~)
    cam = camlight('left');
    set(cam,'Visible','off');
    cam2=camlight(cam,'left');
end
