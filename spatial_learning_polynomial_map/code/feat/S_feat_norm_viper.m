%%%%%%%%%%%%%% feature %%%%%%%%%%%%%%%
Norm_data = cell(feat_num,1);

for fk=1:feat_num
    data_fk = PCA_data{feat_set(fk)};
    UM = data_fk(1:dimM,:,:);
    US = data_fk(1:dimS,:,:); 
    layer_num = size(data_fk,3);
    tlen = size(data_fk,2);
    Uref = zeros(tlen/2,dimM,layer_num);
    Uref1 = zeros(tlen/2,dimS,layer_num );
    Utem = zeros(tlen/2,dimM,layer_num);
    Utem1 = zeros(tlen/2,dimS,layer_num);
    
    for layer = 1:layer_num
        UM_lay = UM(:,:,layer)';
        US_lay = US(:,:,layer)';
        %%%%%%%%%%%%%%%%%%%%%%%%
           for i =1:tlen/2
                   u_ref = UM_lay(i*2-1,:);
                   u_ref = u_ref/norm(u_ref,2);
               
                  u_ref1 = US_lay(i*2-1,:);
                  u_ref1 = u_ref1/norm(u_ref1,2);
                  
                   u_tem = UM_lay(i*2,:);
                   u_tem = u_tem/norm(u_tem,2);
                   
                  u_tem1 = US_lay(i*2,:);
                  u_tem1 = u_tem1/norm(u_tem1,2);
                  
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   Uref(i,:,layer)  = u_ref;
                  Uref1(i,:,layer) = u_ref1;
                   Utem(i,:,layer)  = u_tem;
                  Utem1(i,:,layer) = u_tem1;     
           end
    end
                 data.Uref = Uref;
                data.Uref1 = Uref1;
                 data.Utem = Utem;
                data.Utem1 = Utem1;
             Norm_data{fk} = data;
end
