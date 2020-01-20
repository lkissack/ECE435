function [denoised] = myMedian(img,wsize)
%receives noisy image applies wsize x wsize filter and applies median
%non-linear filter

%image padded by repeating border elements
[rows, cols, dim] = size(img);
padding = wsize - 1;
padded = padarray(img, [(wsize -1), (wsize -1)],'replicate', 'both');

%generate kernel - Takes the median for a single colour (2d only)
med = @(x) median(x(:));

%allocate and specify to use uint8 (otherwise result is white)
filtered = zeros(rows + 2*padding, cols +2*padding, dim, 'uint8');

for colour = 1:dim
    filtered(:,:,colour) = nlfilter( padded(:,:,colour), [wsize, wsize], med);
end

denoised = filtered(padding +1: rows+ padding, padding + 1:padding +cols, :);
    
%save images as .png
imwrite(img, '1-Noisy.png');
imwrite(denoised, '2-Denoised.png');

%for testing purposes
% subplot(1,2,1);
% imshow(img, []);
% subplot(1,2,2);
% imshow(denoised, []);

end

