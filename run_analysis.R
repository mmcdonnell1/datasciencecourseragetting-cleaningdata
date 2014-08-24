## This code merges data sets related to accelerometers from the Samsung Galaxy S smartphone,
## extracts select measurements, applies descriptive activity names, labels the data, and
## creates a tidy data set.

## 1. Merge the training and the test sets to create one data set.

  ## Load training and test datasets
  
  X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./UCI HAR Datasettrain/y_train.txt")
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  
  ## Combine training and test datasets
  
  X <- rbind(X_train, X_test)
  y <- rbind(y_train, y_test)
  subject <- rbind(subject_train, subject_test)
  
  ## Load feature labels and activity labels
  
  features <- read.table("./UCI HAR Dataset/features.txt")
  activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## 4. Appropriately labels the data set with descriptive variable names. 

  ## Add column names to the subject ids, activity ids, activity labels,
  ## and the features data
  
  colnames(subject) <- c("subjectid")
  colnames(y) <- c("activityid")
  colnames(activity_labels) <- c("activityid", "activity_labels")
  colnames(X) <- features[, 2]
  
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

  ## Identify and select the mean and std features

  ## rm(featuresInclude) <- features[grep("mean[()]|std[()]",features[,2]),]

  ## Extract the columns related to mean and std features

  XInclude <- X[, grep("mean[()]|std[()]",features[,2])]

## 3. Uses descriptive activity names to name the activities in the data set

  ## Append the subject ids to the features data
  
  XInclude.subject <- cbind(XInclude, subject)
  
  ## Append the activity ids to the subject ids and features data
  
  XInclude.subject.y <- cbind(XInclude.subject, y)

  ## Match each activity id with the appropriate activity label
  
  XInclude.subject.y.ActNames <- merge(XInclude.subject.y, activity_labels, 
                                       by.x = "activityid", by.y= "activityid")

## 5. Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject.

  ## Install the plyr package to leverage ddply

  install.packages("plyr")
  library(plyr)

  ## Calculate column averages for each subject and activity

  XInclude.colMeans.by.Subject.Activity <- ddply(XInclude.subject.y.ActNames,
                                                 .(subjectid, activityid, activity_labels),
                                                 colwise(mean))