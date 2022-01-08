% Code to test image segmentation and analysis steps on 3D tiffs
% more info: https://uk.mathworks.com/help/images/3d-volumetric-image-processing.html?s_tid=CRUX_lftnav
% Author: Elisabeth Kugler 2021
% Contact: kugler.elisabeth@gmail.com
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

% need to put fct to iterate over folder here 
% read tiff as volume
imgName = 'F:\Matlab\ImageProcessingTests\ExampleData\vasculature.tif';
fname = tiffreadVolume(imgName);

%%% Gaussian Filter %%%
G = imgaussfilt3(fname,3);

%%% Otsu's thresholding %%%
level = graythresh(G);
OtsuBW = imbinarize(G,level);
% make MIP
MAX_OtsuBW = max(OtsuBW,[],3);
% save MIP
saveas(imshow(MAX_OtsuBW), 'F:\Matlab\ImageProcessingTests\Output\MAX_OtsuBW.png')

BW2 = bwmorph3(OtsuBW,'clean'); % remove single voxels

%%% Skeletonization %%%
skel = bwskel(BW2);
% make MIP
MAX_skel = max(skel,[],3);
% save MIP
saveas(imshow(MAX_skel), 'F:\Matlab\ImageProcessingTests\Output\MAX_skel.png');

%%% Count 3D Branching Points %%%
BP = bwmorph3(skel,'branchpoints'); 
[row column] = find(BP);
BPs       = [row column];
cNumBP = length(BPs);
fprintf('%d \n', cNumBP);

%%% Count 3D End-Points %%%
EP = bwmorph3(skel,'endpoints'); 
[row column] = find(EP);
EPs       = [row column];
cNumEP = length(EPs);
fprintf('%d \n', cNumEP);

%%
%%% Canny Edge %%%
cannyE = edge(BW2,'canny');
% make MIP
MAX_cannyE = max(cannyE,[],3);
% save MIP
saveas(imshow(cannyE), 'F:\Matlab\ImageProcessingTests\Output\MAX_cannyE.png');

%%% Quantify Number of Surface Voxels %%%
