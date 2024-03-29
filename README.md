# Spherical particle segmentation in CT scan data

## Introduction
In this project, I want to analyze the properties of particles (sphericity, volume and 2D projected area) in 3D CT scan data, see Figure below for a slice from the dataset. Here, I will explain the segmentation of the particles in the dataset.

<img src="figures/slice_0.png" width="300">

## Dataset
You can find an example input and my method's output (50 slices each) in the folder `data`.

## Installation
Within the project, I used the software ImageJ, its plugins and MATLAB R2019b. 

Here is the download link for ImageJ: [Download ImageJ](https://imagej.net/Downloads)

Here is the plugin's webpage: [ImageJ 3D segmentation plugin](https://imagejdocu.tudor.lu/plugin/segmentation/3d_spots_segmentation/start#d_segmentation)

## Problems & Approaches

As I mentioned, I want to segment particles in the dataset. However, I have a problem for the final segmentation: Holes in particular particles, see the most left Figure below. These holes give trouble for a fully segmentation of the particles. So, I have to fill these holes. The idea in my mind is to extract these holes by using their [sphericity factors](https://en.wikipedia.org/wiki/Sphericity). First, I separated these holes from the background by using the watershed algorithm. Then, I filtered out all the components in the watershed transformed image which have a lower sphericity factor than a threshold, see the steps of the hole extraction steps in Figure below. That simple!

<img src="figures/holes_steps.png" width="800">

After filling these holes, I am ready for the final segmentation. I used the watershed algorithm again but for the particles this time. Here is what I got.

<img src="figures/final_segmentation.png" width="600">

## Procedure
I applied two watershed segmentation algorithms consecutively: First, holes in the particles are filled up by using the sphericity of holes (see the details at **Challenges**), i.e. **Hole extraction**, followed by **Particle segmentation**. Here is the whole procedure I followed to segment particles in the CT scan data:

1. Hole extraction (*Enhance contrast after the step)
- Inverse image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_i" title="holes inverse image" />: Binarizing the raw CT scan images such that the voxel values of background larger*
- Grayscale image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_g" title="holes grayscale image" />: Applying distance transform on the inverse image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_i" title="holes inverse image" />* followed by Mean filtering* (noise redeuction)
- Markers <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_m" title="holes marker image" />: Maxima finder on the grayscale image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_g" title="holes grayscale image" />*
- Watershed image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_w" title="holes watershed image" />: Watershed (graycale <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_g" title="holes grayscale image" /> +markers <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_m" title="holes marker image" />) and binarize
- Holes filled image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_h" title="holes filled image" />: Detect and fill the holes in the watershed image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_w" title="holes watershed image" /> by extracting the components having a large sphericity factor (sphericity > 0.85)

2. Particle Segmentation (*Enhance contrast after the step)
- Grayscale image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_r" title="particles grayscale image" />: Distance transform on the inverse holes filled image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_h" title="holes filled image" />* + followed by Mean filtering* (noise redeuction)
- Markers <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_a" title="particles marker image" />: Maxima finder on the grayscale image <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_r" title="particles grayscale image" />
- Watershed (graycale <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_r" title="particles grayscale image" /> +markers <img src="https://latex.codecogs.com/svg.latex?\Large&space;I_a" title="particles marker image" />) and binarize

## Notes
A common problem during the watershed algorithm is oversegmentation. In order to avoid that, you should pay attention to how to choose the markers of the watershed algorithm. I used the tool Maxima Finder in the [plugin](https://imagejdocu.tudor.lu/plugin/segmentation/3d_spots_segmentation) for that. After a few tentative attemps, I set optimal kernel radius and threshold.
