function W = Groupsparse_projection( A, alpha)
%
%  
     eps_i = 1e-10;
     %%%%%%%%   
     A_norm = sqrt(sum(A.*A,2));
     A_norm_eps = bsxfun(@max, A_norm, eps_i);
     ratio = (1- bsxfun(@rdivide,alpha, A_norm_eps));
     ratio_positive = bsxfun(@max, 0 ,ratio);
     W = bsxfun(@times, A, ratio_positive);
     %%%%%%%%
     
end

