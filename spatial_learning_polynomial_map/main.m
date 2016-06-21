dataset = 'viper';
setpath;
PCA_name = 'viper_mix_HSV_LAB_HOG_SPLIT-full-8-8-31-31.mat';
Ntr = 316;
Nte = 316;
LOSS2 = zeros(10, Nte);
res_typical = zeros(10, 5);
feat_num = 8;
featkinds = [1 2 3 4 5 6 7 8 ];
feat_set = featkinds;
param.omega = 1.1;

for kk =1:10
      fprintf('processing the %d th partition ...\n',kk);
      TRIAL = kk;
      partition_viper;
      trnSet = parti(kk).trnSet;
      tstSet = parti(kk).tstSet;
      %%%%%%%%%%%%%%%
      PCA_load;
      PCA_dim =120; 
      feature_prepare;
      param.feats = S_feat_generation_single(param);
     
      ADMM_learning_single;
      loss_tst =param.loss_tst;
      res_typical(kk,:) = [sum(loss_tst==0)/Nte, sum(loss_tst<=4)/Nte ,sum(loss_tst<=9)/Nte, sum(loss_tst<=19)/Nte, sum(loss_tst<=49)/Nte];
      LOSS2(kk,:) = loss_tst;
end
      savename =sprintf('single-LOSS2-with-omega%f.mat',omega);
      mean( res_typical,1)
      save(savename,'LOSS2');
