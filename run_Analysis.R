
## Puneeth Chaithanya
## Course Project Assignment: Getting and Cleaning Data 
## Description: 
## The purpose of this project is to demonstrate your ability to collect, work
## with, and clean a data set. The goal is to prepare tidy data that can be used
## for later analysis. You will be graded by your peers on a series of yes/no
## questions related to the project. You will be required to submit: 1) a tidy
## data set as described below, 2) a link to a Github repository with your
## script for performing the analysis, and 3) a code book that describes the
## variables, the data, and any transformations or work that you performed to
## clean up the data called CodeBook.md. You should also include a README.md in
## the repo with your scripts. This repo explains how all of the scripts work
## and how they are connected.
## 
## One of the most exciting areas in all of data science right now is wearable
## computing - see for example this article . Companies like Fitbit, Nike, and
## Jawbone Up are racing to develop the most advanced algorithms to attract new
## users. The data linked to from the course website represent data collected
## from the accelerometers from the Samsung Galaxy S smartphone. A full
## description is available at the site where the data was obtained:
##   
##   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
## 
## Here are the data for the project: 
##   
##   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##


## Load library for data shaping
library(reshape2)
## Load activity labels - Uses descriptive activity names to name the activities in the data set
##1 WALKING
##2 WALKING_UPSTAIRS
##3 WALKING_DOWNSTAIRS
##4 SITTING
##5 STANDING
##6 LAYING
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Use grep to extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

## Load the training and  test data sets from wearable data
train <- read.table("./UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)
test <- read.table("./UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

## merge training and testing data sets and add their labels
combinedData <- rbind(train, test)
colnames(combinedData) <- c("subject", "activity", featuresWanted.names)

## turn activities & subjects into factors class
combinedData$activity <- factor(combinedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
combinedData$subject <- as.factor(combinedData$subject)
combinedData.melted <- melt(combinedData, id = c("subject", "activity"))
combinedData.mean <- dcast(combinedData.melted, subject + activity ~ variable, mean)

## Write out the tidy data set using write function
write.table(combinedData.mean, "tidy.txt", row.names=FALSE, quote=FALSE)