# run_analysis.R

# This R script does the following:

# Merges the training and the test sets in the UCI HAR Dataset to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# Writes the tidy data set out to a file

######################################################################
# Load the activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("activityId", "activity")

# Load the test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")


# Add the feature names as the column names
features <- read.table("UCI HAR Dataset/features.txt")
colnames(x_test) <- features[,2]


# Get the Indexes of the mean and std deviation for each measurement
desiredColumnIndexes <- grep("mean\\(|std\\(", features$V2)

# Subset the data to get just the desired Columns
x_test <- x_test[,desiredColumnIndexes]

# Add the activity labels to the test data as a new column and set the column name
colnames(y_test)[1] <- "activityId"
testData <- cbind(x_test, y_test)

# Add the subject IDs to the dataset and set the column name
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(testSubjects)[1] <- "subjectID"
testData <- cbind(testSubjects, testData)

# Add a "test" label (column) to the test data set
testData <- cbind(rep("test", nrow(testData)), testData)
colnames(testData)[1] <- "dataset"

# Join the activity labels and subject identifiers to the data set
testData <- merge(x = activities, y = testData, by.x="activityId", by.y="activityId", all.y = TRUE, sort=FALSE)

# Remove the first column (contains the activityId, which we no longer need)
testData <- testData[,-1]

#head(testData, n=5)

###################################################################################################
# Load the train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")


# Add the feature names as the column names
features <- read.table("UCI HAR Dataset/features.txt")
colnames(x_train) <- features[,2]


# Get the Indexes of the mean and std deviation for each measurement
desiredColumnIndexes <- grep("mean\\(|std\\(", features$V2)

# Subset the data to get just the desired Columns
x_train <- x_train[,desiredColumnIndexes]

# Add the activity labels to the test data as a new column and set the column name
colnames(y_train)[1] <- "activityId"
trainData <- cbind(x_train, y_train)

# Add the subject IDs to the dataset and set the column name
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(trainSubjects)[1] <- "subjectID"
trainData <- cbind(trainSubjects, trainData)

# Add a "test" label (column) to the test data set
trainData <- cbind(rep("train", nrow(trainData)), trainData)
colnames(trainData)[1] <- "dataset"

# Join the activity labels and subject identifiers to the data set
trainData <- merge(x = activities, y = trainData, by.x="activityId", by.y="activityId", all.y = TRUE, sort=FALSE)

# Remove the first column (contains the activityId, which we no longer need)
trainData <- trainData[,-1]


###################################################################################################
# Merge the two data sets
mergedData <- rbind(trainData, testData)
head(mergedData, n=5)
tail(mergedData, n=5)

##################################################################################################
# Build the separate dataset for the last step

# Create an empty data frame
outputDataFrame <- data.frame()
# For each unique activity...
uniqueActivities <- unique(mergedData$activity)
for (n in 1:length(uniqueActivities)) {
     # Subset the dataset based on the activity...
     # For each unique subject...
     uniqueSubjects <- unique(mergedData$subjectID)
     for (nn in 1:length(uniqueSubjects)) {
          # Subset the dataset for this activity and subject
          activitySubset <- mergedData[mergedData$activity == uniqueActivities[n],]
          subjectActivitySubset <- activitySubset[activitySubset$subjectID == uniqueSubjects[nn],]
          measurementSubset <- subjectActivitySubset[,4:ncol(subjectActivitySubset)]
          # Calculate the average for each variable
          averages <- apply(measurementSubset,2, mean)
          # Write the activity name, subject id, and average for each variable, to a data frame
          thisFrame <- data.frame(subject=uniqueSubjects[nn], activity=uniqueActivities[n], measurement=names(averages), average_value=unname(averages))
          outputDataFrame <- rbind(outputDataFrame, thisFrame)
     }
}

# Order the data frame by subject, activity, measurement
library(plyr)
outputDataFrame <- arrange(outputDataFrame, subject, activity, measurement)

# Write the output
write.table(outputDataFrame, file="UCI HAR Dataset/tidyData.txt", sep="\t")

