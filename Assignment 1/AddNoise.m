function [] = AddNoise(DicomAddress,NoiseStats)

Mean = NoiseStats(1);
Std = NoiseStats(2);

image = dicomread(DicomAddress);
%info = dicominfo(DicomAddress)

%what are the dimensions of the image?
[rows, cols, samples, slices] = size(image);

firstSlice = image(:,:,:,1);

%replace all negative values in slice with 0
firstSlice = max(firstSlice, 0);

%Normalize into [0,1] range and save as original .png
original = mat2gray(firstSlice);
imwrite(original,'Testfile.png');

%for testing purposes
%imshow(firstSlice, [])
%imshow(original, [])

gNoise = random('Normal', Mean, Std,[rows,cols]);

%not sure if this should be additive or multiplicative?
gImg = original + gNoise;
%do not use MATLAB provided imnoise

imshow(gImg,[])
%save new images as OrgImg.png and GaussianNoise.png in SAME folder as
%original



end

