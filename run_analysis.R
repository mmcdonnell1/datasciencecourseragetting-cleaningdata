## This code merges data sets related to accelerometers from the Samsung Galaxy S smartphone,
## extracts select measurements, applies descriptive activity names, labels the data, and
## creates a tidy data set.

## 1. Merge the training and the test sets to create one data set.

  ## Load training and test datasets
  
  X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  
  ## Load feature labels and activity labels
  
  features <- read.table("./UCI HAR Dataset/features.txt")
  activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
  
  ## Combine training and test datasets
  
  X <- rbind(X_train, X_test)
  y <- rbind(y_train, y_test)
  subject <- rbind(subject_train, subject_test)

  ## Add column names to the subject ids, activity ids, activity labels,
  ## and the features data
  
  colnames(subject) <- c("subject_id")
  colnames(y) <- c("activity_id")
  colnames(activity_labels) <- c("activity_id", "activity_labels")
  colnames(X) <- features[, 2]
  
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

  ## Extract the columns related to mean and std features

  XInclude <- X[, grep("mean[()]|std[()]",features[,2])]

## 3. Uses descriptive activity names to name the activities in the data set

  ## Append the subject ids to the features data
  
  XInclude.subject <- cbind(XInclude, subject)
  
  ## Append the activity ids to the subject ids and features data
  
  XInclude.subject.y <- cbind(XInclude.subject, y)

  ## Match each activity id with the appropriate activity label

  XInclude.subject.y.ActNames <- merge(XInclude.subject.y, activity_labels, 
                                       by.x = "activity_id", by.y= "activity_id")

## 4. Appropriately labels the data set with descriptive variable names.
  
  ## Extract the feature rows related to mean and std features

  featuresInclude <- features[grep("mean[()]|std[()]",features[,2]), ]

  ## Create space between label descriptors using underscores

  featuresInclude$V3 <- gsub("Body", "_Body_", featuresInclude[,2])
  featuresInclude$V3 <- gsub("Gravity", "_Gravity_", featuresInclude[,3])
  featuresInclude$V3 <- gsub("Jerk", "_Jerk", featuresInclude[,3])
  featuresInclude$V3 <- gsub("Mag", "_Magnitude", featuresInclude[,3])

  ## Convert -X, -Y, and -Z to include "Axis" reference

  featuresInclude$V3 <- gsub("-X", "_X_Axis", featuresInclude[,3])
  featuresInclude$V3 <- gsub("-Y", "_Y_Axis", featuresInclude[,3])
  featuresInclude$V3 <- gsub("-Z", "_Z_Axis", featuresInclude[,3])

  ## Convert "time" and "frequency" indicators to complete values

  featuresInclude$V3 <- gsub("t_", "Time_", featuresInclude[,3])
  featuresInclude$V3 <- gsub("f_", "Frequency_", featuresInclude[,3])

  ## Repalce R-unfriendly characters (i.e. "-" and "()") and clean-up incorrect names

  featuresInclude$V3 <- gsub("-", "_", featuresInclude[,3])
  featuresInclude$V3 <- gsub("\\()", "", featuresInclude[,3])
  featuresInclude$V3 <- gsub("__Body", "", featuresInclude[,3])

  ## Convert variable names to lower case

  featuresInclude$V3 <- tolower(featuresInclude[,3])
  
  ## Apply new tidy variable names
  
  colnames(XInclude.subject.y.ActNames) <- c("activity_id", featuresInclude[,3], "subject_id", "activity_labels")
  
## 5. Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject.

  ## Install the plyr package to leverage ddply

  install.packages("plyr")
  library(plyr)

  ## Calculate column averages for each subject and activity

  XInclude.colMeans.by.Subject.Activity <- ddply(XInclude.subject.y.ActNames,
                                                 .(subject_id, activity_id, activity_labels),
                                                 colwise(mean))
  ## Create tidy data set
  
  TidyData <- cbind(XInclude.colMeans.by.Subject.Activity[,1:3],
                    format(round(XInclude.colMeans.by.Subject.Activity[,4:69], 4),
                           nsmall = 2))