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
imshow(Iout);
end

