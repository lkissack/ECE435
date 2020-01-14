function [] = AddNoise(DicomAddress,NoiseStats)
%Function to add Gaussian Noise to image without using MATLAB imnoise fn
Mean = NoiseStats(1);
Std = NoiseStats(2);

image = dicomread(DicomAddress);
%info = dicominfo(DicomAddress)

%what are the dimensions of the image?
[rows, cols, samples, slices] = size(image);

firstSlice = image(:,:,:,1);

%replace all negative values in slice with 0
firstSlice = max(firstSlice, 0);

original = firstSlice;

%Normalize into [0,1] range and save as original .png
original = mat2gray(firstSlice);%converts to double
imwrite(original,'Testfile.png');

%for testing purposes
%Im1 = imshow(firstSlice, []);
%imshow(original, [])

%random returns float
gNoise = random('Normal', Mean, Std,[rows,cols]);

%normalize gaussian
noise = mat2gray(gNoise);

%Add noise to original
gImg = mat2gray(original + noise);


%Im2 = imshow(gImg,[]);
subplot(1,2,1);
imshow(firstSlice, []);
title("Original Image");
subplot(1,2,2);
imshow(gImg,[]);
title({"Noisy Image (Gaussian)";sprintf("Mean = %d Std = %d", Mean,Std)});

%save new images as OrgImg.png and GaussianNoise.png in SAME folder as
%original
% final = mat2gray(gImg);
% imwrite(final,"FinalTestfile.png")


end

