#setwd("C:/Users/Ali TIMITE/Downloads/data science/exam") // this was my destination directory

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip")

# Unzip dataSet to /exam directory
unzip(zipfile="Dataset.zip",exdir="./exam")


# Reading trainings tables:
x_train <- read.table("./exam/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./exam/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./exam/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./exam/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./exam/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./exam/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./exam/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./exam/UCI HAR Dataset/activity_labels.txt')


# assinging column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activityLabels) <- c('activityId','activityType')

# merging all data in one set

merged_train <- cbind(y_train, subject_train, x_train)
merged_test <- cbind(y_test, subject_test, x_test)
merged_data <- rbind(merged_train, merged_test)

# reading column names
colNames <- colnames(merged_data)

# create vector for defining ID, mean and standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )

# making necessary subset from setAllInOne
mean_std_merged <- merged_data[ , mean_and_std == TRUE]

# Using descriptive activity names to name the activities in the data set
AllinOne <- merge(mean_std_merged, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# create second independant tidy data set

final_Tidy_data <- aggregate(. ~subjectId + activityId, AllinOne, mean)
final_Tidy_data <- secTidySet[order(final_Tidy_data$subjectId, final_Tidy_data$activityId),]
