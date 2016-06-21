function  descriptors = feat_extraction_jointcolor(oriImgs, options)
%
%  
    numScales = 3;
    BH = 8;  
    StepH = 4;
    BW = 16;  
    StepW = 8;
    colorBins = [8, 8, 8];
    feattype = 'HSV';
    
    if nargin >=2
        
         if isfield(options,'numScales') && ~isempty(options.numScales) && isscalar(options.numScales) && isnumeric(options.numScales) && options.numScales > 0
             numScales = options.numScales;
%              fprintf('numScale =%d.\n', numScales);
         end
         
         if isfield(options,'BH') && ~isempty(options.BH) && isscalar(options.BH) && isnumeric(options.BH) && options.BH > 0
             BH = options.BH;
%              fprintf('BH=%d.\n', BH);
         end
         
         if isfield(options,'StepH') && ~isempty(options.StepH) && isscalar(options.StepH) && isnumeric(options.StepH) && options.StepH > 0
             StepH = options.StepH;
%              fprintf('StepH=%d.\n', StepH);
         end
         
         if isfield(options,'BW') && ~isempty(options.BW) && isscalar(options.BW) && isnumeric(options.BW) && options.BW > 0
             BW = options.BW;
%              fprintf('BW=%d.\n', BW);
         end
         
          if isfield(options,'StepW') && ~isempty(options.StepW) && isscalar(options.StepW) && isnumeric(options.StepW) && options.StepW > 0
             StepW = options.StepW;
%              fprintf('StepW=%d.\n', StepW);
          end
          
          if isfield(options,'colorBins') && ~isempty(options.colorBins) && isscalar(options.colorBins) && isnumeric(options.colorBins) && options.colorBins > 0
             colorBins = options.colorBins;
%              fprintf('StepW=%d.\n', colorBins);
          end
          
          if isfield(options,'feattype') && ~isempty(options.feattype) && isscalar(options.feattype) && isnumeric(options.feattype) && options.feattype > 0
             feattype = options.feattype;
%              fprintf('StepW=%d.\n', feattype);
          end
          
    end   
          totalBins = prod(colorBins);
          numImgs = size(oriImgs,4);
          images = zeros(size(oriImgs));
          
          %%%% color histogram %%%%
          for i = 1 : numImgs
              I = oriImgs(:,:,:,i);
%             I = Retinex(I);
             if  strcmp( feattype,'HSV') == 1
                 I = rgb2hsv(I);
             else
                 error('no processing for such channel!');
             end
             
            I(:,:,1) = min( floor( I(:,:,1) * colorBins(1) ), colorBins(1)-1 );
            I(:,:,2) = min( floor( I(:,:,2) * colorBins(2) ), colorBins(2)-1 );
            I(:,:,3) = min( floor( I(:,:,3) * colorBins(3) ), colorBins(3)-1 );
            images(:,:,:,i) = I; %HSV
          end
              minRow = 1;
              minCol = 1;
              descriptors = [];
              
          for i = 1 : numScales
              patterns = images(:,:,3,:) * colorBins(2) * colorBins(1)... 
              + images(:,:,2,:)*colorBins(1) + images(:,:,1,:); % HSV  %%%  ½« Histogram ½øÐÐ±àÂë
              patterns = reshape(patterns, [], numImgs);   
              %%%%%%%%%%%%%%%%%%%%%%%%%
              height = size(images, 1);
              width  = size(images, 2);
              %%%%%%%%%%%%%%%%%%%%%%%%%%
              maxRow = height - BH + 1;
              maxCol =  width - BW + 1;
              
              [cols,rows] = meshgrid(minCol:StepW:maxCol, minRow:StepH:maxRow); 
              cols = cols(:);
              rows = rows(:);
              numBlocks = length(cols);
              numBlocksCol = length(minCol:StepW:maxCol);
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              if numBlocks == 0
                   break;
              end
              
              offset = bsxfun(@plus, (0 : BH - 1)', (0 : BW - 1) * height);
              index = sub2ind([height, width], rows, cols);   %%% indexes of the one patch %%% 
              index = bsxfun(@plus, offset(:), index');       %%% indexes of all the patches but ranked in the block order.
              patches = patterns(index(:), :);
              patches = reshape(patches, [], numBlocks * numImgs); %%% patches 
              
              fea = hist(patches, 0 : totalBins-1);
              fea = reshape(fea, [totalBins, numBlocks / numBlocksCol, numBlocksCol, numImgs]);
              %%%%%%%%% need to be checked %%%%%%%
%               fea = max(fea, [], 3);  
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              fea = reshape(fea, [], numImgs);
              descriptors = [descriptors; fea];
              if  i<numScales
                  images = ColorPooling(images, 'average');
              end
              
          end
               
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



