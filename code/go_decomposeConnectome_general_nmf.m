function results = go_decomposeConnectome_general_nmf(opt,varagin)

opt.NICs            = ft_getopt(opt, 'NICs', 10);

if ~isfield(opt,'data');
    error('List of connectime .mat files not present!');
end

% load and concatenate all the data for NMF. 
n_subs      = length(opt.data);
cmat_all    = [];

disp('Loading and concatenating connectomes :')
ft_progress('init', 'text', 'Please wait...')
pause(0.01)

for ii = 1:n_subs
    
    ft_progress(ii/n_subs, 'Processing connectome %d of %d', ii, n_subs);
    
    load(opt.data{ii});
    
    cmat_sub = [];
    cmat_2d  = [];
    cmat_red = [];
    
    % loop across trials (there is clearly a more efficient process to do
    % this)
    for jj = 1:cmat.n_trials
        tmp = cmat.connectivity{jj};
        cmat_sub = cat(3,cmat_sub,tmp);
    end   
    
    % Do a DC correction on each connection
    l=length(cmat_sub);
    cmat_sub = cmat_sub-repmat(mean(cmat_sub,3),[1 1 length(cmat_sub)]);
    
    % flatten tensor into 2.5d (as the machine learning kids call it)
    cmat_2d = reshape(cmat_sub,78*78,length(cmat.time)*cmat.n_trials);
    % as each slice of the tensor is symmetric, remove redundant data to
    % save some memory
    index = find(tril(squeeze(cmat_sub(:,:,1)))~=0);
    cmat_red = cmat_2d(index,:); 
    
    % concatenate onto the group level connectome data
    cmat_all = cat(2,cmat_all,cmat_red);
    sub_trials(ii) = cmat.n_trials;
    
end

disp('DONE')
disp('Computing SS method...')


[score,h] = nnmf(cmat_all,opt.NICs,'rep',100);
coeff=h';

% post processing of the NMF results 
tmp = reshape(coeff',opt.NICs,size(coeff',2)/sum(sub_trials),sum(sub_trials));
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
results.sub_trials  = sub_trials;
results.time        = round(cmat.time*100)/100;