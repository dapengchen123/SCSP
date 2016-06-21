function w_3 = ADMM(param)
%
%   
    gen_feat = param.feats;
    w_l = zeros(size(gen_feat(:,1))); 
    H = (gen_feat)'*(gen_feat);
    w_3 = w_l;
    mu_1 = zeros(size(w_l));
    mu_2 = zeros(size(w_l));
    param.H = H;
    param.ADMMrho = 0.001;
    param.C_latent = 1;
    param.ADMMgama = 3e-4;
    
    for i =1:20
         w_1 = ADMM_update_w1_sep(w_3, mu_1, param);
         w_2 = ADMM_update_w2_sep(w_3 ,mu_2, param);
         w_3 = ADMM_update_w3_sep(w_1,w_2,mu_1,mu_2,param);
         mu_1 = mu_1 + w_1 - w_3;
         mu_2 = mu_2 + w_2 - w_3;
    end
    
end
