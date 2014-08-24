datasciencecourseragetting-cleaningdata
=======================================

This file -- in partnership with the run_analysis.R script -- details the process followed to convert
the Samsung Galaxy S smartphone data sets into one tidy data set containing the means grouped by subject and
activity of each "mean" and "standard deviation" variable.

1.  Import, join, and label the data sets

  A. Ensure the "UCI HAR Dataset" directory is within the working directory.
  
  B. Use the read.table function to import the observations, activities, and subjects data sets and related labels.
  
  C. Join the training and test data sets for the observations, activities, and subjects.
  
  D. Add column names to the observations, activities, and subjects data sets.
  
2.  Extract the mean and standard deviation measurements

  A. Subset the observations data set by using the grep function to identify the "mean()" and "std()" variables.

3.  Join the observations, activities, and subjects data sets

  A. Use the cbind function to join the data sets into a master data set.

4.  Merge the activity labels to the master data set

  A. Use the merge function to append the correct activity label to each master data set record.

5.  Update labels to be descriptive and tidy

  A. Input underscores between each descriptive word/abbreviation.
  
  B. Convert X, Y, and Z to x_axis, y_xis, and z_axis to be more descriptive.
  
  C. Convert the t and f prefixes to "time" and "frequency" to be more descriptive.
  
  D. Replace/remove non-descriptive (e.g. "-", "()") and repetitive values.
  
  E. Convert variable names to lower case
  
  F. Add new labels to data set

6.  Create a second tidy data set with the average of each variable for each activity and each subject

  A. If not installed, install the "plyr" package and call "library(plyr).
  
  B. Use the ddply function with the colwise function to create a new data set with and calculate the averages for each variable by each activity and subject.
  
  C. Format the new data set to include the subjectid, activityid, activity_labels, and the averages to the fourth decimal place of the select variables.
