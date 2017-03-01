## Install reshapre 2 and load 

install.packages("reshape2")
library(reshape2)

name <- "data.zip"

## Download the file

if (!file.exists(filename)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(URL, name, method="curl")
}  

## Unzip the file 

if (!file.exists("UCI HAR Dataset")) { 
  unzip(name) 
}

# Load activity labels and features

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Result of mean and standard deviation
feature <- grep(".*mean.*|.*std.*", features[,2])
feature.names <- features[features,2]
feature.names = gsub('-mean', 'Mean', feature.names)
feature.names = gsub('-std', 'Std', feature.names)
feature.names <- gsub('[-()]', '', feature.names)


# Load the dataset

train <- read.table("UCI HAR Dataset/train/X_train.txt")[features]
trainActivity <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubject, trainActivity, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[features]
testActivity <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubject, testActivity, test)

# Merge datasets and add labels

MergeData <- rbind(train, test)
colnames(MergeData) <- c("subject", "activity", features.names)

# From activities and subjects to factors

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

# write table

write.table(allData.mean, "final.txt", row.names = FALSE, quote = FALSE)
