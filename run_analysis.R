# files were downloaded and relevant files were extrafted to the data folder

trainraw <- read.table("./data/X_train.txt") # getting the training data
features <- read.table("./data/features.txt") # getting the features
colnames(features) <- c("obsid","feature") # changing the name of the columns in features
colnames(trainraw) <- features$feature # assigning the training data with correct column names
trainlabels <- read.table("./data/y_train.txt") # getting the activity information
colnames(trainlabels) <- "activity" # changing the name of the column of acitivty
trainsubjects <- read.table("./data/subject_train.txt") # getting the subject data
colnames(trainsubjects) <- "subject"  # changing the name of the column of the subject data
trainup <- cbind(trainsubjects, trainlabels,trainraw) # combining and updated the training data


testraw <- read.table("./data/X_test.txt") # getting the test data
colnames(testraw) <- features$feature # assigning the test data with correct column names
testlabels <- read.table("./data/y_test.txt") # getting the activity information
colnames(testlabels) <- "activity" # changing the name of the column of acitivty
testsubjects <- read.table("./data/subject_test.txt") # getting the subject data
colnames(testsubjects) <- "subject" # changing the name of the column of the subject data
testup <- cbind(testsubjects,testlabels, testraw) # combining and updated the test data

data.all <- rbind(trainup, testup) # combining updated test and training data

# 2 

updated.data <- data.all [ ,c("subject","activity", grep("mean|std", colnames(data.all),value = TRUE))] # selecting the columns from data.all that full fill the criteria. 

# 3
actlabels <- read.table("./data/activity_labels.txt",header = FALSE) # getting the activity names
updated.data$activity <- actlabels[updated.data$activity,2] # using the activiy desciption to update the activity column

#4
# improvong the readability of the columns
desciptive_names <- names(updated.data)
desciptive_names <- gsub("[(][)]", "", desciptive_names)
desciptive_names <- gsub("^t", "TimeDomain_", desciptive_names)
desciptive_names <- gsub("^f", "FrequencyDomain_", desciptive_names)
desciptive_names <- gsub("Acc", "Accelerometer", desciptive_names)
desciptive_names <- gsub("Gyro", "Gyroscope", desciptive_names)
desciptive_names <- gsub("Mag", "Magnitude", desciptive_names)
desciptive_names <- gsub("-mean-", "_Mean_", desciptive_names)
desciptive_names <- gsub("-std-", "_StandardDeviation_", desciptive_names)
desciptive_names <- gsub("_std", "_StandardDeviation_", desciptive_names)
desciptive_names <- gsub("BodyBody", "Body", desciptive_names)
desciptive_names <- gsub("-", "_", desciptive_names)
names(updated.data) <- desciptive_names 

#5
library(dplyr)
final_data <- updated.data %>% group_by(subject, activity) %>% summarise_all(funs(mean)) # summarizing data based on groups and mean function
write.table(final_data, file= "final_data.txt", row.names = FALSE) # creating a table to store the final output

