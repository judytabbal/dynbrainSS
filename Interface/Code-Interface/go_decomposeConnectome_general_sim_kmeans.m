function results = go_decomposeConnectome_general_sim_kmeans(opt,varagin)

newS_noise=opt.newS_noise;
n_parcels=opt.n_parcels;
time_wind=opt.time_wind;
NICs=opt.NICs;
val=opt.val;


% flatten tensor into 2.5d (as the machine learning kids call it)
S_cmat_2d = reshape(newS_noise,n_parcels*n_parcels,time_wind);
% as each slice of the tensor is symmetric, remove redundant data to
% save some memory
S_index = find(tril(squeeze(newS_noise(:,:,1)))~=0);
S_cmat_red = S_cmat_2d(S_index,:); 

disp('Computing SS method...')

if(val==1)
    [idxx,C]=kmeans(S_cmat_red',NICs,'Distance','cityblock','MaxIter',200,'Start','Sample','Replicates',100);
elseif(val==2)
    [idxx,C]=kmeans(cmat_all',opt.NICs,'Distance','cityblock','MaxIter',200,'Start','Plus','Replicates',100);
end

S_score=C';

% post processing of the kmeans results 
signal=[];
idx_2d = reshape(idxx,size(idxx,1)/1,1);
counter_i=zeros(1,NICs);
pourc_i=zeros(1,NICs);

for ii = 1:NICs
    counter_i(ii) = sum(idxx==ii);
end
for ii=1:NICs
    pourc_i(ii)=counter_i(ii)/sum(counter_i)*100;
end

for ii=1:NICs
    for jj=1:size(idx_2d,1)
        signal(ii,jj)=sum(idx_2d(jj,:)==ii);
    end
end

S_signals = signal;

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