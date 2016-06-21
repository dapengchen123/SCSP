if exist([pca_dir '\' PCA_name],'file')
     load([pca_dir '\' PCA_name]);
else
     error('no such PCA data!'); 
end
