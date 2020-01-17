function [Iout, MSE_pre, MSE_post] = SpeckleDen(DICOMAddress, n, var_speckle)
image = dicomread(DICOMAddress);

[rows, cols, samples, slices] = size(image);

image = max(image, 0);
image = mat2gray(image);
original = image(:,:,:,1);
noisy = image(:,:,:,1:n);
for slice = 1:n
    noisy(:,:,:,slice) = imnoise(noisy(:,:,:,slice),'speckle',var_speckle);
end
MSE_pre = immse(original, noisy(:,:,:,1))
noisyAvg = mean(noisy, 4);
MSE_post = immse(original, noisyAvg)
Iout = noisyAvg;

subplot(1,2,1);
imshow(original, []);
title("Original Image");
subplot(1,2,2);
imshow(Iout,[]);
title(sprintf('Slices averaged = %d, speckle variance = %d',n, var_speckle));

end

