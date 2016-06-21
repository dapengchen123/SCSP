function [ Ws_1, Ws_2] = weight_transform( w, param )
%
% 
        dimension = param.dimension;
        w_reshape = reshape(w,dimension,[]);
        layernum = size(w_reshape,2);
        dimM = param.dimM;
        dimS = param.dimS;
        diagMidx = param.diagMidx;
        diagSidx = param.diagSidx;
        lambS = param.lambS;
        lambM = param.lambM;
        maskidxS = param.maskidxS;
        maskidxM = param.maskidxM;
        featdimS = param.featdimS;
        featdimM = param.featdimM;
        dimension = param.dimension;
        Lam = sqrt(2);
        
        Ws_1 = zeros(dimM,dimM,layernum);
        Ws_2 = zeros(dimS,dimS,layernum);
        f_idx1 = 1:featdimM;
        f_idx2 = (featdimM+1):dimension;
        
        for col = 1:layernum
            W = zeros(dimM,dimM); 
            W(maskidxM) =  w_reshape(f_idx1,col);
            W = (W+W');
            W(diagMidx)= W(diagMidx)*lambM*Lam/2;
            Ws1 = W;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Wsim = zeros(dimS,dimS);
            Wsim(maskidxS) = w_reshape(f_idx2,col);
            Wsim = Wsim + Wsim';
            Wsim(diagSidx) = Wsim(diagSidx)*lambS*Lam/2;
            Ws2 = Wsim;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Ws_1(:,:,col) =  Ws1;
            Ws_2(:,:,col) =  Ws2;
        end
            param.Ws_1 = Ws_1;
            param.Ws_2 = Ws_2;    
end

