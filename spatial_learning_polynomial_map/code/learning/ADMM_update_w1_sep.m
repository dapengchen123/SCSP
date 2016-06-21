function w_1 = ADMM_update_w1_sep( w_3, mu_1, param)
%
%
      Rt = w_3-mu_1;
      H =param.H;
      rho = param.ADMMrho;
      scores = Rt'*param.feats;
      b = (scores-1)*rho;
      C = param.C_latent;
      ub = ones(size(H,1),1)*C/316;
      lb = zeros(size(H,1),1);
      alpha0 =zeros(size(H,1),1);
      options = optimoptions('quadprog','Algorithm','trust-region-reflective','TolFun',1e-15);
      [alpha,~,~,output] = quadprog(H,b,[],[],[],[],lb,ub,alpha0,options);
      w_1 = (param.feats)*alpha/rho+Rt;
end

