### Introduction

This repository contains the artifacts for the Getting and Cleaning Data
course project.

The project required writing an R script that would process a dataset
(Human Activity Recognition Using Smartphones Dataset) collected from
Samsung smartphones carried by a group of volunteers.  

The raw dataset is contained in the UCI HAR Dataset.zip archive included
in this repository.  It is described in the README.txt file included in
that archive.


### Preparing the Tidy Dataset

In order to prepare the raw data for subsequent analysis, an R script
(run_analysis.R) was written.  This script assumes the presence of the
raw data in a directory, within the current working directory, called
"UC HAR Dataset".

The "run_analysis.R" script in this repository constructs a tidy dataset
by performing the following:

     Merges the training and the test sets in the UCI HAR Dataset to create one data set.
     Extracts only the measurements on the mean and standard deviation for each measurement. 
     Uses descriptive activity names to name the activities in the data set
     Appropriately labels the data set with descriptive variable names. 
     Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
     Writes the tidy data set out to a file called "tidyData.txt"

