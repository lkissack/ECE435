function [Iout,MSE_pre, MSE_post] = GaussianFiltering(OrgImgAdd,NoisyImgAdd, n,std)
%calculate MSE between original image and noisy image
%MSE_pre = immse(OrgImgAdd, NoisyImgAdd);

[rows, cols] = size(OrgImgAdd);
%zero pad the edges of the image by n/2 pixels
padding = floor(n/2)
paddedImg = zeros(rows + 2*padding, cols + 2*padding);
finalImg = paddedImg;%remove extra zeros at end
paddedImg(1+ padding: padding + rows, 1 + padding : padding + cols) = OrgImgAdd;

%Generate n X n Gaussian Filter
%G = fspecial('gaussian',n,std);%not recommended by MATLAB
G = 2*ones(n,n);
%not usre if this needs to be rotated?

%use two for loops?
for i = 1:rows + padding
    i
    for j = 1:cols + padding
        j
        %multiply G with original image
        multiplicationResult = paddedImg(i:i+n-1,j:j+n-1).*G;
        finalImg(i:i+n-1,j:j+n-1) = finalImg(i:i+n-1,j:j+n-1) + multiplicationResult;
    end
    
end%end for loop

%remove extra padding
Iout = finalImg(1+ padding: padding + rows, 1 + padding : padding + cols);
end

