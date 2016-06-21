function  w_3 = ADMM_update_w3_sep(w_1,w_2,mu_1,mu_2,param)
%
%  
        w_l = 0.5*(w_1+w_2+mu_1+mu_2);
       dimM = param.dimM;
      diagMidx = param.diagMidx; 
         lambM = param.lambM;
      maskidxM = param.maskidxM;
      featdimM = param.featdimM; 
           Lam = sqrt(2);
     dimension = param.dimension;
     w_reshape = reshape(w_l,dimension,[]);
     f_idx1 = 1:featdimM;
     
     for col = 1:size(w_reshape,2)
          W1 = zeros(dimM, dimM);
          W1(maskidxM) = w_reshape(f_idx1,col);
          W1 = W1+W1';
          W1(diagMidx) = W1(diagMidx)*lambM*Lam/2;
          [V1, D1] = eig(W1);
          d1 = diag(D1);
          d1(d1>0)=0;
          W1 = V1*diag(d1)*V1';
          W1(diagMidx)=W1(diagMidx)/lambM/Lam;
          wMa = W1(maskidxM);
          w_reshape(f_idx1,col)=wMa;
     end
     
       w_3 = w_reshape(:);

end

