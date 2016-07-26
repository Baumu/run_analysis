## ASSIGNMENT GETTING AND CLEANING DATA
## 1 Merge datasets

setwd("T:/dpv/Holding/Strategische Marktanalyse/Studien & Hintergrundwissen/Imme Privat/Data Science_Coursera/Getting and Cleaning Data/Final Assignment")
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

colnames(train_x) <- features[,2]
colnames(train_y) <- "activity_ID"
colnames(subject_train) <- "subject_ID"
colnames(test_x) <- features[,2]
colnames(test_y) <- "activity_ID"
colnames(subject_test) <- "subject_ID"


data_test <- cbind(test_x, test_y, subject_test)
data_train <- cbind(train_x, train_y, subject_train)

data <- rbind(data_test, data_train)
head(data)

write.table(data, "data.txt", row.names = FALSE)

## 2 Extract only the measurements on the mean and standard deviation for each measurment.
colnames <- colnames(data)

data_short <- data[grepl("mean..", colnames) | grepl("std..", colnames) | grepl("subject_ID", colnames) | grepl("activity_ID", colnames)]
colnames(data_short)


## 3 Use descriptive activity names to name the activities in the data set. 
data_short$activity_ID <- as.character(data_short$activity_ID)
data_short$activity_ID[data_short$activity_ID == 1] <- "Walking"
data_short$activity_ID[data_short$activity_ID == 2] <- "Walking Upstairs"
data_short$activity_ID[data_short$activity_ID == 3] <- "Walking Downstairs"
data_short$activity_ID[data_short$activity_ID == 4] <- "Sitting"
data_short$activity_ID[data_short$activity_ID == 5] <- "Standing"
data_short$activity_ID[data_short$activity_ID == 6] <- "Laying"
data_short$activity_ID <- as.factor(data_short$activity_ID)

colnames(data_short)

## 4 Approbiately label the data set with descriptive variable names.
colnames(data_short) <- gsub("Acc", "Acceleration", colnames(data_short))
colnames(data_short) <- gsub("Gyro", "Gyroscope", colnames(data_short))
colnames(data_short) <- gsub("^t", "times", colnames(data_short))
colnames(data_short) <- gsub("Mag", "Magnitude", colnames(data_short))
colnames(data_short) <- gsub("^f", "frequency", colnames(data_short))
colnames(data_short)


## 5 Create a second, independent tidy data set with the average of each variabel for each activity and each subject.
data_tidy <- aggregate(. ~ subject_ID + activity_ID, data_short, mean)
data_tidy <- data_tidy[order(data_tidy$subject_ID, data_tidy$activity_ID)]

write.table(data_tidy, "tidy.txt", row.names = FALSE)


