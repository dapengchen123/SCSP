%%%%%%%%%%%%%%%%%%% PCA normalization %%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%% data prepare  %%%%%%%%%%%%%%%%%%%%%%%
   %%%% data prepare %%%%
process_flag = 1;
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
    option.StepH = 4;
    option.BW = 16;
    option.StepW = 8;
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Global %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    option.RowStep  =  31;
    option.RowWidth =  31;

    %%%%%%%%%% Sep-color %%%%%%%%%%

    option.colorBins = [16,16,16];
    option.feattype = 'HSV';
    [descriptors_HSV_sep, index_HSV_sep ] = S_feat_extraction_sepcolor_N2(images, option);
    option.feattype = 'LAB';
    [descriptors_LAB_sep, ~ ] = S_feat_extraction_sepcolor_N2(images, option);

    option.colorBins = [8,8,8];
    option.feattype = 'HSV';
    [descriptors_HSV_joint, ~ ] = S_feat_extraction_jointcolor_N2(images, option);
    option.feattype = 'LAB';
    [descriptors_LAB_joint, ~ ] = S_feat_extraction_jointcolor_N2(images, option);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    option.feattype = 'SILTHist';
    option.Rr = [5,3];
    [descriptors_SILT, ~] = S_feat_extraction_texture(images, option);
    option.feattype = 'HOG';
    option.HOGBin=8;
   [descriptors_HOG, ~] = S_feat_extraction_texture(images, option);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Raw_1 = cell(2,1);
    Raw_1{1} = descriptors_HSV_sep;
    Raw_1{2} = descriptors_SILT;
    S_PCAfull_data_1 = S_PCA_ourall(Raw_1, index_HSV_sep); 
    PCA_data{1} = S_PCAfull_data_1;
    
    Raw_2 = cell(2,1);
    Raw_2{1} = descriptors_HSV_joint;
    Raw_2{2} = descriptors_HOG;
    S_PCAfull_data_2 = S_PCA_ourall(Raw_2, index_HSV_sep); 
    PCA_data{2} = S_PCAfull_data_2;
    
    Raw_3 = cell(2,1);
    Raw_3{1} = descriptors_LAB_joint;
    Raw_3{2} = descriptors_SILT;
    S_PCAfull_data_3 = S_PCA_ourall(Raw_3, index_HSV_sep); 
    PCA_data{3} = S_PCAfull_data_3;
    
    Raw_4 = cell(2,1);
    Raw_4{1} = descriptors_LAB_sep;
    Raw_4{2} = descriptors_HOG;
    S_PCAfull_data_4 = S_PCA_ourall(Raw_4, index_HSV_sep); 
    PCA_data{4} = S_PCAfull_data_4;
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Local %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    scales = [8 8]; 
 for ll= scales  
    
    
    option.RowStep  =  ll ;
    option.RowWidth =  ll ;
%   %%%%%%%%% Sep-color %%%%%%%%%%
   
    option.colorBins = [16,16,16];
    option.feattype = 'HSV';
    [descriptors_HSV_sep, index_HSV_sep ] = S_feat_extraction_sepcolor_N2(images, option);
    option.feattype = 'LAB';
    [descriptors_LAB_sep, index_LAB_sep ] = S_feat_extraction_sepcolor_N2(images, option);

    option.colorBins = [8,8,8];
    option.feattype = 'HSV';
    [descriptors_HSV_joint, index_HSV_joint ] = S_feat_extraction_jointcolor_N2(images, option);
    option.feattype = 'LAB';
    [descriptors_LAB_joint, index_LAB_joint ] = S_feat_extraction_jointcolor_N2(images, option);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    option.feattype = 'SILTHist';
    option.Rr = [5,3];
    [descriptors_SILT, index_SILT] = S_feat_extraction_texture(images, option);
    option.feattype = 'HOG';
    option.HOGBin=8;
   [descriptors_HOG, index_HOG] = S_feat_extraction_texture(images, option);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Raw_1 = cell(2,1);
    Raw_1{1} = descriptors_HSV_sep;
    Raw_1{2} = descriptors_SILT;
    S_PCAfull_data_1 = S_PCA_ourall(Raw_1, index_HSV_sep); 
    PCA_data{5} = S_PCAfull_data_1;
    
    Raw_2 = cell(2,1);
    Raw_2{1} = descriptors_HSV_joint;
    Raw_2{2} = descriptors_HOG;
    S_PCAfull_data_2 = S_PCA_ourall(Raw_2, index_HSV_sep); 
    PCA_data{6} = S_PCAfull_data_2;
    
    Raw_3 = cell(2,1);
    Raw_3{1} = descriptors_LAB_joint;
    Raw_3{2} = descriptors_SILT;
    S_PCAfull_data_3 = S_PCA_ourall(Raw_3, index_HSV_sep); 
    PCA_data{7} = S_PCAfull_data_3;
    
    Raw_4 = cell(2,1);
    Raw_4{1} = descriptors_LAB_sep;
    Raw_4{2} = descriptors_HOG;
    S_PCAfull_data_4 = S_PCA_ourall(Raw_4, index_HSV_sep); 
    PCA_data{8} = S_PCAfull_data_4;
    
    
  
%     PCA_name = 'corr_mix_HSV_LAB_HOG_SPLIT-full-2-2-31-31.mat';
%     save(PCA_name, 'PCA_data');

   numbername = sprintf('%d-%d-31-31',ll,ll);
    PCA_name = ['viper_mix_HSV_LAB_HOG_SPLIT-full-', numbername, '.mat'];
    save(PCA_name, 'PCA_data');
 end
    
