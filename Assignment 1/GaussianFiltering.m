function [Iout,MSE_pre, MSE_post] = GaussianFiltering(OrgImgAdd,NoisyImgAdd, n,std)
original = imread(OrgImgAdd);
original = mat2gray(original);%use im2double instead?
noisy = imread(NoisyImgAdd);
noisy = mat2gray(noisy);%use im2double instead?

%for testing
% original = 3*ones(8,8);
% noisy = [3.1*ones(1,8);3*ones(1,8);3.05*ones(1,8);2.8*ones(1,8);3.1*ones(1,8);3*ones(1,8);3.05*ones(1,8);2.8*ones(1,8)]

%calculate MSE between original image and noisy image
MSE_pre = immse(original, noisy)

[rows, cols] = size(original);
%zero pad the edges of the image by n-1 pixels
padding = n-1;
paddedImg = zeros(rows + 2*padding, cols + 2*padding);
finalImg = paddedImg;%remove extra zeros at end
paddedImg(1+ padding: padding + rows, 1 + padding : padding + cols) = original;

%Generate n X n Gaussian Filter
G = fspecial('gaussian',n,std);%not recommended by MATLAB
%for testing purposes
%G = [1 2 3; 4 5 6; 7 8 9];

%not sure if this needs to be rotated?
G = flip(G,1);
G = flip(G,2);

%use two for loops
for i = 1:rows + padding
    for j = 1:cols + padding
        %multiply G with original image
        multiplicationResult = paddedImg(i:i+padding,j:j+padding).*G;
        finalImg(i,j) = sum(multiplicationResult(:));
    end
    
end%end for loop

%remove extra padding
Iout = finalImg(1+ padding: padding + rows, 1 + padding : padding + cols);
%Iout = mat2gray(Iout);
imshow(Iout);

%These are different types?
MSE_post = immse(original, Iout)
end

