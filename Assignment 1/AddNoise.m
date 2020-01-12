function [] = AddNoise(DicomAddress,NoiseStats)
%NoiseStats = [Mean, Std]

image = dicomread(DicomAddress);
%info = dicominfo(DicomAddress)

%what are the dimensions of the image?
[rows, cols, samples, slices] = size(image);

firstSlice = image(:,:,:,1);

%replace all negative entries with 0
firstSlice = max(firstSlice, 0);

%Save as the original


%for testing purposes
imshow(firstSlice, [])


%replace negative values in slice with 0

%add gaussian noise to first slice of dicom file
%do not use MATLAB provided imnoise

%save new images as OrgImg.png and GaussianNoise.png in SAME folder as
%original
end

