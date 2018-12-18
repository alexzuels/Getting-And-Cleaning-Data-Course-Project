library(tidyverse)
library(dplyr)
library(plyr)


## File Location is below.
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
File <- "UCI HAR Dataset.zip"

## Download Zip File to local machine so that you can read in the data 

#read training and test data in 
testsubject <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/test/subject_test.txt")
testdata <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/test/X_test.txt")
testactivities <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/test/y_test.txt")
trainingsubject <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/train/subject_train.txt")
trainingdata <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/train/X_train.txt")
trainingactivities <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/train/y_train.txt")

## load in activity label data and feature data 
activitylabels <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/activity_labels.txt")
features <- read.table("C:/Users/azuelsdorf/UCI HAR Dataset/features.txt", as.is = TRUE)

## combine matching data
combineddata <- rbind(cbind(trainingsubject,trainingdata,trainingactivities),cbind(testsubject,testdata,testactivities))

##Update Column names to breakdown the subject, activity and then data 
colnames(combineddata) <- c('subject',features[,2],'activitylabels')

##Filter to only mean and std dev
newcolumns <- grepl("subject|activitylabels|mean|std",colnames(combineddata))
combineddata <- combineddata[,newcolumns]

##create a factor for acitivies to have them structured in a better way grouping all 6 together 
combineddata$activitylabels <- factor(combineddata$activitylabels,levels = activitylabels[,1], labels = activitylabels[,2])

##summarise by creating average for each subject and each variable
finaldata <- ddply(combineddata,c("subject","activitylabels"), numcolwise(mean))

write.table(finaldata,file = "tidy_data.txt")

View(finaldata)