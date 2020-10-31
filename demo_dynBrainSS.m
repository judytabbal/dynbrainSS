%% 15 subjects _ button press motor MEG
subject         = { '001'; '002' ; '003' ; '004' ; '005'; '006' ; '007' ; '008' ; '009'; '010' ; '011' ; '012' ; '013'; '014' ; '015'};
for i=1:15
    files.base      = ['C:\Users\imanm\Desktop\PhD\Matlab\DATA\data_MEG\self_paced\' subject{i}]; %path for self-paced button press data dynamic connectiviy matrices
     cmat_list{i} = [files.base '_demo.mat'];     
end

%% 19 subjects _ WM Strenberg MEG
subject         = { '001'; '002' ; '003' ; '004' ; '005'; '006' ; '007' ; '008' ; '009'; '010' ; '011' ; '012' ; '013'; '014' ; '015'; '016' ; '017'; '018' ; '019'};   
for sub_ind = 1:length(subject)
files.base      = ['C:\Users\imanm\Desktop\PhD\Matlab\DATA\data_MEG\slow_sternberg\' subject{sub_ind}]; %path for WM data dynamic connectiviy matrices
cmat_list{sub_ind} = [files.base '_demo.mat'];
end

%% 61 subjects _ HCP LH motor MEG 
subject         = { '104012'; '105923' ; '106521' ; '108323' ; '109123'; '113922' ; '116726' ; '125525'; '133019'; '140117'; '151526'; '153732'; '156334'; '162026'; '162935'; '164636'; '169040'; '175237'; '177746'; '185442'; '189349'; '191033'; '191437'; '191841'; '192641'; '198653'; '200109'; '204521'; '205119'; '212318'; '212823'; '221319' ; '250427' ; '255639' ; '257845'; '283543' ; '287248' ; '293748'; '353740'; '358144'; '406836'; '500222'; '559053'; '568963'; '581450'; '599671'; '601127' ; '660951' ; '662551' ; '667056'; '679770' ; '680957' ; '706040'; '707749'; '725751'; '735148'; '783462'; '814649'; '891667'; '898176'; '912447' };
for sub_ind=1:length(subject)
    files_base=['E:\HCP-LH1-IAC\' subject{sub_ind}]; %path for HCP LH data dynamic connectiviy matrices
    cmat_list{sub_ind} = [files_base '_inst_orth_beta_alldemo.mat'];  
end

%% common code
cfg             = [];
cfg.NICs        = 5;
NICs=cfg.NICs;
cfg.data        = cmat_list;

%% Decompose the tensor _ ICA
tic
cfg.val        = 1; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6:PSAUD
% results         = go_decomposeConnectome_general_ica(cfg); %data 1 and 3
results         = go_decomposeConnectome_general_ica_HCPinst(cfg); %HCP
timeElapsed = toc

%% Decompose the tensor _ PCA 
tic
% results         = go_decomposeConnectome_general_pca(cfg);
results         = go_decomposeConnectome_general_pca_HCPinst(cfg); %HCP
timeElapsed = toc

%% Decompose the tensor _ NMF 
tic
% results         = go_decomposeConnectome_general_nmf(cfg);
results         = go_decomposeConnectome_general_nmf_HCPinst(cfg); %HCP
timeElapsed = toc

%% Decompose the tensor _ kmeans
tic
cfg.val=1; % 1=Sample init, 2=Plus init, 3=7wind/subj init, 4=1subj init
% results         = go_decomposeConnectome_general_kmeans(cfg);
results         = go_decomposeConnectome_general_Kmeans_HCPinst(cfg); %HCP
timeElapsed=toc

%% Run group significance test 
cfg                     = [];
cfg.p                   = 0.05;
cfg.data_id=1; cfg.bonferroni_factor   = 2*NICs*8; % 2 tails x 10 ICs x 8 DOFs for motor oneill
% cfg.data_id=2; cfg.bonferroni_factor   = 2*NICs*12; % 2 tails x 10 ICs x 12 DOFs for memory oneill

perms           = go_testNetworks_general(cfg,results); % for data 1 and 3
% perms           = go_testNetworks_general_bigHCP(cfg,results); % for data 2 HCP


%% View the results

cfg             = [];
cfg.threshold   = 0.7;
cfg.label=0; %1:if yes labels, 0:if no labels

flip_vec=go_viewNetworkComponents_general_concat_interface(cfg,results,perms);
