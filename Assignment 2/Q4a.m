%Gaussian Based image sharpening


%load image - not sure what the starting image is
imgOriginal = imread('ChestXray.png');
img = rgb2gray(imgOriginal);
%not sure what should be happening with the type
%img = im2double(img);

Gk = myGaussian(11, 1.5);

smoothed = conv2(img,Gk,'same');

edged = im2double(img) - smoothed;

sharpened = edged + img;

%sharpened is already a double before being processed by myHistEq
sharpImg = myHistEq(sharpened);
imshow(sharpImg, []);
imwrite(sharpImg, '6-SharpenedwithGaussian.png');
