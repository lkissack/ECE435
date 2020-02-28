clear all
clc

% Minimization Parameters
max_itr      = 100;
GaussWinSize = 5;
GradT        = 0.01;%Gradient Threshold

% Loading the image and converting that to a grey-level image if needed
original  = imread('CTImage.png');
[rows, cols, dim] = size(original);
if dim == 3 % check the solution key to see if this is the correct way to do this
    original = rgb2gray(original);
end
imshow(original,[]);
% 1. Denoising by Gaussian filter - what should std be?
std = 1;
gk = myGaussian(GaussWinSize,std);%check to make sure that this function is correct
denoised = imfilter(original,gk,'conv');
% 
%% 2. Edge Detection using Sobel kernels

% Use pre-provided MATLAB functions
[Gx,Gy] = imgradientxy(denoised, 'sobel');
%[Gmag, Gdir] = imgradient(denoised,'sobel');

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

%apparently convhull requires input as double
%k1 = boundary(initial_seed);
k1h = convhull(initial_seed);
%plot(initial_seed(k1,1), initial_seed(k1,2),'g');
% plot(initial_seed(k1h,1), initial_seed(k1h,2),'b','LineWidth',2);
%% Pre-plotting
close all
imshow(original, []);
hold on
plot(initial_seed(k1h,1), initial_seed(k1h,2),'b','LineWidth',2);


%% Snake Initialization
snake = initial_seed;
k = 51;
range = floor(k/2);

energy = zeros(k,k, 3);
%(:,:,1) - continuity
%(:,:,2) - curvature
%(:,:,3) - gradient

%% set parameters
alpha = 0.1;
gamma = 1;
beta = 0.00;
GradT        = 1;%Gradient Threshold
grad_scale = GradT*(g_max-g_min);

%% 3. Optimization Loop %%

for iteration = 1:max_itr
    %for each point in the snake
    for point_index = 1:size(snake,1)
        %round to nearest int since fractional pixels don't really exist
        point = round(snake(point_index,:));
               
        %for each point in the kxk neighbourhood
        for i = 1:k %-range:range
            for j = 1:k % -range:range
                %[i,j]
                %i-1 and j-1 to account for matlab indexing
                %+- range centers around point of interest
                modified_point = point + [(-range + (i - 1)),(-range + (j - 1))];
                
                %Do not let points move past the boundary
                modified_point(modified_point <= 0) = 1;
                modified_point(modified_point >=612) = 611;
                
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

        %Normalize based on max, min values NOT between [0,1]
        %'normalize(...,'range')' leads to corner snakes
        energy(:,:,1) = energy(:,:,1)/(max(energy(:,:,1),[],'all')-min(energy(:,:,1),[],'all'));
        energy(:,:,2) = energy(:,:,2)/(max(energy(:,:,2),[],'all')-min(energy(:,:,2),[],'all'));
                
        Range = max(energy(:,:,3),[],'all') - min(energy(:,:,3),[],'all');
        Egrad_norm = max(Range,grad_scale); 
        
        energy(:,:,3) = energy(:,:,3)/Egrad_norm;
        
        %calculate the total energy
        etotal = alpha*energy(:,:,1) + beta*energy(:,:,2) - gamma*energy(:,:,3);
        %if multiple minimum values are found, the first point is selected
%         [min_e,idx] = min(etotal, [],'all','linear');      
%         [x,y] = ind2sub(size(etotal),idx);
        
        %if there are multiple minimum values, take the one in the middle
        %results in gradient not moving very aggressively
        mins = find(etotal(:)== min(etotal, [],'all'));
        m = mins(randperm(size(mins,1),1));
%         [x,y] = ind2sub(size(etotal), median(mins));
        %choose the minimum value randomly
        [x,y] = ind2sub(size(etotal), m);
        
        
        %subtract range for position relative to point
        actual_point = point + [(-range + x -1), (-range + y -1)];
        %update the snake
        actual_point(actual_point <=0) = 1;
        actual_point(actual_point >=612) = 611;
        snake(point_index,:) = actual_point;    
    end
end

snake;
energy;
etotal;
%k2 = convhull(snake);
k2 = boundary(snake);
plot(snake(k2,1),snake(k2,2),'m');
k2h = convhull(snake);

plot(snake(k2h,1),snake(k2h,2),'c', 'LineWidth', 2);


%% Test Functions

snake = [1,1;1,3;2,5;4,5;5,3;3,1];

a = average_distance(snake);
c = curvature(snake);

test = [ 1 2 3; 4 5 1; 1 7 8];
all = find(test(:)== min(test,[],'all'));

m = all(randperm(size(all,1),1));

[x,y] = ind2sub(size(test),median(all));
%test(x,y)

%test with gamma = 0
% snake should shrink to single point

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
    curv = norm(snake(size(snake,1),:) - 2*snake(1,:) + snake(2,:));
    curv = curv + norm(snake(size(snake,1)- 1,:) - 2*snake(size(snake,1),:) + snake(1,:));
    for vi = 2:(size(snake,1) - 1)        
        curv = curv + norm(snake(vi - 1,:) - 2*snake(vi,:) + snake(vi +1,:));
    end
    
end

function [min_e, idx] = minimum_energy(energy)

end
