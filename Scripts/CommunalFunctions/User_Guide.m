%% USER GUIDE
% Run these scripts to measure behavior, 
% 
% using the output CSV files from DeepLabCut.
% 
% *|BEFORE ANYTHING|*, import functions: 
% 
% >>Import_Scripts
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
%% 3- AIMs
% 
% developing ...