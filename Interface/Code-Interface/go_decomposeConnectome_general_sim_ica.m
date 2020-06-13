function results = go_decomposeConnectome_general_sim_ica(opt,varagin)

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

if(opt.val==1) %JADE
    [B_jade] = jader(S_cmat_red, NICs);
    S_A=B_jade';
    S_icasig=B_jade*S_cmat_red; 
elseif(opt.val==2) %INFOMAX
    [weights,sphere] = runica(S_cmat_red,'pca',NICs,'ncomps',NICs);
    B_info=weights*sphere;
    S_A=B_info';
    S_icasig=B_info*S_cmat_red;
elseif(opt.val==3) %SOBI
    [S_A, S_icasig] = sobi_edit(S_cmat_red, NICs); 
elseif(opt.val==4) %FastICA    
    [S_icasig, S_A, S_W] = fastica(S_cmat_red, 'g', 'tanh', 'lastEig', opt.NPCs, 'numOfIC', NICs,'approach','defl','maxNumIterations',10000, 'epsilon', 0.001);
    % [S_iq, S_A, S_W, S_icasig, S_sR]=icasso(S_cmat_red,20,'g','tanh','lastEig',NICs,'vis','off');
elseif(opt.val==5) %COM2    
    [F,delta]=aci(S_cmat_red,NICs);
    Fcomp=F(:,1:NICs);
    S_icasig=Fcomp'*S_cmat_red;
    S_A=Fcomp;
elseif(opt.val==6) %PSAUD    
    tau=1;
    P=NICs;
    Nit=20;
    alpha_min=0;
    alpha_max=10;
    [F,S]=P_SAUD(S_cmat_red,tau,P,Nit,alpha_min,alpha_max);
    S_A=F; %estimated mixing matrix
    S_icasig=S; %estimated signal matrix
end

% post processing of the ICA results 
tmp = reshape(S_icasig,NICs,size(S_icasig,2),1);
S_signals = tmp;

for ii = 1:NICs;
    tmp = zeros(n_parcels,n_parcels);
    tmp(S_index) = S_A(:,ii);
    tmp = tmp + transpose(tmp);
    S_maps(:,:,ii) = tmp;
end


% %% collect results
results.signals   = S_signals;
results.maps      = S_maps;
results.NICs      = NICs;
results.time      = [0.5:0.5:60];