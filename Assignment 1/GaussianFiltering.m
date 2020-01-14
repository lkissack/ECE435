function [Iout,MSE_pre, MSE_post] = GaussianFiltering(OrgImgAdd,NoisyImgAdd, n,std)
%calculate MSE between original image and noisy image
MSE_pre = immse(OrgImgAdd, NoisyImgAdd);

%Generate n X n Gaussian Filter
G = fspecial('gaussian',n,std);%not recommended by MATLAB

%use two forloops?

end

