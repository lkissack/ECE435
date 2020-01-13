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

original = firstSlice;



%for testing purposes
%Im1 = imshow(firstSlice, []);
%imshow(original, [])

%random returns float
gNoise = random('Normal', Mean, Std,[rows,cols]);

%if int is to be used instead
%M(1:rows, 1:cols)= Mean;
%gNoise = M + Std.*randn([rows,cols]);

%not sure if this should be additive or multiplicative?
gImg = original + gNoise;
%do not use MATLAB provided imnoise

%Im2 = imshow(gImg,[]);
subplot(1,2,1);
imshow(firstSlice, []);
title("Original");
subplot(1,2,2);
imshow(gImg,[]);
title({"Gaussian Noise";sprintf("Mean = %d Std = %d", Mean,Std)});

%save new images as OrgImg.png and GaussianNoise.png in SAME folder as
%original
% final = mat2gray(gImg);
% imwrite(final,"FinalTestfile.png")

%Normalize into [0,1] range and save as original .png
original = mat2gray(firstSlice);%converts to double
imwrite(original,'Testfile.png');
end

