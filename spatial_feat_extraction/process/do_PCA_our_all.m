function PCA_data =  do_PCA_our_all(data)
%
%    data      
%
     tlen = size(data,2);
     Xtrn = data';
     [Coeff,~,latent] = pca(Xtrn);
     meana = mean(Xtrn,1);
     tic;
     ux = (data'-repmat(meana,tlen,1))*Coeff; 
     ux = ux./repmat(sqrt(latent')+eps,tlen,1);
     toc;
     PCA_data = ux';
end

