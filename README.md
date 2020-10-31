# dynbrainSS

## Description
'dynbrainSS' is a MATLAB gui interface that allow users to test and compare different Source Separation (SS) methods performance in dynamic functional connectivity context, in order to track spatiotemporal activity of brain networks during tasks. This gui is built based on the study of our article titled "Dynamics of task-related electrophysiological networks: a benchmarking study". Besides interface, a demo code version is available in the function: demo_dynBrainSS.m

## Installation
All you need to do is to: 
- Download and unpack all source code provided here
- Add them (folders and subfolders) into your MATLAB path
- Download fieldtrip package from our project release [release here](https://github.com/judytabbal/dynbrainSS/releases/tag/v1.0), but DO NOT manually add fieldtrip to your MATLAB path, ft_defaults will be added automatically by code
- Donwload and unpack HCP data from the [link](https://zenodo.org/record/3939725#.XwmIkpMzZ_R) in case you wish to test HCP data results through the interface

## Manual Guide
A pdf for 'dynbrainSS manual' is available in the [release here](https://github.com/judytabbal/dynbrainSS/releases/tag/v1.0) as a simple step-by-step guide for interface use.

## Results Examples
- Some MATLAB Figures for an example of ICA-JADE method application on dynamic functional connectivity of MEG data during motor and working memory tasks (used and described in our article, refer for more details) are available in the [release](https://github.com/judytabbal/dynbrainSS/releases/tag/v1.0). 
- These figures can be opened in MATLAB software and allow a good 3D interactive visualisation of brain networks.
