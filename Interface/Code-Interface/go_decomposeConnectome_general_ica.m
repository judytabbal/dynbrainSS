function results = go_decomposeConnectome_general_ica(opt,varagin)

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


if(opt.val==1)
    [B] = jader(cmat_all, opt.NICs);
    A=B';
    icasig=B*cmat_all; 
elseif(opt.val==2)
    [weights,sphere] = runica(cmat_all,'pca',opt.NICs,'ncomps',opt.NICs);
    B=weights*sphere;
    A=B';
    icasig=B*cmat_all; 
elseif(opt.val==3)
    [A, icasig] = sobi_edit(cmat_all, opt.NICs);
elseif(opt.val==4)
%     [icasig, A, W] = fastica(cmat_all, 'g', 'tanh','lastEig', opt.NPCs, 'numOfIC', opt.NICs,'approach','defl');
    [iq, A, W, icasig, sR]=icasso(cmat_all,100,'g','tanh','lastEig', opt.NICs,'numOfIC', opt.NICs,'approach','defl','vis','off');
elseif(opt.val==5)
    [F, delta] = aci(cmat_all,opt.NICs);
    icasig=F'*cmat_all;
    A=F;
elseif(opt.val==6)
    tau=1;
    P=opt.NICs;
    Nit=20;
    alpha_min=0;
    alpha_max=50;
    [F,S]=P_SAUD(cmat_all,tau,P,Nit,alpha_min,alpha_max);
    A=F; %estimated mixing matrix
    icasig=S; %estimated signal matrix
end

% post processing of the ICA results 
tmp = reshape(icasig,opt.NICs,size(icasig,2)/sum(sub_trials),sum(sub_trials));
results.signals = tmp;

for ii = 1:opt.NICs;
    tmp = zeros(cmat.n_parcels,cmat.n_parcels);
    tmp(index) = A(:,ii);
    tmp = tmp + transpose(tmp);
    results.maps(:,:,ii) = tmp;
end

results.NICs        = opt.NICs;
results.NPCs        = opt.NPCs;
results.approach    = opt.approach;
results.n_trials    = sum(sub_trials);
results.sub_trials  = sub_trials;
results.time        = round(cmat.time*100)/100;
results.icasig=icasig;
results.mixing=A;