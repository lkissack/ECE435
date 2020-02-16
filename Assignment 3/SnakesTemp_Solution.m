clear all
clc

% Minimization Parameters
alpha = 1;
gamma = 1;
beta = 1;
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
% 
% % 2. Edge Detection using Sobel kernels
% %assuming use of 3x3 sobel kernels
% sobelx = [1 0 -1; 2 0 -2; 1 0 -1];
% sobely = sobelx';
% 
% %generate Gaussian Kernel and perform convolution with Sobel filters
% gkSx = imfilter(gk,sobelx,'conv');
% gkSy = imfilter(gk,sobely,'conv');
% 
% Gxsobel = imfilter(original, gkSx,'conv');
% Gysobel = imfilter(original, gkSy,'conv');
% 
[Gx,Gy] = imgradientxy(denoised, 'sobel');%not sure if this is cool or not
[Gmag, Gdir] = imgradient(denoised,'sobel');
%should this be pointwise multiplication?

%figure out which method this should be
G = -1*(norm(Gx)^2 + norm(Gy)^2);

% Seed points selection
fprintf('Select seed points on original image\n');
[xi_seed, yi_seed] = getpts();
initial_seed = [xi_seed,yi_seed]; %points now organized as [x1, y1; x2 y2; ...] 


% optimization loop

% point = [1,3];
% testsnake = [1, 2; 2, 2; 4, 2; 6,5; point];

% point = [1,1];
% testsnake = [point; 2, 2; 3, 3; 4, 4; 5, 5];

testsnake = initial_seed;
point = testsnake(1,:);

k = 3;
range = floor(k/2);

%modify location of point
energy = zeros(k,k, 3);
%(:,:,1) - continuity
%(:,:,2) - curvature
%(:,:,3) - gradient

point_index = 2;
min_e = inf;
%assume the current point is the best
optimal_point = point;
for i = 1:k %-range:range
    for j = 1:k % -range:range
        %[i,j]
        modified_point = point + [-range + i - 1, -range + j - 1];        
        modsnake = testsnake;
        modsnake(point_index,:) = modified_point;
        %do the elements of the snake need to be re-ordered?
        energy(i,j,1) = average_distance(modsnake);
        energy(i,j,2) = curvature(modsnake);
        
        %this is not working
        norm(Gx(modified_point))
        energy(i,j,3) = (norm(Gx(modified_point))^2 + norm(Gy(modified_point))^2);   
        etotal = alpha*energy(i,j,1) + beta*energy(i,j,2) - gamma*energy(i,j,3);
        if etotal<min_e
            min_e = etotal;
            optimal_point = modified_point;
        end
    end
end
%might have to find optimal stuff out here to normalize the energy first :/
%etotal = alpha*energy(:,:,1) + beta*energy(:,:,2) - gamma*energy(:,:,3);
%update vi based on smallest value of etotal
%find location of minimum value in etotal
testsnake(point_index,:) = optimal_point


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

%not sure if this should be average distance or total?
%course slides indicate total distance
function [a_dist] = average_distance(snake)
    %slides show distance as norm squared

    %wrap back around to the first element of the snake
    distance = norm(snake(1,:)-snake(size(snake,1),:))^2;
    
    for vi = 2:size(snake,1)
        distance = distance + norm(snake(vi,:) - snake(vi-1,:))^2;
    end
    a_dist = distance/size(snake,1);

end

function [curv] = curvature(snake)
    %handle edge/wrap cases first
    curv = norm(snake(size(snake,1),:) - 2*snake(1,:) + snake(2,:))^2;
    curv = curv + norm(snake(size(snake,1)- 1,:) - 2*snake(size(snake,1),:) + snake(1,:))^2;
    for vi = 2:size(snake,1) - 1        
        curv = norm(snake(vi - 1,:) - 2*snake(vi,:) + snake(vi +1,:))^2;
    end
end

