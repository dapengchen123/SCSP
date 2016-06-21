function param = testing( w, param )
%
%   
     Ntr = param.Ntr; 
     Nte = param.Nte;
     [ Ws_1, Ws_2] = weight_transform( w, param );
     feat_num = param.feat_num;
     lf_num = size(Ws_1,3);
    %%%%%%%%%% training accuracy %%%%%%%% 
     Trn_Scores = zeros(Ntr,Ntr,lf_num);
     lf = 1;
     for f = 1:feat_num
          data_fk = param.Trndata{f};
          urefs = data_fk.uref;
          uref1s = data_fk.uref1;
          u_tems = data_fk.utem;
          u_tem1s = data_fk.utem1;
          %%%%%%%%%%%%%%%%%%%%%%%%%%%
           layer_num = size(urefs,3);
            for lay = 1:layer_num
               urefs_lay   = urefs(:,:,lay);
               uref1s_lay  = uref1s(:,:,lay);
               u_tems_lay  = u_tems(:,:,lay);
               u_tem1s_lay = u_tem1s(:,:,lay);
               W1_lay = Ws_1(:,:,lf);
               W2_lay = Ws_2(:,:,lf);
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for sn = 1:Ntr
                  u_ref_lay  = urefs_lay(sn,:);
                  u_ref1_lay = uref1s_lay(sn,:);
                  diff_ref = bsxfun(@minus,u_ref_lay, u_tems_lay);
                  Escore = sum((diff_ref*W1_lay).*diff_ref,2);
                  Sscore = u_ref1_lay*W2_lay*u_tem1s_lay'*2;
                  score = Sscore'+Escore;
                  Trn_Scores(sn,:,lf) = score;
                end
                
                if layer_num ==1
                     Trn_Scores(:,:,lf) = Trn_Scores(:,:,lf)*param.omega;
                end
                 
                 lf = lf+1;
                 
            end  
            
     end
     
         Trn_Score_total = sum(Trn_Scores,3);
              loss_trn = zeros(Ntr,1);
              for st = 1:Ntr
                score_com = Trn_Score_total(st,:);
                [~, Ii] = sort(score_com,'descend');
                loss_trn(st)=(find(Ii==st)-1); 
              end
         fprintf('rank-1 rate of the  training data is %f ...\n', sum(loss_trn==0)/Ntr); 
         fprintf('rank-10 rate of the training data is %f ...\n', sum(loss_trn<=9)/Ntr); 
         fprintf('rank-15 rate of the training data is %f ...\n', sum(loss_trn<=14)/Ntr); 
         fprintf('rank-20 rate of the training data is %f ...\n', sum(loss_trn<=19)/Ntr); 
         fprintf('rank-25 rate of the training data is %f ...\n', sum(loss_trn<=24)/Ntr); 
         fprintf('rank-50 rate of the training data is %f ...\n', sum(loss_trn<=49)/Ntr);  
     
         %%%%%%%%%%% testing accuracy %%%%%%%%%%%%%%%%%
         Tst_Scores = zeros(Nte,Nte,lf_num);
          lf = 1;
         for f = 1:feat_num
              data_fk = param.Tstdata{f};
              urefs = data_fk.uref;
              uref1s = data_fk.uref1;
              u_tems = data_fk.utem;
              u_tem1s = data_fk.utem1;
              layer_num = size(urefs,3);
              for lay = 1:layer_num
                   urefs_lay   = urefs(:,:,lay);
                   uref1s_lay  = uref1s(:,:,lay);
                   u_tems_lay  = u_tems(:,:,lay);
                   u_tem1s_lay = u_tem1s(:,:,lay);
                   W1_lay = Ws_1(:,:,lf);
                   W2_lay = Ws_2(:,:,lf);
                   for sn = 1:Nte
                      u_ref_lay  = urefs_lay(sn,:);
                      u_ref1_lay = uref1s_lay(sn,:);
                      diff_ref = bsxfun(@minus,u_ref_lay, u_tems_lay);
                      Escore = sum((diff_ref*W1_lay).*diff_ref,2);
                      Sscore = u_ref1_lay*W2_lay*u_tem1s_lay'*2;
                      score = Sscore'+Escore;
                      Tst_Scores(sn,:,lf) = score;
                   end  
                      lf = lf+1;
              end
         end
%                 Tst_Scores = sum(Tst_Scores,4);
                 Tst_Score_total = sum(Tst_Scores,3);
                 loss_tst = zeros(Nte,1);
                 for st = 1:Nte
                   score_com = Tst_Score_total(st,:);
                   [~, Ii] = sort(score_com,'descend');
                   loss_tst(st)=(find(Ii==st)-1); 
                 end
                 
           fprintf('rank-1 rate of the  testing data is %f ...\n', sum(loss_tst==0)/Nte); 
           fprintf('rank-10 rate of the testing data is %f ...\n', sum(loss_tst<=9)/Nte); 
           fprintf('rank-15 rate of the testing data is %f ...\n', sum(loss_tst<=14)/Nte); 
           fprintf('rank-20 rate of the testing data is %f ...\n', sum(loss_tst<=19)/Nte); 
           fprintf('rank-25 rate of the testing data is %f ...\n', sum(loss_tst<=24)/Nte); 
           fprintf('rank-50 rate of the testing data is %f ...\n', sum(loss_tst<=49)/Nte);
           param.loss_tst = loss_tst;
end

