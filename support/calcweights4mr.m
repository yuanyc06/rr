function W = calcweights4mr(input_img, superpixels, spno, theta)
% Function W = calcweights4mr(input_img, superpixels, spno, theta)
% calculates the weight matrix for manifold-ranking-based background and
% foreground saliency approximations.
% 
% Inputs:       input_img - the input RGB image
%                   superpixels - the superpixel segmentation result
%                   spno - total superpixel number
%                   theta - controlling parameter
% Outputs:    W - the weight matrix
% 
% 11/05/14 - by Yuchen Yuan
% Based on the paper:
% Changyang Li, Yuchen Yuan, Weidong Cai, Yong Xia, and David Dagan Feng. 
% "Robust Saliency Detection via Regularized Random Walks Ranking". CVPR 2015

    if nargin < 4
        theta = 10;
    end
    
    [m,n,k] = size(input_img);
    
% Calculate average Lab value of each superpixel
    input_pixels=reshape(input_img, m*n, k);
    sp_rgb=zeros(spno,1,3);
    for i=1:spno
        sp_rgb(i,1,:)=mean(input_pixels((superpixels==i),:),1);
    end  
    sp_lab = colorspace('Lab<-', sp_rgb); 
    sp_lab=reshape(sp_lab,spno,3);
     
% Calculate edges    
    neighbourhood = zeros(spno);
    for i = 1:m-1
        for j = 1:n-1
            if(superpixels(i,j)~=superpixels(i,j+1))
                neighbourhood(superpixels(i,j),superpixels(i,j+1)) = 1;
                neighbourhood(superpixels(i,j+1),superpixels(i,j)) = 1;
            end;
            if(superpixels(i,j)~=superpixels(i+1,j))
                neighbourhood(superpixels(i,j),superpixels(i+1,j)) = 1;
                neighbourhood(superpixels(i+1,j),superpixels(i,j)) = 1;
            end;
            if(superpixels(i,j)~=superpixels(i+1,j+1))
                neighbourhood(superpixels(i,j),superpixels(i+1,j+1)) = 1;
                neighbourhood(superpixels(i+1,j+1),superpixels(i,j)) = 1;
            end;
            if(superpixels(i+1,j)~=superpixels(i,j+1))
                neighbourhood(superpixels(i+1,j),superpixels(i,j+1)) = 1;
                neighbourhood(superpixels(i,j+1),superpixels(i+1,j)) = 1;
            end;
        end;
    end;    
    bd=unique([superpixels(1,:),superpixels(m,:),superpixels(:,1)',superpixels(:,n)']);
    for i=1:length(bd)
        for j=i+1:length(bd)
            neighbourhood(bd(i),bd(j))=1;
            neighbourhood(bd(j),bd(i))=1;
        end
    end

    edges=[];
    for i=1:spno
        indext=[];
        ind=find(neighbourhood(i,:)==1);
        for j=1:length(ind)
            indj=find(neighbourhood(ind(j),:)==1);
            indext=[indext,indj];
        end
        indext=[indext,ind];
        indext=indext((indext>i));
        indext=unique(indext);
        if(~isempty(indext))
            ed=ones(length(indext),2);
            ed(:,2)=i*ed(:,2);
            ed(:,1)=indext;
            edges=[edges;ed];
        end
    end

% Calculate weight matrix
    weights=exp(-theta*normalize(sqrt(sum((sp_lab(edges(:,1),:)-sp_lab(edges(:,2),:)).^2,2))));
    W=sparse([edges(:,1);edges(:,2)],[edges(:,2);edges(:,1)],[weights;weights],spno,spno);
end
