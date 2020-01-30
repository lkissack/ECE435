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

%not a very fast way to perform this transformation
% for k = 1:rows
%     for m = 1:cols
%      imgHE(k,m) = (255)/(rows*cols)*cHist(gray(k,m));
%        %imgHE(k,m) = (255)*cHist(gray(k,m));
%     end
% end

%Better way to perform calculation
Tk = ((255)/(rows*cols))*cHist;
for k = 1:rows
    for m = 1:cols
     imgHE(k,m) = Tk(gray(k,m));
    end
end
%since Tk contains small doubles of probability for intensity
a = mat2gray(imgHE)*255;
imgHE = uint8(a);

%generate histogram of new image
subplot(2,2,2);
heHist = imhist(imgHE);
imhist(imgHE);
title("Equalized Histogram");

%Save original and equalized
imwrite(gray, '3-LowContrast.png');
imwrite(imgHE, '4-HistogramEqualized.png');

% oHist = bar(orgHist);
% title('Original Histogram');
% saveas(oHist, 'OriginalHistogram.png');
% hHist = bar(heHist);
% title('Equalized Histogram');
% saveas(hHist, 'EqualizedHistogram.png');

subplot(2,2,3);
imshow(gray, []);
title('Original Image');
subplot(2,2,4);
imshow(imgHE, []);
title('Equalized Image');

end

