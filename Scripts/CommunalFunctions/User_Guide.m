%% USER GUIDE
%  
% Specific instructions for each task
% 
% *|BEFORE ANYTHING|*, import functions: 
% 
% >>Import_Scripts
% 
%% GUIs_4_FFMPEG
% 
% Necessary MATLAB R2018b at least & FFMPEG installed as system variable
% 
% *CropMagic* It allows to choose a rectangular area from each file from a batch of video recordings
% 
%   >>CropMagic
% 
% Input: file directory and video file extensions (it reads all files in the folder)
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
%% 3- Object Location Memory (OLM)
% 
%  This scripts detects explorations of distance (d) of the mouse's nose to objects when: 0<d<2 cm
% 
%  DOTS FROM DLC: {'earleft';'earright','nose','center','lateralleft',
% 'lateralright','tailbase','tailend','oa1','oa2';'oa3','oa4','ob1','ob2'
% 'ob3','ob4x','top','right','down','left'}
% 
%  1) Analysis of CSV filesfrom DLC and set parameters: distance threshold,
%  fps and experimental condition
% 
%  >>OLM_intel_Batch
% 
%   Output: CSV with measured features and plot of trajectory and
%   explorations detected
% 
%  2) Additional visualizations/plots and data (run after indiviudal
%  analysis)
% 
% Only displays:
% 
%  >>animatedistance(FD,pgonA,pgonB,Xnose,Ynose,topLim,bottomLim,rightLim,leftLim,fps,tnose,0);
% 
% Saves animations as file (see help documentation):
% 
%  >>animatedistance(FD,pgonA,pgonB,Xnose,Ynose,topLim,bottomLim,rightLim,leftLim,fps,tnose,1); 
% 
%  Output animation of distance between nose and objects (polygons)
% 
% >> Color_Map_Neighbourhood(2,.5,.5,DataOLM,Field)
% 
%  3) Makes log of events: run after single OLM_Intel_Batch:
% 
%  >>export_log
% 
%  4) Review videos: read log file and video
% 
%   >>OLM_Checker
% 
%% General use
% 
%  Stack CSV files (outputs of the scripts with the same columns)
% 
% >>joindata
% 
% Create maps using CBREWER
% 
% >>Color_Selector
% 
% Displays colormaps from CBREWER
% 
% >>HELP_CBREWER