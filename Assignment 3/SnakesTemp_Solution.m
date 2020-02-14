clear all
clc

% Minimization Parameters
% alpha        = ;
% gamma         = ;
% beta        = ;
% max_itr      = ;
GaussWinSize = 5;
% GradT        = ;%Gradient Threshold

% Loading the image and converting that to a grey-level image if needed
original  = imread('CTImage.png');
[rows, cols, dim] = size(original);
if dim == 3 % check the solution key to see if this is the correct way to do this
    original = rgb2gray(original);
end
imshow(original, []);

% 1. Denoising by Gaussian filter - what is std?
std = 1;
gk = myGaussian(GaussWinSize,std);%check to make sure that this function is correct
denoised = imfilter(original,gk,'conv');

% 2. Edge Detection using Sobel kernels
%assuming use of 3x3 sobel kernels
sobelx = [1 0 -1; 2 0 -2; 1 0 -1];
sobely = sobelx';

%generate Gaussian Kernel and perform convolution with Sobel filters
gkSx = imfilter(gk,sobelx,'conv');
gkSy = imfilter(gk,sobely,'conv');

Gxsobel = imfilter(original, gkSx,'conv');
Gysobel = imfilter(original, gkSy,'conv');

[Gx,Gy] = imgradientxy(denoised, 'sobel');%not sure if this is cool or not
[Gmag, Gdir] = imgradient(denoised);
%should this be pointwise multiplication?

% Seed points selection
fprintf('Select seed points on original image\n');
[xi_seed, yi_seed] = getpts();

imshow(Gmag,[]);
k = 3;
range = floor(k/2);
% optimization loop


%calculate average distance of subsequent pointson snake when vi is moved
distance = 0;
for point = 1: seedpoints
    distance = distance + %euclidean distnace?
    
end




% for iteration = 1: max_itr
%     for single_point = 1:seed_points
%         for i = 1:k
%             for j = 1:k
%                 vi = [i,j];
%                 %calculate energy
%                 
%                 
%             end
%         end 
%         %end of moving vi
%     end
%     %update seed points, plot new snake
% end
  
