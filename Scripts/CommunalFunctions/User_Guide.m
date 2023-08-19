%% USER GUIDE
% Run these scripts to measure behavior, 
% 
% using the output CSV files from DeepLabCut.
% 
% *|BEFORE ANYTHING|*, import functions: 
% 
% >>Import_Scripts
% 
%% General
% 
% Crop a bathc of video files, choosing a rectangular area and ffmpeg
% commands (Necessary MATLAB R2018b at least & FFMPEG installed)
% Input: file directory and video fille extensions
% 
% >>CropMagic
% 
% Ouput: cropped video files
% 
%% 1- Circular Open Field 
% 
% Visualizes Centroid Trajectory from posture CSV files:
% 
% >>Script_OpenField
% 
% Save .mat file for further analysis [
% *This requires snapshots from each video*]
% 
% >>OpenFieldfromDLC
% 
% Load .mat file in workspace and:
% 
% >>Plot_Experiment
% 
% PLOT BOXPLOTS TO COMPARE CONDITIONS from .mat FILES
% 
% >>ShowOpenFieldFeatures
% 
%% 2- Gait Analysis
% 
% Run the script and:
% 
% >>GaitAnalysis
% 
% 1)Enter CSV from DCL
% 
% 2)Enter Snapshot from video and set dimensions
% 
% 3)Enter References of sizes
% 
% 4)Copy-paste output lengths
% 
% Important: read texts in the Command Window
% 
%% 3- Object Location Memory OLM
% 
% DOTS FROM DLC: {'earleft';'earright','nose','center','lateralleft',
% 'lateralright','tailbase','tailend','oa1','oa2';'oa3','oa4','ob1','ob2'
% 'ob3','ob4x','top','right','down','left'}
% 
%  1) Individual analysis: Inut: CSV from DLC and choose parameters
% 
%  >> OLM_intel
% 
%   Output: CSV with measured features and plots
% 
%  2) batch analysis:
% 
%  >> OLM_intel_Batch
% 
%   Output: CSV with measured features 
% 
% 3) Visuazlizations
% 
% 3.1) HeatMaps (Run after OLM_intel)
%   
% >> Color_Map_Neighbourhood(2,.5,.5,DataOLM,Field)
% 
% 3.2) Distance video to polygons (Run after OLM_intel)
%   
% >> animatedistance(pgonA,pgonB,Xnose,Ynose,topLim,bottomLim,rightLim,leftLim,fps,tnose,1);
