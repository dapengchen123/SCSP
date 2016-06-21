%%%%%%%%%%%%%%% feature_prepare %%%%%%%%%%%%%%
feat_normalization = 1;
dimM =  PCA_dim-30;
dimS =  PCA_dim;
lambM = 1;
lambS = 1;
featdimM = sum(1:dimM);
maskidxM = zeros(1,featdimM); 
featdimS = sum(1:dimS);
maskidxS = zeros(1,featdimS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
for dimi=1:dimM
     for dimj=1:dimi
         maskidxM(k)=(dimi-1)*dimM+dimj;
         k=k+1;
     end
end
k=1;
for dimi=1:dimS
     for dimj=1:dimi
         maskidxS(k)=(dimi-1)*dimS+dimj;
         k=k+1;
     end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 diagMidx = find(diag(ones(1,dimM))); 
 diagSidx = find(diag(ones(1,dimS)));
 if(feat_normalization)
      S_feat_norm_viper;
 end
 %%%%%%%%%%%%%%%%%%
 param.dimM = dimM;
 param.lambM = lambM;
 param.dimS = dimS;
 param.lambS = lambS;
 %%%%%%%%%%%%%%%%%%%
param.featdimS = featdimS;
param.maskidxS = maskidxS;
param.featdimM = featdimM;
param.maskidxM = maskidxM;
param.diagMidx = diagMidx;
param.diagSidx = diagSidx;
 %%%%%%%%%%%%%%%%%%%%%
param.dimension = featdimS+featdimM;
param.Cs = 1;
param.Ntr = Ntr;
param.Nte = Nte;
param.feat_num = feat_num;
param.laynum = layer_num;
param.trnSet = trnSet;
param.tstSet = tstSet;
 %%%%%%  data preparing  %%%%%%
 Train_data = cell(feat_num,1);
  Test_data = cell(feat_num,1);
  
for featkind = 1:feat_num
    data_fk = Norm_data{featkind};
      Uref = data_fk.Uref;
      Uref1 = data_fk.Uref1;
       Utem = data_fk.Utem;
      Utem1 = data_fk.Utem1;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%
       Trndata.uref = Uref(trnSet,:,:);
       Trndata.uref1= Uref1(trnSet,:,:);
       Trndata.utem = Utem(trnSet,:,:);
       Trndata.utem1= Utem1(trnSet,:,:);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       Tstdata.uref = Uref(tstSet,:,:);
       Tstdata.uref1= Uref1(tstSet,:,:);
       Tstdata.utem = Utem(tstSet,:,:);
       Tstdata.utem1= Utem1(tstSet,:,:);
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       Train_data{featkind} = Trndata;
        Test_data{featkind} = Tstdata; 
end
        
        param.Trndata = Train_data;
        param.Tstdata = Test_data;
 
 
 
 
 

