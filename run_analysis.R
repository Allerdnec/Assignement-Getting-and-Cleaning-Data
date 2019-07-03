#### Project purpose ####

# Within the framework of the "Getting and cleaning data" course on coursera,
# the purpose of this project is to demonstrate my ability to collect, 
# work with, and clean a data set.

# A full description of the dataset is available at the site where 
# the data was obtained:

#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# This script is meant to be read with the "CodeBook.md" file and will do 
# the following:

# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for 
# each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

#### Libraries ####

# Here are listed all the libraries which will be used in this script
library(plyr)
library(tidyr)
library(data.table)
library(dplyr)

#### Load the data ####

# Let's first load the data available at:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# 1/ create a directory called "data" (idf it does not exist already)
if(!file.exists("./data")){dir.create("./data")}

# 2/ Load the URL
fileUrl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# 3/ download the .zip file and call it "samsung.dataset.zip"
download.file(fileUrl, destfile="./data/samsung_dataset.zip", method = "curl")

# 4/ unzip the zip file "samsung.dataset.zip"
unzip("./data/samsung_dataset.zip", exdir = "./data")

# The zip file contains two datasets "train" and "test" each of them composed of 
# several text files
# basically each datasets "train" and "test" have a set of measures (X), a set 
# of labels (Y) and a text file with the "subject_test" identifiers. Each 
# datasets also have more measures called "Inertial Signals" but we do not need
# them here.
# Please refer to the "CodeBook.md" file for more informations

#### Task 1: Merge the training and the test sets to create one data set ####

# 1/ Load the common data for test and train : 
# read the features.txt file and activity_labels.txt
features <- fread("./data/UCI HAR Dataset/features.txt")
activity_labels <- fread("./data/UCI HAR Dataset/activity_labels.txt")

# 2/ Renaming the column names so they are better to read
colnames(features) <- c("feature_ID", "feature_name")
colnames(activity_labels) <- c("activity_ID", "activity_name")

#Test data
###

# 3/ Read all the datasets for "test"
# List all the text files in the test folder (I am NOT considering the folder 
# "Inertial Signals" here)
filelist <- list.files(path = "./data/UCI HAR Dataset/test", pattern = "*.txt",
                       full.names=TRUE)

# Read all the files
testlist <- lapply(filelist, function(x)fread(x))

# 4/ Name the different elements of the list
test_names <- c("subject_ID", "feature_value", "activity_ID")
names(testlist) <- test_names
names(testlist[["subject_ID"]]) <- "subject_ID"
names(testlist[["activity_ID"]]) <- "activity_ID"
names(testlist[["feature_value"]]) <- features$feature_name

# 5/ Merge the test data
test <- setDT(as.data.frame.list(testlist))


# Training data
###

# 6/ Now I need to do the same with the train dataset
# The steps will be the same

# Load all the datasets for "train"
# List all the text files in the train folder (I am NOT considering the folder 
# "Inertial Signals" here)
filelist <- list.files(path = "./data/UCI HAR Dataset/train", pattern = "*.txt",
                       full.names=TRUE)

# Read all those files
trainlist <- lapply(filelist, function(x)fread(x))

# Name the different lists
train_names <- c("subject_ID", "feature_value", "activity_ID")
names(trainlist) <- train_names
names(trainlist[["subject_ID"]]) <- "subject_ID"
names(trainlist[["activity_ID"]]) <- "activity_ID"
names(trainlist[["feature_value"]]) <- features$feature_name

# Merge the test data
train <- setDT(as.data.frame.list(trainlist))

# 7/ Create a new variable "data_origin"
# I want to keep track of the origin of the data (from test or train) so for 
# each of the dataset, I will add a column named "data_origin" 
test <- mutate(test, data_origin = "test")
train <- mutate(train, data_origin = "train") 

# 8/ Merge the test and train dataset to have only one datase
test_train <- rbind(test, train)

# 9/ testing the dataset
count(test_train, subject_ID) # there is the right number of subject_ID (30)
count(test_train, data_origin) # there is the right number of test (2947) and train (7352)
count(test_train, activity_ID) # there is the right number of activity_ID (6)

#### Task 2 :Extract mean and standard deviation ####

# 1/ First I rename all the variables
colname_data <- c("subject_ID", features$feature_name, "activity_ID")
colnames(test_train) <- colname_data

# 2 / From the features data table I select only the ones containing mean or std
# and I save it in meanstd_features
meanstd_features <- filter(features, grepl("(mean|std)", features$feature_name, 
                                           ignore.case = T))
meanstd <- c("subject_ID", "activity_ID", 
             meanstd_features$feature_name)

# 3/ select the meanstd columns from test_train and save the table in 
# "test_train_subset"
test_train_subset <- test_train[, meanstd]


#### Task 3:Use descriptive activity names ####

# 1/ inner_join() function to matches the activity_ID in the dataset to the
# activity_name 

test_train_subset <- inner_join(test_train_subset, activity_labels, 
                                by = "activity_ID")

# 2/ Reorganising the columns and selecting 
test_train_subset <- select(test_train_subset, subject_ID, 
                            activity_name, 3:89)

#### Task 4: Label the data set with descriptive variable names ####

# All my variables already have a descriptive name.

#### Task 5: Second tidy dataset ####
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

# 1/ I will first group the data and summarize it to get the final table
test_train_final <-
test_train_subset %>% 
        group_by(activity_name, subject_ID) %>% 
        summarise_all(list(mean))

write.table(test_train_final, file = "samsung_testtrain.txt", sep = "\t", 
            row.names = F)


## code to read the data back into R
# library(data.table)
#fread("samsung_testtrain.txt")



