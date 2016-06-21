function data_processing(dataset, dataset_dir, dnorm_dir)
%
%  
     
%%%%%%% 'case'  'viper' %%%%%%
  if strcmp(dataset,'viper') == 1
     files_a = dir([dataset_dir, '\cam_a\*.bmp']);
     files_b = dir([dataset_dir, '\cam_b\*.bmp']);
     np  = length(files_a);
        
     disp('normalizing the data...');
     for p = 1:np
          img_a = imread([dataset_dir,'\cam_a\',files_a(p).name]);
          img_b = imread([dataset_dir,'\cam_b\',files_b(p).name]);
          name_a = sprintf('%04d%03d.png', p, 1);
          name_b = sprintf('%04d%03d.png', p, 2);                    
          imwrite(img_a, [dnorm_dir, name_a]);
          imwrite(img_b, [dnorm_dir, name_b]);        
     end
           disp('finish normalizing...');
  elseif strcmp(dataset,'grid') == 1
       filesg = dir([dataset_dir, '\gallery\*.jpeg']);
       filesp = dir([dataset_dir, '\probe\*.jpeg']);
       hgt_img = 128; 
       wid_img = 48;
       for i=1:(length(filesg)-250)
             img = imread([dataset_dir,'\gallery\',filesg(i).name]); 
             img_new = imresize(img,[hgt_img,wid_img],'bilinear');
             img_crop = img_new;
             name_i  = sprintf('%04d.png',i+500);
             imwrite(img_crop,[dnorm_dir,'\', name_i]);
       end
       
       gbase = length(filesg)-250;
       
       for i= 1:250
           img = imread([dataset_dir,'\gallery\',filesg(i+gbase).name]); 
           img_new = imresize(img,[hgt_img,wid_img],'bilinear');
           img_crop = img_new;
           name_i = sprintf('%04d.png',i*2-1); 
           imwrite(img_crop,[dnorm_dir,'\', name_i]);
       end
       
       for j=1:250
           img = imread([dataset_dir,'\probe\',filesp(j).name]);
           img_new = imresize(img,[hgt_img,wid_img],'bilinear');
           img_crop = img_new;
           name_j = sprintf('%04d.png',j*2);
           imwrite(img_crop,[dnorm_dir,'\',name_j]); 
       end
  elseif strcmp(dataset,'threedpes') == 1
        hgt_img1 = 128; 
        wid_img1 = 60; 
        
        hgt_img = 128; 
        wid_img = 48; 
        k = 1;
        Img_id_align = [];
        for i = 1:192
            i_names = sprintf('%04d',i);
            i_files = dir([dataset_dir ,'\', i_names '*.bmp']);
            for j = 1:length(i_files)
                img_j = imread([dataset_dir,'\', i_files(j).name]);
                img_new = imresize(img_j,[hgt_img1,wid_img1],'bilinear');
                img_crop = img_new(6:120,6:55,:);
                img = imresize(img_crop,[hgt_img, wid_img],'bilinear'); 
                name_j =  sprintf('%04d.png', k);
                imwrite(img,[dnorm_dir,'\',name_j]); 
                Img_id_align = [Img_id_align, i];         
                k = k + 1;
            end    
                 save([dnorm_dir,'\IDX_threedpes'] , 'Img_id_align');        
        end
  elseif strcmp(dataset,'ilids') == 1
        hgt_img1 = 128; 
        wid_img1 = 60; 
        
        hgt_img = 128; 
        wid_img = 48; 
        
        k = 1;
        Img_id_align = [];
        
       for i = 1:119
            i_names = sprintf('%04d',i);
            i_files = dir([dataset_dir ,'\', i_names '*.jpg']);
            for j = 1:length(i_files)
                img_j = imread([dataset_dir,'\', i_files(j).name]);
                img_new = imresize(img_j,[hgt_img1,wid_img1],'bilinear');
                img_crop = img_new(6:120,6:55,:);
                img = imresize(img_crop,[hgt_img, wid_img],'bilinear'); 
                name_j =  sprintf('%04d.png', k);
                imwrite(img,[dnorm_dir,'\',name_j]); 
                Img_id_align = [Img_id_align, i];         
                k = k + 1;
            end    
                 save([dnorm_dir,'\IDX_ilids'] , 'Img_id_align');        
        end
        
        
        
  elseif strcmp(dataset,'cuhk01') == 1
          hgt_img = 128; 
          wid_img = 48; 
          files = dir([dataset_dir, '\campus\*.png']);
          np = length(files);
          num_p = np/4;
          for p=1:num_p
              img_a = imread([dataset_dir, '\campus\', files((p-1)*4+1).name]);
              img_b = imread([dataset_dir, '\campus\', files((p-1)*4+3).name]);
              img_a = imresize(img_a,[hgt_img,wid_img],'bilinear');
              img_b = imresize(img_b,[hgt_img,wid_img],'bilinear');
              
              name_a = sprintf('%04d%03d.png', p, 1);
              name_b = sprintf('%04d%03d.png', p, 2);
              imwrite(img_a, [dnorm_dir, name_a]);
              imwrite(img_b, [dnorm_dir, name_b]);
          end
               disp('finish normalizing...');
  elseif strcmp(dataset,'cuhk03') ==1   
          hgt_img = 128; 
          wid_img = 48;
          files = dir([dataset_dir, '\*.png']);
          np = length(files);
          for p=1:np
                 img = imread([dataset_dir, '\', files(p).name]);
                 name = sprintf('%06d.png', p);
                 img = imresize(img,[hgt_img,wid_img],'bilinear');
                 imwrite(img, [dnorm_dir, name]);
          end
              disp('finish normalizing...');
  else
      error('no such dataset');
  end
     
 
end

