function [denoised] = myMedian(img,wsize)
%receives noisy image applies wsize x wsize filter and applies median
%non-linear filter

%image padded by repeating border elements
[rows, cols, dim] = size(img);
padding = wsize - 1;
padded = padarray(img, [(wsize -1), (wsize -1)],'replicate', 'both')

%generate kernel - DOES NOT work
med = @(x) median(x(:));
%do not use medfilt2 function

%run into issues due to dimensions of the image.
filtered = nlfilter(padded, [wsize, wsize], med);
denoised = filtered(padding +1: rows+ padding, padding + 1:padding +cols, :);

%save images as .png
imwrite(img, '1-Noisy.png');
imwrite(denoised, '2-Denoised.png');

end

