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

%% open images 
% need to put fct to iterate over folder here  -- TODO
% read tiff as volume
imgName = ('ExampleData/vasculature.tif');
fname = tiffreadVolume(imgName);

% Get Voxel Volume -- TODO

%%% Gaussian Filter %%%
G = imgaussfilt3(fname,3);

%% Otsu Thresholding %%
level = graythresh(G);
OtsuBW = imbinarize(G,level);
% volshow(OtsuBW); % show volume
% make Maximum Intensity Projections (MIP)
MAX_OtsuBW = max(OtsuBW,[],3);
% save MIP
MIPs(MAX_OtsuBW,'Otsu'); % call fct to make MIPs; (a,b) = (which image, which name)
% analyse data
BW2 = bwmorph3(OtsuBW,'clean'); % remove single voxels
skeletonAnalysis(BW2, 'Otsu');
EdgeDetection(BW2);

% %% kMeans clustering
% computationally intense
% H = fibermetric(G,20); % enhances elongated / tubular structures using the Hessian matrix - computationally intense: https://uk.mathworks.com/help/images/ref/fibermetric.html
% kMeans = imsegkmeans3(H,5);
% % figure, volshow(kMeans);
% MAX_kMeans = max(kMeans,[],3);
% % save MIP
% MIPs(MAX_kMeans,'kMeans'); % call fct to make MIPs; (a,b) = (which image, which name)

%% FUNCTIONS %%
function MIPs = MIPs(img,saveName)
    str_saveas = 'Output/MAX_%s.png';
    % z = 'OtsuBW';
    str_saveas = sprintf(str_saveas, saveName);
    saveas(imshow(img), str_saveas)
end

function skeletonAnalysis = skeletonAnalysis(imageIn, segmentationType)
    %%% Skeletonization %%%
    skel = bwskel(imageIn);
    % make MIP
    MAX_skel = max(skel,[],3);
    % save MIP
    MIPs(MAX_skel,'Skel');
    % Count skel length
    [row, column] = find(skel);
    skelL       = [row, column];
    cskelL = length(skelL);
    fprintf('Skeleton Length %s Thresholding [vx]: %d \n',segmentationType,cskelL);
    
    %%% Count 3D Branching Points %%%
    BP = bwmorph3(skel,'branchpoints'); 
    MAX_BP = max(BP,[],3);
    % save MIP
    MIPs(MAX_BP,'BP');
    % Count BPs
    [row, column] = find(BP);
    BPs       = [row, column];
    cNumBP = length(BPs);
    fprintf('Skeleton Branchpoints %s Thresholding [vx]: %d \n',segmentationType,cNumBP);
    
    %%% Count 3D End-Points %%%
    EP = bwmorph3(skel,'endpoints'); 
    MAX_EP = max(EP,[],3);
    % save MIP
    MIPs(MAX_EP,'EP');
    % Count EPs
    [row, column] = find(EP);
    EPs       = [row, column];
    cNumEP = length(EPs);
    fprintf('Skeleton Endpoints %s Thresholding [vx]: %d \n',segmentationType,cNumEP);

end

function EdgeDetection = EdgeDetection(inName)
    %%% Canny Edge %%%
    cannyE = edge3(inName,'approxcanny', 0.5);
    % make MIP
    MAX_cannyE = max(cannyE,[],3);
    % save MIP
    MIPs(MAX_cannyE,'CannyE');
    
    %%% Quantify Number of Surface Voxels %%%
    [row, column] = find(cannyE);
    cannyEs      = [row, column];
    cNumCE = length(cannyEs);
    fprintf('Surface [vx]: %d \n',cNumCE);
end