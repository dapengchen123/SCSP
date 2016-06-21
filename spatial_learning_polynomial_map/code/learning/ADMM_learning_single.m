%%%%%%%%%% ADMM learning %%%%%%%%%
% param.feats = S_feat_generation_single(param);


   
   w_l = ADMM(param);
   param = testing( w_l, param);

   
