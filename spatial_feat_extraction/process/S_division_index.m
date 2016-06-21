function   [Block_start, Block_end ] =  S_division_index( numBlocksRow, numBlocksCol, RowStep, RowWidth)
%
%             
         RowTop = 1:RowStep:(numBlocksRow-RowStep/3);
         RowBot = RowTop+ RowWidth;
         RowBot(end) = numBlocksRow;
         RowTop(end) = max(numBlocksRow-RowStep,1);
         Block_start = (RowTop-1)*numBlocksCol+1;
         Block_end   =  RowBot*numBlocksCol;
end

