clear all
clc

% Minimization Parameters
alpha = 0.0;
gamma = 0.25;
beta = 0.0;
max_itr      = 100;
GaussWinSize = 5;
GradT        = .01;%Gradient Threshold

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

G = (abs(Gx).^2 + abs(Gy).^2);
g_max = max(G,[],'all');
g_min = min(G,[],'all');
grad_scale = GradT*(g_max-g_min);
%% Seed points selection
fprintf('Select seed points on original image\n');
[xi_seed, yi_seed] = getpts();
%for testing purposes
%xi_seed = [499,362,496,541]';
%yi_seed = [523,423,392,440]';
initial_seed = [xi_seed,yi_seed]; %points now organized as [x1, y1; x2 y2; ...] 
hold on
%plot original as green circles
%plot(initial_seed(:,1),initial_seed(:,2),'go','MarkerSize',5);

%aparently convhull requires input as double
k1 = convhull(initial_seed);
plot(initial_seed(k1,1), initial_seed(k1,2),'g');
%% Snake Initialization
snake = initial_seed
k = 5;
range = floor(k/2);

%modify location of point
energy = zeros(k,k, 3);
%(:,:,1) - continuity
%(:,:,2) - curvature
%(:,:,3) - gradient

%% Optimization Loop %%

for iteration = 1:max_itr
    %for each point in the snake
    for point_index = 1:size(snake,1)
        %round to nearest int since fractional pixels don't really exist
        point = round(snake(point_index,:));
               
        %for each point in the kxk neighbourhood
        for i = 1:k %-range:range
            for j = 1:k % -range:range
                %[i,j]
                %define as uint64 since it is used for indexing and MATLAB has a
                %hissy fit otherwise
                %modified_point = point + uint64([(-range + i - 1),( -range + j - 1)]); 
                
                %i-1 and j-1 to account for matlab indexing
                %+- range centers around point of interest
                modified_point = point + [(-range + (i - 1)),(-range + (j - 1))];
                
                modsnake = snake;
                modsnake(point_index,:) = modified_point;
                %do the elements of the snake need to be re-ordered?
                energy(i,j,1) = average_distance(modsnake);
                energy(i,j,2) = curvature(modsnake);
                
                %switch to uint64 so MATLAB stops screaming about the
                %indices
                mp = uint64(modified_point);
                                
                energy(i,j,3) = (norm(Gx(mp(1), mp(2)))^2 + norm(Gy(mp(1), mp(2)))^2);
                
            end
        end
        %might have to find optimal stuff out here to normalize the energy first
        
        energy(:,:,1) = normalize(energy(:,:,1),'range');
        energy(:,:,2) = normalize(energy(:,:,2),'range');
        %normalize this one globally
        %energy(:,:,3) = normalize(energy(:,:,3),'range');
        
        Range = max(energy(:,:,3),[],'all') - min(energy(:,:,3),[],'all');
        Egrad_norm = max(Range,grad_scale); 
        
        energy(:,:,3) = energy(:,:,3)/Egrad_norm;
        
        etotal = alpha*energy(:,:,1) + beta*energy(:,:,2) - gamma*energy(:,:,3);
        [min_e,idx] = min(etotal, [],'all','linear');
        
        [x,y] = ind2sub(size(etotal),idx);
        
        %subtract range for position relative to point
        actual_point = point + [(-range + x -1), (-range + y -1)];
        %update the snake
        snake(point_index,:) = actual_point;    
    end
end

snake
k2 = convhull(snake);
plot(snake(k2,1),snake(k2,2),'m');

%% Energy Functions

%not sure if this should be average distance or total?
%course slides indicate total distance
function [a_dist] = average_distance(snake)
    %slides show distance as norm squared

    %wrap back around to the first element of the snake
    %distance = norm(snake(1,:)-snake(size(snake,1),:))^2;
    distance = norm(snake(1,:)-snake(size(snake,1),:));
    
    for vi = 2:size(snake,1)
        %distance = distance + norm(snake(vi,:) - snake(vi-1,:))^2;
        distance = distance + norm(snake(vi,:) - snake(vi-1,:));
    end
    a_dist = distance/size(snake,1);

end

function [curv] = curvature(snake)
    %handle edge/wrap cases first
%     curv = norm(snake(size(snake,1),:) - 2*snake(1,:) + snake(2,:))^2;
%     curv = curv + norm(snake(size(snake,1)- 1,:) - 2*snake(size(snake,1),:) + snake(1,:))^2;
%     for vi = 2:size(snake,1) - 1        
%         curv = norm(snake(vi - 1,:) - 2*snake(vi,:) + snake(vi +1,:))^2;
%     end
    
    %handle edge/wrap cases first
    curv = norm(snake(size(snake,1),:) - 2*snake(1,:) + snake(2,:));
    curv = curv + norm(snake(size(snake,1)- 1,:) - 2*snake(size(snake,1),:) + snake(1,:));
    for vi = 2:size(snake,1) - 1        
        curv = norm(snake(vi - 1,:) - 2*snake(vi,:) + snake(vi +1,:));
    end
    
end

function [] = total_energy

end
