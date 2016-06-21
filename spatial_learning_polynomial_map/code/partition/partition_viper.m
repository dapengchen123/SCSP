%%%%%%%%% partition viper %%%%%%%%%%
if exist([feat_dir, 'partition_viper.mat'],'file')
     load([feat_dir 'partition_viper.mat']);
else
     partitionviper;
     save([feat_dir, 'partition_viper.mat'],'parti');    
end
