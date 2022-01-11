%%% Full-Width Half Maximum (FWHM) calculation %%%
% This can be used to measure the influence of image enhancement and
% segmentation on object width (e.g. vessel diameters as shown here: https://www.biorxiv.org/content/10.1101/2020.07.21.213843v1)
%
% Adapted code from Image Analyst at https://uk.mathworks.com/matlabcentral/answers/310113-how-to-find-out-full-width-at-half-maximum-from-this-graph
%
% Author: Elisabeth Kugler 2021
% Contact: kugler.elisabeth@gmail.com

clearvars
close all
clc

% TODO - iterate over all files in a specified folder - i.e. prompt user
% for folder rather than fileName

fName = input('Please input file location and name (e.g. D:\FileNameExample.xlsx):\n','s');
data=xlsread(fName,'A:A'); % values saved in column A

reply = input('Do you know the voxel size? (y/n): ','s');
if strcmp(reply,'y')
    prompt = 'Input voxel size (e.g. 0.336) [um]:';
    voxelSize = input(prompt);
else
    voxelSize = 1;
end

%% Exploration of data distributions
summation = sum(data);
fprintf('Sum of all values: %d \n', summation);
MeanVal = mean(data);
fprintf('Mean of all values: %d \n', MeanVal);
MaxPoint = max(data);
fprintf('Maximum point of all values: %d \n', MaxPoint);

%% Find the half max value. 
% This section is from Image Analyst: https://uk.mathworks.com/matlabcentral/answers/310113-how-to-find-out-full-width-at-half-maximum-from-this-graph
halfMax = (min(data) + max(data)) / 2;
% Find where the data first drops below half the max.
index1 = find(data >= halfMax, 1, 'first');
% Find where the data last rises above half the max.
index2 = find(data >= halfMax, 1, 'last');
FWHM = index2-index1 + 1; % FWHM in indexes.

%% Print out output FWHM
% print in voxel
fprintf('FWHM in voxel: %d \n', FWHM);
% print in micrometer
fwhmMicrons = FWHM * voxelSize; 
fprintf('FWHM in microns: %d \n', fwhmMicrons);
