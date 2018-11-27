#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.

#1 -Merges the training and the test sets to create one data set.
#2 -Extracts only the measurements on the mean and standard deviation for each measurement.
#3 -Uses descriptive activity names to name the activities in the data set
#4 -Appropriately labels the data set with descriptive variable names.
#5 -From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


setwd("~/Ayoub/COURSERA/UCI HAR Dataset")
#reading labels
activity_labels <- read.table("./activity_labels.txt")
colnames(activity_labels)<-c("Id","Activity")
#reading features
features <- read.table("./features.txt",sep="")

#reading the data general and training.
#reading trainnig set
subject_train    <-read.table("./train/subject_train.txt", header=FALSE)
X_train          <- read.table("./train/X_train.txt", header=FALSE)
Y_train          <- read.table("./train/y_train.txt", header=FALSE)
#reading test set
subject_test    <-read.table("./test/subject_test.txt", header=FALSE)
X_test          <- read.table("./test/X_test.txt", header=FALSE)
Y_test          <- read.table("./test/y_test.txt", header=FALSE)


#to merge training Data.
train_Data <- cbind(subject_train,Y_train,X_train)

#to merge test Data.
test_Data <- cbind(subject_test,Y_test,X_test)

#1 - Merges the training and the test sets to create one data set.
#to merge as requested trainig and test data.
dataset <- rbind(train_Data,test_Data)
#Uses descriptive activity names to name the activities in the data set

colnames(dataset)<-c("Subject","Activity",as.character(features[,2]))
  
#2 - Extracts only the measurements on the mean and standard deviation for each measuremen
#the measurements on the mean and standard deviation for each measurement
mean_std_data <-dataset[,grepl("Subject|Activity|.*mean.*|.*std.*", colnames(dataset))]


#3 - Use descriptive activity names to name the activities in the data set
mean_std_data$Activity<-factor(mean_std_data$Activity,levels=activity_labels[,1],labels=activity_labels[,2])
mean_std_data$Subject<-as.factor(mean_std_data$Subject)


#4 - Appropriately labels the data set with descriptive variable names.
data_colonne<- colnames(mean_std_data)
colnames(dataset)<-data_colonne
  
#5 - From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
mean_std_data <- dcast(melt(dataset,id=c("Subject","Activity")),Subject+Activity~variable,mean)


# writing for file "tidy_data.txt"
write.table(mean_std_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)
