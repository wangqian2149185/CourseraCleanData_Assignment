# download file
if(!file.exists("/Users/QianWang/Documents/Coursera_cleanData")) dir.create("/Users/QianWang/Documents/Coursera_cleanData")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "/Users/QianWang/Documents/Coursera_cleanData/projectData_getCleanData.zip")
listZip <- unzip("/Users/QianWang/Documents/Coursera_cleanData/projectData_getCleanData.zip", exdir = "./data")

# load data
test_sub <- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/test/subject_test.txt")
test_X <- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/test/y_test.txt")

train_sub <- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/train/subject_train.txt")
train_X <- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/train/y_train.txt")

# merge data (requirment 1)
train <- cbind(train_sub,train_y, train_X )
test <- cbind(test_sub, test_y, test_X)
data <- rbind(train, test)
colnames(data) <- c("subject","activity")

features<- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
features<- features[,2]

# choose the features with std or mean
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), features)
dataset <- data[,c(1,2,featureIndex+2)]
colnames(dataset) <- c("subject","activity",features[featureIndex])

# activity descriptive naming
activityName <- read.table("/Users/QianWang/Documents/Coursera_cleanData/UCI HAR Dataset/activity_labels.txt")
dataset$activity <- factor(dataset$activity,levels = activityName[,1], labels = activityName[,2])

# approprately name variables
names(dataset) <- gsub("^t", "time", names(dataset))
names(dataset) <- gsub("\\()", "", names(dataset))
names(dataset) <- gsub("^f", "frequence", names(dataset))
names(dataset) <- gsub("-mean", "Mean", names(dataset))
names(dataset) <- gsub("-std", "Std", names(dataset))

# average for each subject and activty
library(lubridate)
library(dplyr)
secondData <- dataset %>%
  group_by(subject, activity) %>%
  summarize_each(funs(mean))





