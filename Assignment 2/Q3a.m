%script for q3a

kernel = myGaussian(11, 1.5);
figure(1);
surf(kernel);
sum_k = sum(kernel,'all');

figure(2);
subplot(1,2,1);
original = imread('ChestXray.png');
original = rgb2gray(original);
imshow(original,[]);
title("Original");

%convolve image with kernel
smooth = conv2(original, kernel, 'same');
subplot(1,2,2);
imshow(smooth, []);
title("Smoothed");
imwrite(smooth, '5-SmoothedwithGaussian.png');
