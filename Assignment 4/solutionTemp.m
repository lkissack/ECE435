clear; clc; close all; 

%% Problem 1: Read the labels and separate the data accordingly (saving images as
%.png). In the end, you should have three folder (F,G,D) containing the
%.png files.
% hint: functions readtable, split
%% Create folders
mkdir('F');
mkdir('G');
mkdir('D');

%% Read Table and sort images
filename = 'labels.txt';
%can't use space as delimiter since there are different numbers of cols
T = readtable(filename, 'TextType', 'string');

images = size(T,1);

for index = 1:images
    %read the row until the second label
    image = split(T{index,1});
    source = image(1) + ".pgm";
    destination = image(1)+".png";
    if image(2)=="D"
        %put the image in file D
        destination = "D\"+destination;
    elseif image(2)=="F"
        %put the image in file F
        destination = "F\"+destination;
    elseif image(2)=="G"
        %put the image in file G
        destination = "G\"+destination;
    end
    %check that the file hasn't been moved already
    %deals with duplicates in the .txt file
    if isfile(source)
        status = movefile(source, destination);
    end
end

%% Problem 2: Pre-process the data
% pre-process all the data that is in the D, F, G folders
% ensure matlab is NOT operating from D,F,G directories (should be level
% containing them
targetsize = [224,224];
%for each image in F, D, G
F = dir('F')
for i = 1:size(F,1)
    %for testing purposes
    %F(i).name;
    imagename=char("F\"+F(i).name)
    if isfile(imagename)
        im = imread(imagename);
        image = preProcess(im , targetsize);
        imwrite(image,imagename);
    end
end

G = dir('G')
for i = 1:size(G,1)
    %for testing purposes
    imagename = char("G\"+G(i).name);
    if isfile(imagename)
        image = preProcess(imread(imagename), targetsize);
        imwrite(image,imagename);
    end
end

D = dir('D')
for i = 1:size(D,1)
    %for testing purposes
   imagename =  char("D\"+D(i).name);
    if isfile(imagename)
        image = preProcess(imread(imagename), targetsize);
        imwrite(image,imagename);
    end
end

%% Problem 3: Load all the data in a datastore. The categorical labels are going to be
% created based on the names of the folders each sample is in. hint:
% imageDatastore function. 

imds = imageDatastore({'D','F','G'}, 'FileExtensions', {'.png'},'LabelSource','foldernames');

% show how many samples from each class there are. Ideally, the number of
% samples per class should be approximately the same. hint: countEachLabel
% function. 
info = countEachLabel(imds)

% Randomly split the image datastore into training and testing  
train_percent=0.7;

[imdsTrain, imdsTest] = splitEachLabel(imds,train_percent, 'randomized');

%% Problem 4

%extract HoG features
cellSize = [4 4];
[trainFeatures, trainLabels] = extractHOG(imdsTrain, cellSize); 

% Now extract the features for the test set
[testFeatures, testLabels] = extractHOG(imdsTest, cellSize);

%% Problem 5: Train an SVM classifier based on the HoG features (hint: fitcecoc function)
% disp('Training the SVM classifier...');
% SVMclassifier = %TO-DO
% 
% disp('Testing the SVM classifier...');
% % Make class predictions using the test features. hint(predict function)
% predictedLabels = %TO-DO
% 
% % plot a confusion matrix to analyze the results
% %TO-DO
% title('Confusion Matrix for the SVM classifier using HoG features');
% 
%% Problem 6: Split the training set into training and validation. That will help
% % monito the progress of the training process. 
% 
% valid_percent=0.3;
% [imdsValid,imdsTrain]=%TO-DO
% 
% % check the distribution of samples left for the training
% disp('Distribution of samples per class in the training set:');
% %TO-DO
% 
% % create and apply image augmentation structure that randomly reflects the
% % training images along the x-axis. hint: imageDataAugmenter and
% % augmentedImageDatastore functions
% 
% imageAugmenter = imageDataAugmenter(%TO-DO);
% augimdsTrain = %TO-DO 
% 
%% Problem 7: create a ResNet-50
% disp('Creating a resnet50 network.')
% net = %TO-DO; 
% 
% % replace the last fully-connected and classification layers to account for
% % the number of classes (3)
% %TO-DO
% 
% options=trainingOptions('adam', ...
%     'MiniBatchSize',20, ... % trains on 20 samples at a time
%     'MaxEpochs',5, ... % passes through the whole dataset 5 times while training
%     'Shuffle','every-epoch', ... % shuffles the data on every new pass through the dataset 
%     'InitialLearnRate',1e-4, ... % defines how fast the parameters will change to reduce the loss
%     'ValidationData',imdsValid, ... % uses validation set to evaluate the network while it is trained
%     'ValidationFrequency',1, ... % performs the validation every "minibatch" number of samples
%     'Verbose',false, ... % does not show display training information on the command window
%     'Plots','training-progress'); % plots the training progress (with validation)
% 
% % Train the ResNet-50 network
% disp('Training the ResNet-50 classifier...');
% %TO-DO
% 
% % Use the trained classifier in the test set 
% %TO-DO
% 
% % Plot a confusion matrix to analyze the results
% %TO-DO
% title('Confusion matrix for the ResNet-based classifier');
% 
function [out] = preProcess(img, targetSize)
I=img;

% 1.resize the image to 224x224 (targetSize)
I = imresize(I, targetSize);

%2. Turn the image to three-channel
I3  = cat(3, I, I, I);

%3 apply hist. eq. (hint: histeq function)
result = histeq(I3);
out = result;
%for testing pur
% figure(1);
% imshow(I,[]);
% figure(2);
% imhist(I);
% figure(3);
% imshow(result,[]);
% figure(4);
% imhist(result);

end

function [features, setLabels] = extractHOG(imds, ~)

setLabels = imds.Labels;
numImages = numel(imds.Files);

%pre-allocate an array to hold the features (determine its size, hogSize, by 
%extracting the HoG from one image with cellSize

features  = zeros(numImages, length(hogSize), 'single'); 

% Extract the features from each image
for j = 1:numImages
    %TO-DO
end
end

