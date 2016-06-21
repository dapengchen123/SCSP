function  Descriptors = feat_extraction_texture(oriImgs, options)
%
%                          %%%%%%%%%%%%%%%
%
          numScales = 3;
          BH = 8;
          StepH = 4;
          BW = 16;
          StepW = 8;
          feattype = 'SILTHist';
          tau = 0.3;
          Rr = 5;
          numPoints = 4;
          %%%%%%%%%%%%%%%%%%%%%%
          
      if nargin >=2  
         if isfield(options,'numScales') && ~isempty(options.numScales) && isscalar(options.numScales) && isnumeric(options.numScales) && options.numScales > 0
             numScales = options.numScales;
         end
         
         if isfield(options,'BH') && ~isempty(options.BH) && isscalar(options.BH) && isnumeric(options.BH) && options.BH > 0
             BH = options.BH;
         end
         
         if isfield(options,'StepH') && ~isempty(options.StepH) && isscalar(options.StepH) && isnumeric(options.StepH) && options.StepH > 0
             StepH = options.StepH;
         end
         
         if isfield(options,'BW') && ~isempty(options.BW) && isscalar(options.BW) && isnumeric(options.BW) && options.BW > 0
             BW = options.BW;
         end
         
          if isfield(options,'StepW') && ~isempty(options.StepW) && isscalar(options.StepW) && isnumeric(options.StepW) && options.StepW > 0
             StepW = options.StepW;
          end
        
          
          if isfield(options,'feattype') && ~isempty(options.feattype) && isscalar(options.feattype) && isnumeric(options.feattype) && options.feattype > 0
             feattype = options.feattype;
          end
          
          if isfield(options, 'Rr')
              Rr = options.Rr;
          end
          
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
      totalBins = 3^numPoints;
      [imgHeight,imWidth,~, numImgs] = size(oriImgs);
      images = zeros(imgHeight, imWidth, numImgs);
      %%%% color histogram %%%%
      for i = 1:numImgs
          I = oriImgs(:,:,:,i);
          I = rgb2gray(I);
          images(:,:,i) = double(I)/255;
      end
      
      minRow = 1;
      minCol = 1;
      
    Descriptors = [];
    for r =1:length(Rr)
       R = Rr(r);
       descriptors = [];
        for i =1 : numScales
           height = size(images,1);
           width  = size(images,2);
          
           if width<R*2+1
              fprintf('Skip scale R = %d, width = %d.\n', R, width);
              continue;
           end
           
           if  strcmp( feattype,'SILTHist') == 1
              patterns = SILTP(images, tau, R, numPoints);
           else
               error('no processing for such channel!');
           end
              patterns = reshape(patterns,[],numImgs);
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              maxRow = height - BH + 1;
              maxCol = width - BW + 1;
              [cols, rows] = meshgrid(minCol:StepW:maxCol, minRow:StepH:maxRow);
              cols = cols(:);
              rows = rows(:);
              numBlocks = length(cols);
              numBlocksCol = length(minCol:StepW:maxCol);
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              if numBlocks == 0
                  break;
              end
              
              offset = bsxfun(@plus, (0 : BH - 1)', (0 : BW - 1) * height);
              index = sub2ind([height, width], rows, cols);  
              index = bsxfun(@plus, offset(:), index'); 
              patches = patterns(index(:), :);
              patches = reshape(patches, [], numBlocks * numImgs); 
         
              fea = hist(patches, 0 : totalBins-1);
              fea = reshape(fea, [totalBins, numBlocks / numBlocksCol, numBlocksCol, numImgs]);
              %%%%%%%%%%%  need to be checked %%%%%%%%%%%%%%
              %
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
              fea = reshape(fea, [], numImgs);
              descriptors = [descriptors; fea];
              if i<numScales
                   images = Pooling(images, 'average');
              end           
         end    
              descriptors = log(descriptors + 1);
              descriptors = normc(descriptors);  
              Descriptors = [Descriptors, descriptors];
    end 
            
end


function  outImages = Pooling(images, method)
     [height, width, numImgs] = size(images);
      outImages = images;
      if  mod(height,2)==1
          outImages(end,:,:)=[];
          height = height - 1;
      end
      
      if  mod(width,2) == 1
          outImages(:,end,:) = [];
          width = width -1;
      end
      
      if height == 0 || width == 0
        error('Over scaled image: height=%d, width=%d.', height, width);
      end
      
      height = height/2;
      width  = width/2;
      
      outImages = reshape(outImages,2,height,2,width,numImgs);
      outImages = permute(outImages, [2,4,5,1,3]);
      outImages = reshape(outImages, height, width, numImgs, 2*2);
      
      
      if strcmp(method, 'average')
          outImages = mean(outImages, 4);
      elseif strcmp(method, 'max') 
          outImages = max(outImages,[],4);         
      else
          error('Error pooling  method: %s', method);     
      end
      

end
 


