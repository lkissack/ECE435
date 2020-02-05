function [imgHE, orgHist, heHist] = myHistEq(img)
%imgHE = histogram equalized img
%orgHist = original images histogram
%heHist = equalized images histogram

%1. check image properties
[rows, cols, colours] = size(img);
gray = uint8(img);
if colours == 3
    gray = rgb2gray(img);
    [rows, cols] = size(gray);
end

figure(1);
subplot(2,2,1);
%2. Histogram generation
orgHist = imhist(gray);
% to display the histogram
imhist(gray);
title("Original Histogram");

%3. Probability Array
totalpx = rows*cols;
pHist = orgHist/totalpx;

%4. Cumulative histogram generation
cHist = cumsum(pHist);

%5. Transformation Function
%leave as double for now - need to scale back to uint8 before generating
%histogram again
imgHE = zeros(rows, cols);

%but issues if value of gray = 0
Tk = ((255)/(rows*cols))*cHist;
for k = 1:rows
    for m = 1:cols
        %add plus one to prevent issues when gray = 0
        %not concerned about gray =255 since Tk(256) exists
        imgHE(k,m) = Tk(gray(k,m)+1);
    end
end
%since Tk contains small doubles of probability for intensity
a = mat2gray(imgHE)*255;
imgHE = uint8(a);

%generate histogram of new image

subplot(2,2,2);
heHist = imhist(imgHE);
%displays histogram
imhist(imgHE);
title("Equalized Histogram");

%Save original and equalized
imwrite(gray, '3-LowContrast.png');
imwrite(imgHE, '4-HistogramEqualized.png');

%finish plotting them
subplot(2,2,3);
imshow(gray, []);
title('Original Image');
subplot(2,2,4);
imshow(imgHE, []);
title('Equalized Image');

%save histograms as images
figure(3);
oHist = bar(orgHist);
title('Original Histogram');
saveas(oHist, 'OriginalHistogram.png');
figure(4);
hHist = bar(heHist);
title('Equalized Histogram');
saveas(hHist, 'EqualizedHistogram.png');
end

