
function [descriptors, output_index] = S_feat_extraction_sepcolor_N2_2(oriImgs, options)
%
%  
       numScales = 3;
       BH = 8;
       StepH = 4;
       BW = 16;
       StepW = 8;
       colorBins = [16, 16, 16];
       RowStep  =  6;
       RowWidth =  31;
       
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
         
         if isfield(options, 'RowStep')
             RowStep = options.RowStep;
         end
         
         if isfield(options, 'RowWidth')
             RowWidth = options.RowWidth;
         end
         
       end
             numImgs = size(oriImgs, 4);
             images = zeros(size(oriImgs));
             images = cat(3,images,images);
       for i = 1:numImgs
               I = oriImgs(:,:,:,i);
               if strcmp(feattype, 'HSV') ==1
                   I = rgb2hsv(I);
               elseif strcmp(feattype, 'LAB') ==1
                   I = rgb2lab(I);
               elseif strcmp(feattype, 'RGB') ==1
                   I = double(I)/255;
               else
                   error('no processing for such channel!');
               end
               
              I1 = cat(3,I,I);
              I1(:,:,1) = min( floor( I(:,:,1) * colorBins(1) ), colorBins(1)-1 );
              I1(:,:,2) = min( floor( I(:,:,2) * colorBins(2) ), colorBins(2)-1 );
              I1(:,:,3) = min( floor( I(:,:,3) * colorBins(3) ), colorBins(3)-1 );
              I1(:,:,4) = I(:,:,1);
              I1(:,:,5) = I(:,:,2);
              I1(:,:,6) = I(:,:,3);
              images(:,:,:,i) = I1;      
       end
              
               minRow = 1;
               minCol = 1;
               priBlocknum = 0;
               descriptors = [];
               output_index = [];
               
        for i =1:numScales
              patterns1 =  images(:,:,1,:);
              patterns2 =  images(:,:,2,:);
              patterns3 =  images(:,:,3,:);
              patterns4 =  images(:,:,4,:);
              patterns5 =  images(:,:,5,:);
              patterns6 =  images(:,:,6,:);
                  
              patterns1 = reshape(patterns1, [], numImgs); 
              patterns2 = reshape(patterns2, [], numImgs); 
              patterns3 = reshape(patterns3, [], numImgs); 
              patterns4 = reshape(patterns4, [], numImgs); 
              patterns5 = reshape(patterns5, [], numImgs); 
              patterns6 = reshape(patterns6, [], numImgs); 
                  
              height = size(images,1);
              width  = size(images,2);
              maxRow = height - BH + 1;
              maxCol = width - BW +1;
                  
              [cols, rows] = meshgrid(minCol:StepW:maxCol, minRow:StepH:maxRow);
              cols = cols(:); 
              rows = rows(:);
              numBlocks = length(cols);
              numBlocksCol = length(minCol:StepW:maxCol);
              numBlocksRow = length(minRow:StepH:maxRow);
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
                   cols = cols(:); 
                   rows = rows(:);
                   numBlocks = length(cols);
                    
                   Block_start = 1;
                   Block_end = numBlocks;
                   
                   BH = min(height, BH);
                   BW = min(width, BW);
                   
                   offset = bsxfun(@plus, (0 : BH - 1)', (0 : BW - 1) * height);
                   index = sub2ind([height,width],rows,cols);
                   index = bsxfun(@plus, offset(:),index');
                   
                   patches1 = patterns1(index(:),:);
                   patches2 = patterns2(index(:),:);
                   patches3 = patterns3(index(:),:);
                   patches4 = patterns4(index(:),:);
                   patches5 = patterns5(index(:),:);
                   patches6 = patterns6(index(:),:);
                   
                  patches1 = reshape(patches1,[],numBlocks*numImgs);
                  patches2 = reshape(patches2,[],numBlocks*numImgs);
                  patches3 = reshape(patches3,[],numBlocks*numImgs);
                  patches4 = reshape(patches4,[],numBlocks*numImgs);
                  patches5 = reshape(patches5,[],numBlocks*numImgs);
                  patches6 = reshape(patches6,[],numBlocks*numImgs);
              
              
                 fea1 = hist(patches1, 0 : colorBins(1)-1);
                 fea2 = hist(patches2, 0 : colorBins(2)-1);
                 fea3 = hist(patches3, 0 : colorBins(3)-1);
                 fea1  = normc(fea1);
                 fea2  = normc(fea2);
                 fea3  = normc(fea3);
                 
                 fea4 = mean(patches4,1);
                 fea5 = mean(patches5,1);
                 fea6 = mean(patches6,1);
                  
                 fea  = [fea1;fea2;fea3;fea4; fea5; fea6]; 
                 %%%%%%%%%%%%%%%%
%                  fea  = reshape(fea,[], numBlocks*numImgs);
%                  fea  = normc(fea);
                 %%%%%%%%%%%%%%%%
                 fea  = reshape(fea,[], numBlocks, numImgs);
    
                 descriptors = cat(2, descriptors , fea);
                 curr_index = [(Block_start+priBlocknum)', (Block_end+priBlocknum)'];
                 output_index = cat(1, output_index, curr_index);
                    
              else
              
              [Block_start, Block_end ] =  S_division_index( numBlocksRow,numBlocksCol,RowStep, RowWidth);
              offset = bsxfun(@plus, (0 : BH - 1)', (0 : BW - 1) * height);
              index = sub2ind([height,width],rows,cols);
              index = bsxfun(@plus, offset(:),index');
              
              patches1 = patterns1(index(:),:);
              patches2 = patterns2(index(:),:);
              patches3 = patterns3(index(:),:);
              patches4 = patterns4(index(:),:);
              patches5 = patterns5(index(:),:);
              patches6 = patterns6(index(:),:);
              
              patches1 = reshape(patches1,[],numBlocks*numImgs);
              patches2 = reshape(patches2,[],numBlocks*numImgs);
              patches3 = reshape(patches3,[],numBlocks*numImgs);
              patches4 = reshape(patches4,[],numBlocks*numImgs);
              patches5 = reshape(patches5,[],numBlocks*numImgs);
              patches6 = reshape(patches6,[],numBlocks*numImgs);
              
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              
              fea1 = hist(patches1, 0 : colorBins(1)-1);
              fea2 = hist(patches2, 0 : colorBins(2)-1);
              fea3 = hist(patches3, 0 : colorBins(3)-1);
              fea4 = mean(patches4,1);
              fea5 = mean(patches5,1);
              fea6 = mean(patches6,1);
              fea1  = normc(fea1);
              fea2  = normc(fea2);
              fea3  = normc(fea3);
              
              fea  = [fea1;fea2;fea3; fea4; fea5; fea6];  
              %%%%%%%%%%%%%%%%
%               fea  = reshape(fea,[], numBlocks*numImgs);
%               fea  = normc(fea);
              %%%%%%%%%%%%%%%%
              fea  = reshape(fea,[], numBlocks,numImgs);
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              descriptors = cat(2, descriptors , fea);
              curr_index = [(Block_start+priBlocknum)', (Block_end+priBlocknum)'];
              output_index = cat(1, output_index, curr_index);
              priBlocknum = priBlocknum + numBlocks;
              end
              
              if i<numScales
                   images = ColorPooling(images,'average');
              end 
              
        end
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             descriptors = log(descriptors + 1);            
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


