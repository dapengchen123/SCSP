function   [descriptors, output_index] = S_feat_extraction_texture( oriImgs, options)
%
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
          %%%%%%%%%%%%%%%%%%%%
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
         
         if isfield(options,'feattype')
             feattype = options.feattype;
         end
         
         if isfield(options, 'RowStep')
             RowStep = options.RowStep;
         end
         
         if isfield(options, 'RowWidth')
             RowWidth = options.RowWidth;
         end
         
         if isfield(options, 'Rr')
              Rr = options.Rr;
         end
         
         if  isfield(options, 'HOGBin')
              HOGBin = options.HOGBin;
         end
         
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      [imgHeight,imWidth,~, numImgs] = size(oriImgs);
      images = zeros(imgHeight, imWidth, numImgs);
      %%%%%%% color histogram  %%%%%%%%
      for i =1:numImgs
            I = oriImgs(:,:,:,i);
            I = rgb2gray(I);
            images(:,:,i) = double(I)/255;   
      end
      
        minRow = 1;
        minCol = 1;
        priBlocknum = 0; 
        output_index = [];
        descriptors = [];
         
             for i =1:numScales
                height = size(images,1);
                width  = size(images,2);
             
                 if strcmp(feattype, 'SILTHist') == 1
                   totalBins = 3^numPoints;
                   Patterns = cell(length(Rr),1);
                   for rr =1:length(Rr)
                      if width<Rr(rr)*2+1
                         fprintf('Skip scale R = %d, width = %d.\n', Rr(rr), width); 
                         continue; 
                      end
                       
                      patterns = SILTP(images, tau, Rr(rr), numPoints);
                      patterns = reshape(patterns,[],numImgs);
                      Patterns{rr} = patterns; 
                   end
                 elseif strcmp(feattype, 'HOG') == 1
                      totalBins = HOGBin;
                      Patterns = cell(1,1);
                       patterns = zeros(size(images));
                       for  pl=1:size(images,3)   
                        patterns(:,:,pl) = gradient_level(images(:,:,pl), HOGBin);
                       end
                       patterns = reshape(patterns,[],numImgs);
                       Patterns{1} = patterns; 
                 else
                      error('no processing for such channel!');
                 end
                
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  maxRow = height - BH + 1;
                  maxCol = width - BW + 1;    
                 [cols, rows] = meshgrid(minCol:StepW:maxCol, minRow:StepH:maxRow);
                  cols = cols';
                  rows = rows';
                  cols = cols(:);
                  rows = rows(:);
                  numBlocks = length(cols);
                  numBlocksCol = length(minCol:StepW:maxCol);
                  numBlocksRow = length(minRow:StepH:maxRow);
                  
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  
                   if numBlocks <=1
                       Col =  minCol:StepW:maxCol;
                       Row =  minRow:StepH:maxRow;
                      
                       if(length(Col)<=1)
                             Col = 1;
                       end
                       
                       if(length(Row)<=1)
                             Row = 1;
                       end
                       
                      [cols, rows] = meshgrid(Col,Row);
                       cols = cols';
                       rows = rows';
                       cols = cols(:);
                       rows = rows(:);
                       numBlocks = length(cols);
                        
                       Block_start = 1;
                       Block_end = numBlocks;
                        
                       BH = min(height, BH);
                       BW = min(width, BW);
                        
                       offset = bsxfun(@plus, (0 : BH - 1)', (0 : BW - 1) * height);
                       index = sub2ind([height,width],rows,cols);
                       index = bsxfun(@plus, offset(:), index');
                      fea = [];
                      for rr = 1:length(Patterns)
                         patterns = Patterns{rr};  
                         patches = patterns(index(:),:);
                         patches = reshape(patches,[],numBlocks*numImgs);
                         fea_rr = hist(patches, 0 : totalBins-1);
                         fea = cat(1, fea, fea_rr);
                      end 
                         fea  = reshape(fea,[], numBlocks, numImgs);
                         descriptors = cat(2,descriptors,fea);
                         curr_index = [(Block_start+priBlocknum)', (Block_end+priBlocknum)'];
                         output_index = cat(1,output_index,curr_index);
                    else
                        [Block_start, Block_end ] = S_division_index( numBlocksRow,numBlocksCol,RowStep, RowWidth);
                        offset = bsxfun(@plus, (0 : BH - 1)', (0 : BW - 1) * height);  
                        index = sub2ind([height,width],rows,cols);
                        index = bsxfun(@plus, offset(:), index');
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        fea = [];
                        for rr = 1:length(Patterns)
                            patterns = Patterns{rr};
                            patches = patterns(index(:),:);
                            patches = reshape(patches,[],numBlocks*numImgs);
                            fea_rr = hist(patches, 0 : totalBins-1);
                            fea = cat(1, fea, fea_rr);                           
                        end
                        fea  = reshape(fea,[], numBlocks, numImgs);
                        descriptors = cat(2, descriptors, fea);
                        curr_index = [(Block_start+priBlocknum)', (Block_end+priBlocknum)'];
                        output_index = cat(1, output_index, curr_index);
                        priBlocknum = priBlocknum + numBlocks;
                    end
                      
                    if i<numScales
                       images = Pooling(images, 'average');
                    end
          end
                       descriptors = log(descriptors + 1);                
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
 

