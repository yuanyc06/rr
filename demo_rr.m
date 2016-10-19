% Demo for publication "Robust Saliency Detection via Regularized Random Walks Ranking" 
% by Yuchen Yuan
% The BMIT Group, The University of Sydney

clear all
clc

%% Initialization
addpath(genpath('./support/'));
IMG_DIR = './image/';% Original image path
SAL_DIR='./saliencymap/' ;% Output path of the saliency map
if ~exist(SAL_DIR, 'dir')
    mkdir(SAL_DIR);
end
imglist=dir([IMG_DIR '*' 'jpg']);

%% Algorithm start
for imgno=1:length(imglist)
% Load input image
    disp(imgno);
    
% Calculate saliency
    saliency = rrsaliency(IMG_DIR, imglist(imgno).name);

%     Output saliency map to file
    imwrite(saliency, [SAL_DIR, imglist(imgno).name(1:end-4), '_rrwr.png']);
end
