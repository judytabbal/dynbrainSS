function results = go_decomposeConnectome_general_kmeans(opt,varagin)

opt.NICs            = ft_getopt(opt, 'NICs', 10);

if ~isfield(opt,'data');
    error('List of connectime .mat files not present!');
end


% load and concatenate all the data for kmeans. 
n_subs      = length(opt.data);
cmat_all    = [];
cmat_all_k    = [];

disp('Loading and concatenating connectomes :')
ft_progress('init', 'text', 'Please wait...')
pause(0.01)

for ii = 1:n_subs
    
    ft_progress(ii/n_subs, 'Processing connectome %d of %d', ii, n_subs);
    
    load(opt.data{ii});
    
    cmat_sub = [];
    cmat_2d  = [];
    cmat_red = [];
    cmat_sub_k = zeros(3003,length(cmat.time));
    
    % loop across trials (there is clearly a more efficient process to do
    % this)
    for jj = 1:cmat.n_trials
        tmp = cmat.connectivity{jj};
        cmat_sub = cat(3,cmat_sub,tmp);

    cmat_2d_k = reshape(tmp,78*78,length(cmat.time));
    index_k = find(tril(squeeze(tmp(:,:,1)))~=0);
    cmat_red_k = cmat_2d_k(index_k,:); 
    cmat_sub_k=cmat_sub_k+cmat_red_k;
    
    end   
    
    % Do a DC correction on each connection
    cmat_sub = cmat_sub-repmat(mean(cmat_sub,3),[1 1 length(cmat_sub)]);
    
    % flatten tensor into 2.5d (as the machine learning kids call it)
    cmat_2d = reshape(cmat_sub,78*78,length(cmat.time)*cmat.n_trials);
    % as each slice of the tensor is symmetric, remove redundant data to
    % save some memory
    index = find(tril(squeeze(cmat_sub(:,:,1)))~=0);
    cmat_red = cmat_2d(index,:); 
    
    cmat_sub_k=cmat_sub_k./cmat.n_trials;
    cmat_all_k = cat(3,cmat_all_k,cmat_sub_k);
    
    % concatenate onto the group level connectome data
    cmat_all = cat(2,cmat_all,cmat_red);
    sub_trials(ii) = cmat.n_trials;
    
end

disp('DONE')
disp('Computing SS method...')

if(opt.val==1)
    [idxx,C]=kmeans(cmat_all',opt.NICs,'Distance','cityblock','MaxIter',200,'Start','Sample','Replicates',100);
elseif(opt.val==2)
    [idxx,C]=kmeans(cmat_all',opt.NICs,'Distance','cityblock','MaxIter',200,'Start','Plus','Replicates',100);
end

score=C';

% post processing of the kmeans results 
signal=[];
idx_2d = reshape(idxx,size(idxx,1)/sum(sub_trials),sum(sub_trials));

for nn=1:opt.NICs
    iddd=find(idx_2d==nn);
    idx_2d_new=idx_2d; idx_2d_new(:)=0; idx_2d_new(iddd)=1;
    idx_2d_new_all(nn,:,:)=idx_2d_new;
end

for ii=1:opt.NICs
    for jj=1:size(idx_2d,1)
        signal(ii,jj)=sum(idx_2d(jj,:)==ii);
    end
end

for ii=1:opt.NICs
    idx_2d_new_all_normal(ii,:,:)=zscore(idx_2d_new_all(ii,:,:));
end

results.signals = idx_2d_new_all_normal;
results.signals2(:,:,1) = signal;
results.signals2(:,:,2) = signal;

for ii = 1:opt.NICs;
    tmp = zeros(cmat.n_parcels,cmat.n_parcels);
    tmp(index) = score(:,ii);
    tmp = tmp + transpose(tmp);
    results.maps(:,:,ii) = tmp;
end

results.NICs        = opt.NICs;
results.n_trials    = sum(sub_trials);
results.sub_trials  = sub_trials;
results.time        = round(cmat.time*100)/100;