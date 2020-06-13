function results = go_decomposeConnectome_general_sim_pca(opt,varagin)

newS_noise=opt.newS_noise;
n_parcels=opt.n_parcels;
time_wind=opt.time_wind;
NICs=opt.NICs;
 
% flatten tensor into 2.5d (as the machine learning kids call it)
S_cmat_2d = reshape(newS_noise,n_parcels*n_parcels,time_wind);
% as each slice of the tensor is symmetric, remove redundant data to
% save some memory
S_index = find(tril(squeeze(newS_noise(:,:,1)))~=0);
S_cmat_red = S_cmat_2d(S_index,:); 

disp('Computing SS method...')

[S_coeff, S_score, S_latent, S_tsquared, S_explained] = pca(S_cmat_red,'NumComponents', NICs);

% post processing of the PCA results 
tmp = reshape(S_coeff',NICs,size(S_coeff',2),1);
S_signals = tmp;

for ii = 1:NICs;
    tmp = zeros(n_parcels,n_parcels);
    tmp(S_index) = S_score(:,ii);
    tmp = tmp + transpose(tmp);
    S_maps(:,:,ii) = tmp;
end

% %% collect results
results.signals   = S_signals;
results.maps      = S_maps;
results.NICs      = NICs;
results.time      = [0.5:0.5:60];