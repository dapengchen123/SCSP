function  S_PCAfull_data = S_PCA_ourall(Descell, index_sep )
%
%  
       numImg = size(Descell{1},3);
       S_layer = size(index_sep,1);
       feat_dim = 300;
       S_PCAfull_data = zeros(feat_dim,numImg,S_layer);
       for l = 1:S_layer
           start_ind = index_sep(l,1);
           end_ind = index_sep(l,2);
           data = [];
           for dd = 1:length(Descell)
             descriptors_sep = Descell{dd};
             des_S = descriptors_sep(:,start_ind:end_ind,:);
             data_d = reshape(des_S,[],numImg);
             data_d = normc(data_d);
             data = cat(1,data,data_d);
           end
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           tlen = size(data,2);
           Xtrn = data';
           [Coeff,~,latent] = pca(Xtrn);
           meana = mean(Xtrn,1);
           ux = (data'-repmat(meana,tlen,1))*Coeff; 
           ux = ux./repmat(sqrt(latent')+eps,tlen,1);
           PCA_data = ux';
           S_PCAfull_data(:,:,l) = PCA_data(1:feat_dim,:);
       end

end

