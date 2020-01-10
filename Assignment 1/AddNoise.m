function [] = AddNoise(DicomAddress,NoiseStats)
%NoiseStats = [Mean, Std]

originalImage = dicomread(DicomAddress);
info = dicominfo(DicomAddress)
firstSlice = originalImage(:,:,:,1);

%for testing purposes
imshow(firstSlice, [])

%replace negative values in slice with 0

%add gaussian noise to first slice of dicom file
%do not use MATLAB provided imnoise

%save new images as OrgImg.png and GaussianNoise.png in SAME folder as
%original
end

