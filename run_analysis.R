#Follow the following steps to achieve a complete dataset, based on the fact that you already have teh files on your harddrive. For a link to the files, see the Readme.
#First, read datasets into R dataframes, change directory if necessary
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Second, merge the related dataframes
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

#Third, provide names for the according columns
cheader.dat <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
head <- as.character(cheader.dat[,2])
names(x) <- head
names(y) <- c("Activity")
names(subject) <- c("Subject")

#Fourth, one set to rule them all, the final merge
final.dat <- cbind(x, y, subject)

#Five, label activities accordingly to identify them
library(plyr)
activitiesIds <- final.dat[,"Activity"]
activitiesFactors <- as.factor(activitiesIds)
activitiesFactors = revalue(activitiesFactors, c("1"="WALKING", "2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS", "4"="SITTING", "5"="STANDING", "6"="LAYING"))
final.dat[,"Activity"] = activitiesFactors

#Now, clean up your mess by removing all superfluos data
rm(x, y, subject, x_train, y_train, subject_train, x_test, y_test, subject_test, cheader.dat)

#Now that the dataset is complete, it is time to work on the given task

#First, search the measurements on the mean and standard deviation
mean_std_names <- names(final.dat[,grep("mean|std", names(final.dat))])

#Second, extract only measurements on the mean and standard deviation for each measurement. 
mean_std_measures <- final.dat[,mean_std_names]

#Third, create a tidy dataset with the average of each variable for each activity and subject
tidydata <- aggregate(mean_std_measures, by = list(final.dat$Activity,final.dat$Subject),mean)

#..and name the column appropriately
names(tidydata) <- c("Activity","Subject",names(mean_std_measures))

#Fourth, export the tidy data to a text file and add a comma seperator to make imports easier.
write.table(tidydata, file = "UCI_tidy_dataset.txt", sep = ",", row.names = FALSE)
#..and export the merged dataset to a file
write.csv(final.dat, file = "UCI_Merged_dataset.csv", row.names = FALSE)
