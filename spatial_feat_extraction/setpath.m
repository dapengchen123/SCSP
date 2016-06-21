 project_dir = strcat(pwd, '\');
 addpath('./process');
 dataset_dir = strcat(project_dir, 'dataset\', dataset);
 if ~exist(dataset_dir ,'dir')
     mkdir(dataset_dir);
 end
 

 
 dnorm_dir = strcat(project_dir, 'datanorm\'); 
 if ~exist(dnorm_dir,'dir')
     mkdir(dnorm_dir);
 end
 dnorm_dir = strcat(project_dir, 'datanorm\',dataset,'\');
  if ~exist(dnorm_dir,'dir')
     mkdir(dnorm_dir);
   end
 
 cache_dir = strcat(project_dir,'cache\',dataset,'\');
     temp_dir = strcat(cache_dir,'temp\');
     feat_dir = strcat(cache_dir, 'feat\',feattype); 
     
if ~exist(cache_dir, 'dir')
    mkdir(cache_dir);
end


if ~exist(feat_dir, 'dir')
    mkdir(feat_dir); 
end
