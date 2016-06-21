function [Block_start, Block_end  ] =  Defined_division_index1(numBlocksRow, numBlocksCol )
%
%                   pre-defined stripe for person  
%
              Width1 = ceil(numBlocksRow*0.3);
              Width2 = ceil(numBlocksRow*0.4);
          
             
              
              Blockstart1 = 2;
              Blockstart2 = Blockstart1+Width1-2;
              Blockstart3 = Blockstart2+Width2-2;
           
              
              Block_start = [Blockstart1, Blockstart2, Blockstart3];
              Block_end   = [Blockstart1+Width1, Blockstart2+Width2, numBlocksRow-3];
              Block_start = (Block_start-1)*numBlocksCol+1;
              Block_end   =  Block_end*numBlocksCol;
             
end

