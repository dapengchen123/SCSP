 project_dir = strcat(pwd, '\');
 addpath(genpath(strcat(project_dir, 'code\')));
 dataset_dir = strcat(project_dir, 'dataset\', dataset);
 dnorm_dir = strcat(project_dir, 'datanorm\'); 
 
 
 cache_dir = strcat(project_dir,'cache\',dataset,'\');

  temp_dir = strcat(cache_dir,'temp\');
 if ~exist(temp_dir,'dir') 
    mkdir(temp_dir);
 end

  feat_dir = strcat(cache_dir, 'feat_new\');
 if ~exist(feat_dir,'dir')
    mkdir(feat_dir);
 end
 
 pca_dir  = strcat(cache_dir, 'pca_new');
 if ~exist(pca_dir,'dir')
    mkdir(pca_dir);
 end
 
 
    
if ~exist(cache_dir, 'dir')
    mkdir(dnorm_dir);
    mkdir(cache_dir);
    mkdir(temp_dir); 
    mkdir(dnorm_dir);
end
