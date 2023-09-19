# Laboratory Behaviors

+ Toolbox of MATLAB scripts to extract features and retrieve information from animal behaviors


## Requirements

- DeepLabCut [DLC](https://deeplabcut.github.io/DeepLabCut/README.html)

- [MATLAB](https://la.mathworks.com/)

- [FFmpeg](https://www.ffmpeg.org/) to crop, trim and change resoluton of videos as sys var


## TASKS


### Circular OpenField

Pose detection sample:

![Setup](/Figures/OpenField_Mice.png "Circular Open Field")

### Squared OpenField

Pose detection sample:

![Setup](/Figures/SQR_OpenField.png "Rectangular Open Field")

### Rectangular OpenField

Pose detection sample:

![Setup](/Figures/OpenField_Mice.png "Circular Open Field")

### Gait patterns

Pose detection sample:

![Setup](/Figures/Gait_Mice.png "Gait Patterns")


### Object Location Memory (OLM)

Pose detection sample:

![Setup](/Figures/OLM_task_A.png "Sinlge mouse")

![Setup](/Figures/OLM_task_B.png "Sinlge mouse and optic fiber")


### Pupils (mice eyes)

Pose detection sample:

![Setup](/Figures/Pupils.png "Mouse in Go/NoGo task")

### Sounds (ultrasonic microphone)

Analysis and edition of sound recordings.

### GUIs for FFMPEG 

- Graphical Use Interface to crop videos


## General guide

2. All lscritps read CSV obtained from DLC of specific trained networks

3. Some tasks require snapshots from the videos processed in DLC (e.g. Circular Open Field & Gait Patterns)

4. Specific guide [**this**](http://htmlpreview.github.io/?https://github.com/vladscript/labbehavior/blob/master/html/USER_GUIDE.html)

### Third Party Code

Alejandro Weinstein (2023). Distance from a point to polygon (https://www.mathworks.com/matlabcentral/fileexchange/19398-distance-from-a-point-to-polygon), MATLAB Central File Exchange. Retrieved March 23, 2023.

[CBREWER](https://www.mathworks.com/matlabcentral/fileexchange/58350-cbrewer2)

## Gear to train Networks

Resnet:
PC environment GPU GeForce GTX 1050 Ti in Ubuntu 18.04.5,
NVIDIA-SMI 450.66 CUDA version 11.0.

mobilenet v21.0
Windows 11 PC (Dell OptiPlex 7090 with Intel Core i7 CPU 2.90 GHz and 40 GB RAM) 

Labelling was peroformed in Windows and Ubuntu laptops/PCs