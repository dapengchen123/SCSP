function  descriptors = feat_extraction_sepcolor( oriImgs, options)
%
%           
      numScales = 3;
      BH = 8;
      StepH = 4;
      BW = 16;
      StepW = 8;
      colorBins = [16, 16, 16];
      feattype = 'HSV';
      
      if nargin >=2
         if isfield(options,'numScales') 
             numScales = options.numScales;
         end
          
         if isfield(options,'BH')
             BH = options.BH;
         end
         
         if isfield(options,'StepH') 
             StepH = options.StepH;
         end
         
         if isfield(options,'BW')
             BW = options.BW;
         end
         
         if isfield(options,'StepW') 
             StepW = options.StepW;
         end
         
         if isfield(options,'colorBins') 
              colorBins = options.colorBins;
         end
         
         if isfield(options,'feattype') 
              feattype = options.feattype;
         end
          
      end
      
           numImgs = size(oriImgs, 4);
           images = zeros(size(oriImgs));
           
           for i= 1:numImgs
               I = oriImgs(:,:,:,i);
               if strcmp(feattype, 'HSV') ==1
                   I = rgb2hsv(I);
               else
                   error('no processing for such channel!');
               end
               
              I(:,:,1) = min( floor( I(:,:,1) * colorBins(1) ), colorBins(1)-1 );
              I(:,:,2) = min( floor( I(:,:,2) * colorBins(2) ), colorBins(2)-1 );
              I(:,:,3) = min( floor( I(:,:,3) * colorBins(3) ), colorBins(3)-1 );
              images(:,:,:,i) = I;    
           end
           
              minRow = 1;
              minCol = 1;
              descriptors = [];
           
           for i = 1:numScales
               patterns1 =  images(:,:,1,:);
               patterns2 =  images(:,:,2,:);
               patterns3 =  images(:,:,3,:);
               
               patterns1 = reshape(patterns1, [], numImgs); 
               patterns2 = reshape(patterns2, [], numImgs); 
               patterns3 = reshape(patterns3, [], numImgs); 
               %%%%%%%%%     %%%%%%%%%%%
               height = size(images,1);
               width  = size(images,2);
               maxRow = height -BH +1;
               maxCol = width - BW +1;
               
              [cols, rows] = meshgrid(minCol:StepW:maxCol, minRow:StepH:maxRow);
               cols = cols(:);
               rows = rows(:);
               numBlocks = length(cols);
%              numBlocksCol = length(minCol:StepW:maxCol);
              %%%%%%%%%%%%%%%%%%%%%%%%%%
              if numBlocks == 0;
                   break;
              end
              
              offset = bsxfun(@plus, (0 : BH - 1)', (0 : BW - 1) * height);
              index = sub2ind([height, width], rows, cols);
              index = bsxfun(@plus, offset(:), index');
              
              patches1 = patterns1(index(:),:);
              patches2 = patterns2(index(:),:);
              patches3 = patterns3(index(:),:);
              
              patches1 = reshape(patches1,[],numBlocks*numImgs);
              patches2 = reshape(patches2,[],numBlocks*numImgs);
              patches3 = reshape(patches3,[],numBlocks*numImgs);
              
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              fea1 = hist(patches1, 0 : colorBins(1)-1);
              fea2 = hist(patches2, 0 : colorBins(2)-1);
              fea3 = hist(patches3, 0 : colorBins(3)-1);
              fea = [fea1;fea2;fea3];
              fea = reshape(fea, [], numImgs);
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              descriptors = [descriptors; fea];
              if i<numScales
                   images = ColorPooling(images,'average');
              end 
              
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             descriptors = log(descriptors + 1);
             descriptors = normc(descriptors);
      
end

function outImages = ColorPooling(images, method)
    [height, width, numChannels, numImgs] = size(images);
    outImages = images;
    
    if mod(height, 2) == 1
        outImages(end, :, :, :) = [];
        height = height - 1;
    end
    
    if mod(width, 2) == 1
        outImages(:, end, :, :) = [];
        width = width - 1;
    end
    
    if height == 0 || width == 0
        error('Over scaled image: height=%d, width=%d.', height, width);
    end
    
    height = height / 2;
    width = width / 2;
    
    outImages = reshape(outImages, 2, height, 2, width, numChannels, numImgs);
    outImages = permute(outImages, [2, 4, 5, 6, 1, 3]);
    outImages = reshape(outImages, height, width, numChannels, numImgs, 2*2);
    
    if strcmp(method, 'average')
        outImages = floor(mean(outImages, 5));
    else if strcmp(method, 'max')
            outImages = max(outImages, [], 5);
        else
            error('Error pooling method: %s.', method);
        end
    end
end


