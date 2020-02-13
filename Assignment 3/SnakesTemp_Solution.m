clear all
clc

% Minimization Parameters
alpha        = ;
gamma         = ;
beta        = ;
max_itr      = ;
GaussWinSize = ;
GradT        = ;%Gradient Threshold

% Loading the image and converting that to a grey-level image if needed
original  = imread('CTImage.png');

% Denoising by Gaussian filter
% Edge Detection using Sobel kernels

    %generate Gaussian Kernel and perform convolution with Sobel filters

% Seed points selection


% optimization loop
for iteration = 1: max_itr
    for single_point = 1:seed_points
        %for each kxk nieghbiurhood
        
        
        
    end
    
    %update seed points, plot new snake
    
end
