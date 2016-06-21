function R = gradient_level( I, nbins)
%
  %%%
  paper_x = [0 0 0; 1 0 -1; 0 0 0]/2;
  paper_y = paper_x';
  %%% apply the derivative filters %%%
  sx = conv2(I,rot90(paper_x,2), 'same');
  sy = conv2(I,rot90(paper_y,2), 'same');
  [X,Y] = meshgrid(1:size(sx,2),1:size(sx,1));
  a = atan(sy./(sx+1e-15));
  norm_a = (a+pi/2)/pi;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  R = min( floor(norm_a*nbins), nbins-1);
  
  
  
  
  
  
  
end

