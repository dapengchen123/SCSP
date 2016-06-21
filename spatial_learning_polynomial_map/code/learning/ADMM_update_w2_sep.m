function w_2 = ADMM_update_w2_sep(w_3, mu_2, param)
%
%  
      w_0 = w_3 - mu_2;
      w_l = w_0;
      rho = param.ADMMrho;
      gama = param.ADMMgama;
      alpha = gama/rho;
       dimM = param.dimM;
      diagMidx = param.diagMidx; 
         lambM = param.lambM;
      maskidxM = param.maskidxM;
      featdimM = param.featdimM; 
      
        dimS = param.dimS;
      diagSidx = param.diagSidx; 
         lambS = param.lambS;
      maskidxS = param.maskidxS;
      featdimS = param.featdimS; 
      %%%%%%% parameter setting %%%%%%%
          Lam = sqrt(2);
      dimension = param.dimension;
      w_reshape = reshape(w_l,dimension,[]);
     f_idx1 = 1:featdimM;
     f_idx2 = (featdimM+1):dimension;
      
     for col = 1:size(w_reshape,2)
         
        W1 = zeros(dimM, dimM);
        W1(maskidxM) = w_reshape(f_idx1,col);
        W1 = W1+W1';
        W1(diagMidx) = W1(diagMidx)*lambM*Lam/2;
        
        W2 = zeros(dimS, dimS);
        W2(maskidxS) = w_reshape(f_idx2, col);
        W2 = W2+W2';
        W2(diagSidx) = W2(diagSidx)*lambS*Lam/2;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         newW1 = Groupsparse_projection(W1, alpha);
         newW2 = Groupsparse_projection(W2, alpha);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         newW1s = (newW1+newW1')*0.5;
         newW2s = (newW2+newW2')*0.5;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         newW1s(diagMidx) = newW1s(diagMidx)/lambM/Lam;
         newW2s(diagSidx) = newW2s(diagSidx)/lambS/Lam;
        
         wMa = newW1s(maskidxM);
         w_reshape(f_idx1,col) = wMa;
         wSi  = newW2s(maskidxS);
         w_reshape(f_idx2,col) = wSi;
  
     end
          w_2 = w_reshape(:);

end

