# Laboratory Behaviors (IFC-UNAM-Neuroscience)

+ Asses motor behaviors in rodents for slice brain experiments, *electrophysiology* and *calcium imaging*

+ MATLAB scripts to analyze poses from [DeepLabCut](https://github.com/DeepLabCut/DeepLabCut)

### Circular Open Field

- Setup: Cilinder

- Camera: Android telephone & Ipad, Training Resolution

- Bodyparts: ***Head***, ***Tail Base***, ***Back***, ***Left Ear***, ***Right Ear***

### Gait

Specs:

- Setup: custom acrylic bridge

- Camera: Android telephone

- Bodyparts:

### Abnormal Involuntary Movements

Specs:

- Setup:

- Camera:

- Bodyparts:

## Trained Networks

DeepLabCut Models were trained using data with only C57 BL/6J only (for now).

PC environment GPU GeForce GTX 1050 Ti in Ubuntu 18.04.5,
NVIDIA-SMI 450.66 CUDA version 11.0.

Labelling was peroformed in Windows and Ubuntu CPU

### OpenField

Training error:

Validation error:

Detection example:

![Setup](/Figures/OpenField_Mice.png "Circular Open Field")

LINK

### Gait

Training error:

Validation error:

Detection example:

![Setup](/Figures/Gait_Mice.png "Gait Patterns")

LINK

### AIMs (box)

Training error:

Validation error:

LINK

## Instructions for new data

### Requirements

- DeepLabCut (DLC)

- MATLAB

- Optional but higly recomended: [FFmpeg](https://www.ffmpeg.org/) to edit videos.

### Steps

1. Download model(s) of interest and modify config file to use it in your computer

2. Analyze and extract CSV poses using DLC

3. Save snapshots for each video (in case of Open Field & Gait)

4. Run Scripts and follow [**this**](http://htmlpreview.github.io/?https://github.com/vladscript/labbehavior/blob/master/html/USER_GUIDE.html)