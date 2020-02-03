%Laplacian of Gaussian 

%f(x,y)
original = imread('ChestXray.png');
original = rgb2gray(original);
original = im2double(original);

%apply LoG

%generate log kernel
Lk = myLoG(9, 0.6);

edge = conv2(original, Lk, 'same');


%out(x,y)
out = original - edge; 


%apply myHistEq.m
out = mat2gray(out)*255;
sharpimg = myHistEq(out);
imwrite(sharpimg, '7-SharpenedwithLoG.png');

figure(2);
subplot(1,3,1)
imshow(original, []);
title('Original');
subplot(1,3,2);
imshow(edge, []);
title('Edge');
subplot(1,3,3);
imshow(out, []);
title('Sharpened');