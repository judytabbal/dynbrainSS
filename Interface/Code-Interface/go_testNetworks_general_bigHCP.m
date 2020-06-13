function perms = go_testNetworks_general_bigHCP(opt,results)

opt.p                   = ft_getopt(opt,'p',0.05);
opt.bonferroni_factor   = ft_getopt(opt,'bonferroni_factor',1);

n_subs1=20; n_subs2=20; n_subs3=length(results.sub_trials)-(n_subs1+n_subs2);
half_subs1 = floor(n_subs1/2); half_subs2 = floor(n_subs2/2); half_subs3 = floor(n_subs3/2);
n_perms1 = nchoosek(n_subs1,half_subs1); n_perms2 = nchoosek(n_subs2,half_subs2); n_perms3 = nchoosek(n_subs3,half_subs3);

sub_trial_end = cumsum(results.sub_trials);
sub_trial_start = [0 sub_trial_end(1:end-1)]+1;

sub_trial_end_1=sub_trial_end(1:n_subs1);
sub_trial_start_1=sub_trial_start(1:n_subs1);
sub_trial_end_2=sub_trial_end(1+n_subs1:n_subs2+n_subs1);
sub_trial_start_2=sub_trial_start(1+n_subs1:n_subs2+n_subs1);
sub_trial_end_3=sub_trial_end(1+n_subs1+n_subs2:n_subs3+n_subs1+n_subs2);
sub_trial_start_3=sub_trial_start(1+n_subs1+n_subs2:n_subs3+n_subs1+n_subs2);

new_sub_trial_start_2=sub_trial_start_2-sub_trial_start_2(1)+1;
new_sub_trial_end_2=sub_trial_end_2-sub_trial_start_2(1)+1;
new_sub_trial_start_3=sub_trial_start_3-sub_trial_start_3(1)+1;
new_sub_trial_end_3=sub_trial_end_3-sub_trial_start_3(1)+1;


ic_3d=results.signals;
ic_3d_1   = results.signals(:,:,sub_trial_start_1(1):sub_trial_end_1(end));
ic_3d_2   = results.signals(:,:,sub_trial_start_2(1):sub_trial_end_2(end));
ic_3d_3   = results.signals(:,:,sub_trial_start_3(1):sub_trial_end_3(end));
ic_null_1 = zeros(results.NICs,length(results.time),n_perms1);
ic_null_2 = zeros(results.NICs,length(results.time),n_perms2);
ic_null_3 = zeros(results.NICs,length(results.time),n_perms3);

disp('Testing results');
ft_progress('init', 'text', 'Please wait...')

for ii = 1:n_perms1
    
    scram_1 = randperm(n_subs1);
    my_trials_1 = [];

    for jj = 1:floor(n_subs1/2);
        my_trials_1 = [my_trials_1 sub_trial_start_1(scram_1(jj)):sub_trial_end_1(scram_1(jj))];
    end
    
    ic_flip_1 = ic_3d_1;
    ic_flip_1(:,:,my_trials_1) = -ic_flip_1(:,:,my_trials_1);
    ic_null_1(:,:,ii) = mean(ic_flip_1,3);
    ft_progress(ii/n_perms1, 'Permutation %d of %d', ii, n_perms1);
    
end

perms                   = struct;
perms.p                 = opt.p;
perms.bonferroni_factor = opt.bonferroni_factor;
perms.n_perms1           = n_perms1;

p_corr     = perms.p/perms.bonferroni_factor;
p_lower_1    = round(p_corr*perms.n_perms1); 
p_upper_1    = round((1-p_corr)*perms.n_perms1);

thresholds.upper_1 = zeros(results.NICs,length(results.time));
thresholds.lower_1 = zeros(results.NICs,length(results.time));

for ii = 1:results.NICs
    ic_ind_1 = squeeze(ic_null_1(ii,:,:));
    ic_sort_1 = sort(ic_ind_1','ascend');
    thresholds.lower_1(ii,:) = ic_sort_1(p_lower_1,:);
    thresholds.upper_1(ii,:) = ic_sort_1(p_upper_1,:);
end


for ii = 1:n_perms2
    
    scram_2 = randperm(n_subs2);
    my_trials_2 = [];

    for jj = 1:floor(n_subs2/2);
        my_trials_2 = [my_trials_2 new_sub_trial_start_2(scram_2(jj)):new_sub_trial_end_2(scram_2(jj))];
    end
    
    ic_flip_2 = ic_3d_2;
    ic_flip_2(:,:,my_trials_2) = -ic_flip_2(:,:,my_trials_2);
    ic_null_2(:,:,ii) = mean(ic_flip_2,3);
    ft_progress(ii/n_perms2, 'Permutation %d of %d', ii, n_perms2);
    
end

perms.n_perms2           = n_perms2;

p_lower_2    = round(p_corr*perms.n_perms2); 
p_upper_2    = round((1-p_corr)*perms.n_perms2);

thresholds.upper_2 = zeros(results.NICs,length(results.time));
thresholds.lower_2 = zeros(results.NICs,length(results.time));

for ii = 1:results.NICs
    ic_ind_2 = squeeze(ic_null_2(ii,:,:));
    ic_sort_2 = sort(ic_ind_2','ascend');
    thresholds.lower_2(ii,:) = ic_sort_2(p_lower_2,:);
    thresholds.upper_2(ii,:) = ic_sort_2(p_upper_2,:);
end


for ii = 1:n_perms3
    
    scram_3 = randperm(n_subs3);
    my_trials_3 = [];

    for jj = 1:floor(n_subs3/2);
        my_trials_3 = [my_trials_3 new_sub_trial_start_3(scram_3(jj)):new_sub_trial_end_3(scram_3(jj))];
    end
    
    ic_flip_3 = ic_3d_3;
    ic_flip_3(:,:,my_trials_3) = -ic_flip_3(:,:,my_trials_3);
    ic_null_3(:,:,ii) = mean(ic_flip_3,3);
    ft_progress(ii/n_perms3, 'Permutation %d of %d', ii, n_perms3);
    
end

perms.n_perms3           = n_perms3;

p_lower_3    = round(p_corr*perms.n_perms3); 
p_upper_3    = round((1-p_corr)*perms.n_perms3);

thresholds.upper_3 = zeros(results.NICs,length(results.time));
thresholds.lower_3 = zeros(results.NICs,length(results.time));

for ii = 1:results.NICs
    ic_ind_3 = squeeze(ic_null_3(ii,:,:));
    ic_sort_3 = sort(ic_ind_3','ascend');
    thresholds.lower_3(ii,:) = ic_sort_3(p_lower_3,:);
    thresholds.upper_3(ii,:) = ic_sort_3(p_upper_3,:);
end

thresholds.upper_all(1,:,:)=thresholds.upper_1 ; thresholds.upper_all(2,:,:)=thresholds.upper_2; thresholds.upper_all(3,:,:)=thresholds.upper_3;
thresholds.upper=squeeze(max(thresholds.upper_all));
thresholds.lower_all(1,:,:)=thresholds.lower_1 ; thresholds.lower_all(2,:,:)=thresholds.lower_2; thresholds.lower_all(3,:,:)=thresholds.lower_3;
thresholds.lower=squeeze(max(thresholds.lower_all));

perms.thresholds = thresholds;