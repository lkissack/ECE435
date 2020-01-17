function [] = CorrVsConv(imageAddress)
Fhor = [-1 0 1; -1 0 1; -1 0 1];
image = imread(imageAddress);
%uses zero padding by default
correlated = imfilter(image, Fhor, 'corr');
convoluted = imfilter(image, Fhor, 'conv');

subplot(1,2,1)
imshow(correlated)
title('Correlated')
subplot(1,2,2)
imshow(convoluted)
title('Convoluted')

end

