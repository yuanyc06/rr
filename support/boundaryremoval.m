function removed = boundaryremoval(input_img, superpixels)
% Function removed = boundaryremoval(input_img, superpixels) locates the
% irrelevant boundary to be removed from the background saliency
% approximation.
% 
% Inputs:       input_im - the input RGB image
%                   superpixels - the superpixel segmentation result
% Outputs:    removed - the label of the boundary to be removed, 1,2,3 and
%                   4 corresponds to the top, bottom, left and right boundary
% 
% 11/05/14 - by Yuchen Yuan
% Based on the paper:
% Changyang Li, Yuchen Yuan, Weidong Cai, Yong Xia, and David Dagan Feng. 
% "Robust Saliency Detection via Regularized Random Walks Ranking". CVPR 2015

[m, n] = size(superpixels);

input_img_r = input_img(:,:,1);
input_img_g = input_img(:,:,2);
input_img_b = input_img(:,:,3);

bst=unique(superpixels(1,1:n));
bsd=unique(superpixels(m,1:n));
bsl=unique(superpixels(1:m,1));
bsr=unique(superpixels(1:m,n));

border{1,1} = input_img_r(ismember(superpixels, bst));
border{1,2} = input_img_g(ismember(superpixels, bst));
border{1,3} = input_img_b(ismember(superpixels, bst));

border{2,1} = input_img_r(ismember(superpixels, bsd));
border{2,2} = input_img_g(ismember(superpixels, bsd));
border{2,3} = input_img_b(ismember(superpixels, bsd));

border{3,1} = input_img_r(ismember(superpixels, bsr));
border{3,2} = input_img_g(ismember(superpixels, bsr));
border{3,3} = input_img_b(ismember(superpixels, bsr));

border{4,1} = input_img_r(ismember(superpixels, bsl));
border{4,2} = input_img_g(ismember(superpixels, bsl));
border{4,3} = input_img_b(ismember(superpixels, bsl));

histdiff = zeros(4,1);

for i = 1:length(histdiff)
    idx = 1:length(histdiff);
    idx(i) = [];
    sumhistdiff = 0;
    for j = 1:length(idx)
        dr = 0;
        for k = 1:3
            [c1, ~] = imhist(border{i,k});
            [c2, ~] = imhist(border{idx(j),k});
            c1 = c1 / (size(border{i,k},1) * size(border{i,k},2));
            c2 = c2 / (size(border{idx(j),k},1) * size(border{idx(j),k},2));
            dr = dr + sum((c1-c2).^2);
        end
        dr = sqrt(dr);
        sumhistdiff = sumhistdiff + dr;
    end
    histdiff(i) = sumhistdiff;
end

[~, removed] = max(histdiff);

end


