function [imgHE, orgHist, heHist] = myHistEq(img)
%imgHE = histogram equalized img
%orgHist = original images histogram
%heHist = equalized images histogram

%1. check image properties
gray = rgb2gray(img);
[rows, cols] = size(gray);

%for testing purposes
%imshow(gray, [])

%2. Histogram generation
orgHist = imhist(gray);
%should print for 2019b, does not seem to for 2018a

%3. Probability Array
totalpx = rows*cols;
pHist = orgHist/totalpx;

%4. Cumulative histogram generation
cHist = cumsum(pHist);

%5. Transformation Function
imgHE = zeros(rows, cols);

%not a very fast way to perform this transformation
for k = 1:rows
    for m = 1:cols
    imgHE(k,m) = (255)/(rows*cols)*cHist(gray(k,m));
    end
end

%for testing purposes
imshow(imgHE, []);
%THIS IS NO LONGER IN UINT8
imgHE = uint8(imgHE*256);

%generate histogram of new image - this is not working?
heHist = imhist(imgHE);

%Save original and equalized
imwrite(gray, '3-LowContrast.png');
imwrite(imgHE, '4-HistogramEqualized.png');

oHist = bar(orgHist);
title('Original Histogram');
saveas(oHist, 'OriginalHistogram.png');
hHist = bar(heHist);
title('Equalized Histogram');
saveas(hHist, 'EqualizedHistogram.png');

subplot(1,2,1);
imshow(gray, []);
title('Original Image');
subplot(1,2,2);
imshow(imgHE, []);
%title(sprintf('Denoised Image n = %d',wsize));


end

