% Code to measure image similarity - e.g. after image registration 
% Author: Elisabeth Kugler 2021
% Contact: kugler.elisabeth@gmail.com
%  
% Measures: Sum of Squared Differences, Sum of Absolute Differences,
% Maximum of Absolute Differences, Mean Square Error, Structual Similarity
% Information, and Mutual Information
%
% BSD 3-Clause License
% 
% Copyright (c) [2021], [Elisabeth C. Kugler]
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

clearvars
close all
clc

% user prompt for template image (the one to which images were registered)
fname = input('Template image file name: ' , 's'); % e.g. F:\Matlab\ImageSimilarityMeasurement\ExampleData\vasculature.tif
info = imfinfo(fname);
num_images = numel(info);

% user prompt for registered (or moving) image (the one that was registered to the template)
fnameAligned = input('Registered image file name: ' , 's'); % e.g. F:\Matlab\ImageSimilarityMeasurement\ExampleData\brain.tif
infoAligned = imfinfo(fnameAligned);
num_imagesAligned = numel(infoAligned);

% read in stack
for k = 1:num_images
    I = imread(fname, k, 'Info', info);
    B(:,:,k) = I(:,:,1);  
    
    A = imread(fnameAligned, k, 'Info', infoAligned);
    Z(:,:,k) = A(:,:,1);
end 

% Sum of Squared Differences (SSD)
Y = B-Z;
ssd = sum(sum(Y(:).^2));
fprintf('%d \n', ssd);

% Sum of Absolute Differences (SAD)
absolute = abs(Y);
result = sum(absolute(:));
fprintf('%d \n', result);

% Maximum of Absolute Differences (MAD)
resultMax = max(absolute(:));
fprintf('%d \n', resultMax);

% Mean Square Error (MSE)
meansqu = sum(immse(B,Z));
fprintf('%d \n', meansqu);

% Structual Similarity Information (SSI)
ssimvalue = ssim(B,Z);
fprintf('%d \n', ssimvalue);

% Mutual Information (MI)
% This requires a lot of memory.
% mInfo = MI_GG(B,Z);
% fprintf('%d \n', mInfo);
