%Gaussian Based image sharpening

imgOriginal = imread('ChestXray.png');

%f(x,y) - make grayscale image then convert to double since other
%quantities result in doubles
img = rgb2gray(imgOriginal);
img = im2double(img);

Gk = myGaussian(11, 1.5);
smoothed = conv2(img,Gk,'same');

%g(x,y)
edged = img - smoothed;

%out(x,y)
sharpened = edged + img;

sharpened = mat2gray(sharpened)*255;
sharpImg = myHistEq(sharpened);
imshow(sharpImg, []);
imwrite(sharpImg, '6-SharpenedwithGaussian.png');

%For testing purposes
figure(2);
subplot(2,2,1);
imshow(img,[]);
title('Original');
subplot(2,2,2);
imshow(smoothed, []);
title('Smoothed');
subplot(2,2,3);
imshow(edged,[]);
title('Edge');
subplot(2,2,4);
imshow(sharpened,[]);
title('Sharpened');

