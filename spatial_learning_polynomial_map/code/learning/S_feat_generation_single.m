function  Phis = S_feat_generation_single( param)
%
% 
       pattern_num = param.Ntr;
       pattern_dim = param.dimension;
       feat_num = param.feat_num;
%        = param.laynum;
%        Phis = zeros(pattern_dim,laynum,feat_num, pattern_num);
         Phis = [];
       for f = 1:feat_num  
           Trndataf = param.Trndata{f};
           uref = Trndataf.uref;
          uref1 = Trndataf.uref1;
           utem = Trndataf.utem;
          utem1 = Trndataf.utem1;
          laynum = size(uref,3);
          phis = zeros(pattern_dim,laynum,pattern_num);
          %%%%%%%%%%%%%%%%%%%%%%%%%%% 
          for lay = 1:laynum
              uref_lay = uref(:,:,lay);
              uref1_lay = uref1(:,:,lay);
              utem_lay = utem(:,:,lay);
              utem1_lay = utem1(:,:,lay);
              for i=1:pattern_num
                   f_label = -ones(1,param.Ntr);
                   f_label(i) = (param.Ntr-1);
                   u_i = uref_lay(i,:);
                   u1_i = uref1_lay(i,:);
                   %%%%%%%%%%%%%%%%%%
                   feature = efficient_feat(u_i,u1_i,utem_lay',utem1_lay',param,f_label);
                   phis(:,lay,i) = feature'/(pattern_num-1);
                   
              end
          end
          
              if laynum ==1
                  phis = phis*param.omega;
              end
          
               Phis = cat(2,Phis,phis);
       end
               Phis = Phis/size(Phis,2);
               Phis = reshape(Phis,[],pattern_num);
end

