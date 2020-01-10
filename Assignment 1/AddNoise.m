function [] = AddNoise(DicomAddress,NoiseStats)
%NoiseStats = [Mean, Std]

originalImage = dicomread(DicomAddress);
firstSlice = originalImage(:,:,:,1);
imshow(firstSlice, [])
%add gaussian noise to first slice of dicom file
%do not use MATLAB provided imnoise

%save new images as OrgImg.png and GaussianNoise.png in SAME folder as
%original
end

