library(data.table);

#Download and extract the zip file and place in the correct path.

features <- read.csv('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/features.txt', header = FALSE, sep = ' ');
features <- as.character(features[,2]);

#Read the training data sets.
trainData.x <- read.table('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/train/X_train.txt');
trainData.activity <- read.csv('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ');
trainData.subject <- read.csv('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ');
#Combine the 3 training data sets and create 1.
trainData <-  data.frame(trainData.subject, trainData.activity, trainData.x);
#Assign the labels.
names(trainData) <- c(c('subject', 'activity'), features);

#head(trainData);
#dim(trainData);

#Read the test data sets.
testData.x <- read.table('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/test/X_test.txt');
testData.activity <- read.csv('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ');
testData.subject <- read.csv('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ');
#Combine the 3 test data sets and create 1.
testData <-  data.frame(testData.subject, testData.activity, testData.x);
#Assign the labels.
names(testData) <- c(c('subject', 'activity'), features);

#dim(testData);

#names(testData);

#Combine and create the full data set.
dataFull <- rbind(trainData, testData);

#2. Extract only the measurements on the mean and standard deviation for each measurement.

meanStdData <- grep('mean|std', features);
dataSubSelect <- dataFull[,c(1,2,meanStdData + 2)];

#3. 3. Uses descriptive activity names to name the activities in the data set.

actLabels <- read.table('C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/UCI HAR Dataset/activity_labels.txt', header = FALSE);
actLabels <- as.character(actLabels[,2]);
dataSubSelect$activity <- actLabels[dataSubSelect$activity];

#4. 4. Appropriately labels the data set with descriptive variable names.

nameLabels <- names(dataSubSelect);
nameLabels <- gsub("[(][)]", "", nameLabels);
nameLabels <- gsub("^t", "TimeDomain_", nameLabels);
nameLabels <- gsub("^f", "FrequencyDomain_", nameLabels);
nameLabels <- gsub("Acc", "Accelerometer", nameLabels);
nameLabels <- gsub("Gyro", "Gyroscope", nameLabels);
nameLabels <- gsub("Mag", "Magnitude", nameLabels);
nameLabels <- gsub("-mean-", "_Mean_", nameLabels);
nameLabels <- gsub("-std-", "_StandardDeviation_", nameLabels);
nameLabels <- gsub("-", "_", nameLabels);
names(dataSubSelect) <- nameLabels;

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

myTidyData <- aggregate(dataSubSelect[,3:81], by = list(activity = dataSubSelect$activity, subject = dataSubSelect$subject),FUN = mean);
write.table(x = myTidyData, file = "C:/Users/Avisek/Documents/JHU Data Science Specialisation/Getting and Cleaning Data/Week 4/my_data_tidy.txt", row.names = FALSE);


