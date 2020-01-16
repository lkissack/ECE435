function [Iout, MSE_pre, MSE_post] = SpeckleDen(DICOMAddress, n, var_speckle)
%
image = dicomread(DICOMAddress);

[rows, cols, samples, slices] = size(image);


image = max(image, 0);
image = mat2gray(image);
noisy = image(:,:,:,1:n);
%imshow(noisy(:,:,:,1));
for slice = 1:n
    noisy(:,:,:,slice) = imnoise(noisy(:,:,:,slice),'speckle',var_speckle);
end
MSE_pre = immse(image(:,:,:,1), noisy(:,:,:,1))
noisyAvg = mean(noisy, 4);
MSE_post = immse(image(:,:,:,1), noisyAvg)
s1 = noisy(:,:,:,1);
imshow(noisyAvg);

end

