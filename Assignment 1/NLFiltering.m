function [Iout] = NLFiltering(OrgImgAdd,n)
%use median filter 
%nl filter is sliding neighbourhoodfilter
%colfilt divides into regions

%load original image
original = imread(OrgImgAdd);
original = mat2gray(original);

%based upon MATLAB nlfilter documentation
medianfilter = @(x) median(x(:));
Iout = nlfilter(original,[n n], medianfilter);

subplot(1,2,1);
imshow(original, []);
title("Original Image");
subplot(1,2,2);
imshow(Iout,[]);
title(sprintf('Median Filter n = %d',n));


end

