# Engineering school project : Matlab face detection using 'supervised learning'

## Description
This project was part of my computer engineering formation. 
The goal of this project was to develop under Matlab, a supervised learning to obtain a Support Vector Machine (SVM) model of face detection of people on test images. 
For this, we have training images provided with the coordinates of the positive area of the face. 
We need to create a model based on positive data, negative X and Y as seen in class. 

### First learning
We have train images (folder 'train') and coordinates of the faces associated (folder 'label'). 
The first step is to retrieve all the positive data and find surrounding negative data to create a first SVM model.
We have a model that can be applied to train images and which results can be comparated to the real given faces coordinates.

### Second learning
The first model is not accurate and effective enought, we muste create a more efficient second SVM model.
We need to have 'false positives' coordinates of cropped images to the first model. 
For that I have a function 'glissage2’ that check the results of the first model applied to train images and compared them to the real coordinates.
Every coordinates that doesn't match are added as 'false positives' data to the second model.

### Face detection on test images
Now that we have an efficient enought SVM model, we can apply it to the tests images in order to retrieve the faces coordinates.
The function 'testImage’ takes the test images (folder 'test') on which apply the model, and creates a result text file for each image (under the folder 'testLabel').

## Prerequisites

You will need to dispose of a computer with Matlab software installed.

## Installing and usage

* Download the source code from GitHub.
* Launch Matlab software and select 'import project'.
* Navigate to the root path of the downloaded project, import project and validate.
* Execute the main script 'scriptProject.m'.

## Authors

* **Maxime DONNET** - *School Supervised Learning faces detection* - [School_Supervised_Learning_faces_detection](https://github.com/maxou75/School_Supervised_Learning_faces_detection)

