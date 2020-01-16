function [NoisyImg] = AddNoise(DicomAddress,NoiseStats)
%Function to add Gaussian Noise to image without using MATLAB imnoise fn
Mean = NoiseStats(1);
Std = NoiseStats(2);

image = dicomread(DicomAddress);
%info = dicominfo(DicomAddress)

%determine dimensions of file
[rows, cols, samples, slices] = size(image);

firstSlice = image(:,:,:,1);

%replace all negative values in slice with 0
firstSlice = max(firstSlice, 0);

%Normalize into [0,1] range and save as original .png
original = mat2gray(firstSlice);%converts to double
imwrite(original,'OrgImg.png');

%random returns float/double
gNoise = random('Normal', Mean, Std,[rows,cols]);

%normalize gaussian
noise = mat2gray(gNoise);

%Add noise to original
gImg = original + noise;

%save new images as OrgImg.png and GaussianNoise.png in SAME folder as
%original
NoisyImg = mat2gray(gImg);
imwrite(NoisyImg,'GaussianNoise.png')

%Plot original and noisy slices next to each other
subplot(1,2,1);
imshow(original, []);
title("Original Image");
subplot(1,2,2);
imshow(NoisyImg,[]);
title({"Noisy Image (Gaussian)";sprintf("Mean = %d Std = %d", Mean,Std)});

end

