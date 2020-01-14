function [NoisyImg, MSE] = AddNLNoise(DicomAddress, NoiseType, NoiseChr)
%NoiseType - string
%NoiseChr = variance or noise density dependant on provided noise type

%use MATLAB'S imnoise fn

image = dicomread(DicomAddress);
%info = dicominfo(DicomAddress)

%determine dimensions of file
[rows, cols, samples, slices] = size(image);

firstSlice = image(:,:,:,1);

%replace all negative values in slice with 0
%not sure if this is required for this question?
firstSlice = max(firstSlice, 0);
%Normalize into [0,1] range and save as original .png
original = mat2gray(firstSlice);%converts to double

NoisyImg = imnoise(original, NoiseType,NoiseChr);

%for testing purposes
imshow(NoisyImg,[])

%MSE
diff = (original - NoisyImg).^2;
total = sum(diff(:));
MSE = total/(rows*cols)

%save image
imwrite(NoisyImg,sprintf('%s.png',NoiseType));
end

