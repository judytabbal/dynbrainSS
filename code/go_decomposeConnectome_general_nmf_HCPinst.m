function results = go_decomposeConnectome_general_nmf_HCPinst(opt,varagin)

opt.NICs            = ft_getopt(opt, 'NICs', 10);
opt.NPCs            = ft_getopt(opt, 'NPCs', opt.NICs+5);
opt.approach        = ft_getopt(opt, 'approach', 'defl');

if ~isfield(opt,'data');
    error('List of connectime .mat files not present!');
end

% add the fastica toolbox to path if its not already present
tmp = which('fastica');
if isempty(tmp)
   [status] = ft_hastoolbox('fastica', 1, 0);
   if ~status
       error('fastica toolbox failed to load correctly')
   end
end

% load and concatenate all the data for ICA. 
n_subs      = length(opt.data);
cmat_all    = [];

disp('Loading and concatenating connectomes :')
ft_progress('init', 'text', 'Please wait...')
pause(0.01)

for ii = 1:n_subs
    
    ft_progress(ii/n_subs, 'Processing connectome %d of %d', ii, n_subs);
    
    load(opt.data{ii});
    
    cmat_sub = zeros(size(cmat.connectivity{1,1},1),size(cmat.connectivity{1,1},2),size(cmat.connectivity{1,1},3));
    cmat_2d  = [];
    cmat_red = [];
    
    % loop across trials (there is clearly a more efficient process to do
    % this)
    for jj = 1:cmat.n_trials
        tmp = cmat.connectivity{jj};
        cmat_sub = cmat_sub+tmp;
    end   
    cmat_sub=cmat_sub/cmat.n_trials;
    
    % Do a DC correction on each connection
    l=size(cmat_sub,3);
    cmat_sub = cmat_sub-repmat(mean(cmat_sub,3),[1 1 size(cmat_sub,3)]);
    
    % flatten tensor into 2.5d (as the machine learning kids call it)
    cmat_2d = reshape(cmat_sub,78*78,length(cmat.time)*1);
    % as each slice of the tensor is symmetric, remove redundant data to
    % save some memory
    index = find(tril(squeeze(cmat_sub(:,:,1)))~=0);
    cmat_red = cmat_2d(index,:); 
%     cmat_redd=cmat_red-repmat(mean(cmat_red,2),[1,size(cmat_red,2)]);
%     cmat_redd=zscore(cmat_red);
    
    % concatenate onto the group level connectome data
    cmat_all = cat(2,cmat_all,cmat_red);
    sub_trials(ii) = cmat.n_trials;
    
end

disp('DONE')

[score,h] = nnmf(cmat_all,opt.NICs,'rep',100);
% [score,h] = nmf(cmat_all,NICs);
coeff=h';

% post processing of the NMF results 
tmp = reshape(coeff',opt.NICs,size(coeff',2)/n_subs,n_subs);
for ii=1:opt.NICs
    tmp_normal(ii,:,:)=zscore(tmp(ii,:,:));
end

% results.signals = zscore(tmp);
results.signals = tmp_normal;


for ii = 1:opt.NICs
    tmp = zeros(cmat.n_parcels,cmat.n_parcels);
    tmp(index) = score(:,ii);
    tmp = tmp + transpose(tmp);
    results.maps(:,:,ii) = tmp;
end


results.NICs        = opt.NICs;
results.n_trials    = sum(sub_trials);
results.sub_trials  = ones(1,n_subs);
%results.time        = round(cmat.time,2); %round not working with multiple
%inputs
results.time        = round(cmat.time*100)/100;
results.coeff=coeff;
results.score=score;
results.cmat_all=cmat_all;
results.cmat_sub=cmat_sub;
results.cmat_2d=cmat_2d;