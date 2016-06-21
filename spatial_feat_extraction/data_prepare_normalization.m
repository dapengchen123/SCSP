   %%%%%%%%%%%%%%%%%%%%% data prepare  %%%%%%%%%%%%%%%%%%%%%%%
   %%%% data prepare %%%%
process_flag = 0;
dataload_flag = 1;
dataset = 'viper';
feattype = '1\';
setpath;
if process_flag
   data_processing(dataset, dataset_dir, dnorm_dir);      
end

    files = dir([dnorm_dir, '*png']);
    tlen = size(files,1);
    image1 = imread([dnorm_dir, files(1).name]);
    Height = size(image1,1); 
    Width  = size(image1,2);
    images = zeros(Height,Width,3,tlen,'uint8');
    for i =1:tlen
        images(:,:,:,i) = imread([dnorm_dir, files(i).name]);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    option.numScales = 1;
    option.BH = 8;
    option.SH = 4;
    option.BW = 16;
    option.SW = 8;
    
    option.RowStep  =  8;
    option.RowWidth =  8;
%   %%%%%%%%% Sep-color %%%%%%%%%%
    option.colorBins = [16,16,16];
    option.feattype = 'HSV';
    [descriptors_HSV_sep, index_HSV_sep ] = S_feat_extraction_sepcolor_N2(images, option);
    option.feattype = 'LAB';
    [descriptors_LAB_sep, index_LAB_sep ] = S_feat_extraction_sepcolor_N2(images, option);
    S_PCAfull_data_HSV_sep   = S_PCA_ourall(descriptors_HSV_sep, index_HSV_sep); 
    S_PCAfull_data_LAB_sep = S_PCA_ourall(descriptors_LAB_sep, index_LAB_sep);
    %%%%%%%Joint-Color %%%%%%%%%%%%%
    option.colorBins = [8,8,8];
    option.feattype = 'HSV';
    [descriptors_HSV_joint, index_HSV_joint ] = S_feat_extraction_jointcolor_N2(images, option);
    option.feattype = 'LAB';
    [descriptors_LAB_joint, index_LAB_joint ] = S_feat_extraction_jointcolor_N2(images, option);
    S_PCAfull_data_HSV_joint = S_PCA_ourall(descriptors_HSV_joint, index_HSV_joint); 
    S_PCAfull_data_LAB_joint = S_PCA_ourall(descriptors_LAB_joint, index_LAB_joint);
    
    
    
    
%     S_PCAfull_data_silt = S_PCA_ourall(Des3, index_SILT);
%     S_PCAfull_data_LAB_sep = S_PCA_ourall(Des4, index_LAB_sep);
    
    
     PCA_data{1} = S_PCAfull_data_HSV_sep;
     PCA_data{2} = S_PCAfull_data_LAB_sep;
% %      
% %     PCA_name = sprintf('S_%d_%d_HSV_LAB_%d_SH_%d_BW_%d_SW_%d_N4',option.RowStep, option.RowWidth, option.BH, option.SH, option.BW, option.SW);
% %     save(PCA_name, 'PCA_data');
   
     PCA_data{3} = S_PCAfull_data_HSV_joint;
     PCA_data{4} = S_PCAfull_data_LAB_joint;
     
     PCA_name = sprintf('S_%d_%d_HSV_LAB_sep_joint%d_SH_%d_BW_%d_SW_%d_N4',option.RowStep, option.RowWidth, option.BH, option.SH, option.BW, option.SW);
     save(PCA_name, 'PCA_data');

    
    
%  %  %%%%%%%%% Jot-color %%%%%%%%%%%
%     option.colorBins = [8, 8, 8];
%     option.feattype = 'HSV';
%     [descriptors_HSV_joint, index_HSV_joint ] = S_feat_extraction_jointcolor(images, option);
%     option.feattype = 'LAB';
%     [descriptors_LAB_joint, index_LAB_joint ] = S_feat_extraction_jointcolor(images, option);
%     
%     
% %     option.feattype = 'SILTHist';
% %     option.Rr = [5,3];
% %     [descriptors_SILT, index_SILT] = S_feat_extraction_texture(images, option);
% %     option.feattype = 'HOG';
% %     option.HOGBin = 8;
% %     [descriptors_HOG, index_HOG ] = S_feat_extraction_texture(images, option); 
% %     
% %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     Des1 = cat(1,descriptors_HSV_sep, descriptors_SILT );
% %     Des2 = cat(1,descriptors_LAB_sep, descriptors_SILT );
% %     Des3 = cat(1,descriptors_HSV_joint,descriptors_HOG );
% %     Des4 = cat(1,descriptors_LAB_joint,descriptors_HOG );
% %     
% %     
% %     S_PCAfull_data_HSV_sep = S_PCA_ourall(Des1, index_HSV_sep); 
% %     S_PCAfull_data_HSV_joint = S_PCA_ourall(Des2, index_HSV_joint);
% %     S_PCAfull_data_silt = S_PCA_ourall(Des3, index_SILT);
% %     S_PCAfull_data_LAB_sep = S_PCA_ourall(Des4, index_LAB_sep);
% %     
% %     
% %      PCA_data{1} = S_PCAfull_data_HSV_sep;
% %      PCA_data{2} = S_PCAfull_data_HSV_joint;
% %      PCA_data{3} = S_PCAfull_data_silt;
% %      PCA_data{4} = S_PCAfull_data_LAB_sep; 
% %     PCA_name = sprintf('S_%d_%d_Des1234_BH_%d_SH_%d_BW_%d_SW_%d_nonormc',option.RowStep, option.RowWidth, option.BH, option.SH, option.BW, option.SW);
% %     save(PCA_name, 'PCA_data');
