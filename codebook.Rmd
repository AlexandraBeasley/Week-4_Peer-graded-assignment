---
title: "Week - 4 Peer-graded Assignment: Getting and Cleaning Data Course Project"
author: "Alexandra Beasley"

---
#Load packages
```{r}
#Load packages
library(tidyr)
library(dplyr)
library(data.table)
library(plyr)
library(stringr)
```

# Question 1.
##Merges the training and the test sets to create one data set.
```{r}
# Download data set and extract files
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "/Users/m039688/Desktop/R_Class/Week_4/UCIMachinelearning.zip", method = "curl")

# Unzip files
unzip("/Users/m039688/Desktop/R_Class/Week_4/UCIMachinelearning.zip", exdir = "/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/")
```

```{r}
# Read train data set
subject_train <- read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_train <- read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/train/y_train.txt", header = FALSE)
```

```{r}
# Read test data set
subject_test <- read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_test <- read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/test/y_test.txt", header = FALSE)
```
```{r}
# Read features of data sets
data_features <- read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/features.txt", header = FALSE)

# Read activity labels
activity_labels = read.table("/Users/m039688/Desktop/R_Class/Week_4/UCI HAR Dataset/activity_labels.txt", header = FALSE)
```


```{r}
# Add column names for data sets
colnames(x_train) <- data_features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- data_features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activity_labels) <- c("activityID", "activityType")
```


```{r}
# Combine test sets and trains sets to make one merge data table
test_combine <- cbind(y_test, subject_test, x_test) 
train_combine <- cbind(y_train, subject_train, x_train)
mergeData <- rbind(test_combine, train_combine)
```


# Question 2 Extract the measurements on the mean and standard deviation for each measurement. Labeled columns

```{r}
# Make a table including only mean and standard deviation (grep)
colNames <- colnames(mergeData)

# Table containing ID, mean, stdev
meanstd <- grep(".*Mean.*|.Std.*", names(mergeData), ignore.case = TRUE)
requiredcols <- c(meanstd, 562, 563)
dim(mergeData)
```

# Question 3 Uses descriptive activity names to name the activities in the data set
```{r}
mergeData$activity <- as.character(mergeData$activity) 
for(i in 1:6){mergeData$activity[mergeData$activity == i] <- as.character(activity_labels[i,2])}

mergeData$activity <- as.factor(mergeData$activity)
```

#Question 4 Label data set with descriptive variable names
```{r}
names(mergeData) <- gsub("^t", "time", names(mergeData))
names(mergeData) <- gsub("^f", "frequency", names(mergeData))
names(mergeData) <- gsub("Acc", "Accelerometer", names(mergeData))
names(mergeData) <- gsub("Gyro", "Gyroscope", names(mergeData))
names(mergeData) <- gsub("Mag", "Magnitude", names(mergeData))
names(mergeData) <- gsub("BodyBody", "Body", names(mergeData))
names(mergeData) <- gsub("tBody", "TimeBody", names(mergeData))
names(mergeData) <- gsub("-mean()", "Mean", names(mergeData), ignore.case = TRUE)
names(mergeData) <- gsub("-std()", "STD", names(mergeData), ignore.case = TRUE)
names(mergeData) <- gsub("-freq()", "Frequency", names(mergeData), ignore.case = TRUE)
names(mergeData) <- gsub("angle", "Angle", names(mergeData))
names(mergeData) <- gsub("gravity", "Gravity", names(mergeData))
```


# Question 5 Create a tidy data set with the average of each variable for each activity and each subject
```{r}
# Set subject as a factor variable
mergeData$subjectID <- as.factor(mergeData$subjectID)

mergeData <- data.table(mergeData)
```

```{r}
tidydataset <- aggregate(. ~subjectID + activity, mergeData, mean)
tidydataset <- tidydataset[order(tidydataset$subjectID, tidydataset$activity),]
write.table(tidydataset, file = "/Users/m039688/Desktop/R_Class/Week_4/tidydata.txt", row.names = FALSE)
```