##############################################################
# Class Project for Coursera "Getting and Cleaning Data" class
##############################################################

#
# read metadata
#
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c('activity_id', 'activity'))

features <- read.table("UCI HAR Dataset/features.txt", col.names = c('colno', 'feature'))

##############################################################
#
# Step 1: read training data, keeping only columns containing
# mean() and std() in the column name.
#
subj <- read.table("UCI HAR Dataset/train/subject_train.txt", 
		col.names='subject')

x_full <- read.table("UCI HAR Dataset/train/X_train.txt",
		col.names=features$feature)

x_mean <- subset(x_full, select = grepl(".*mean\\(\\).*", features$feature))
x_std <- subset(x_full, select = grepl(".*std\\(\\).*", features$feature))

y <- read.table("UCI HAR Dataset/train/y_train.txt",
		col.names='activity_id')

dataset_training <- cbind(subj, x_mean, x_std, y)

##############################################################
#
# Step 2: read test data, keeping only columns containing
# mean() and std() in the column name.
#
subj <- read.table("UCI HAR Dataset/test/subject_test.txt", 
		col.names='subject')

x_full <- read.table("UCI HAR Dataset/test/X_test.txt",
		col.names=features$feature)

x_mean <- subset(x_full, select = grepl(".*mean\\(\\).*", features$feature))
x_std <- subset(x_full, select = grepl(".*std\\(\\).*", features$feature))

y <- read.table("UCI HAR Dataset/test/y_test.txt",
		col.names='activity_id')

dataset_testing <- cbind(subj, x_mean, x_std, y)

##############################################################
#
# Step 3: concatenate datasets.
#
dataset <- rbind(dataset_training, dataset_testing)

##############################################################
#
# Step 4: compute average values, grouped by subject and activity id
#
dataset <- aggregate(dataset, by=list(dataset$subject, dataset$activity_id), FUN=mean, simplify=TRUE)

##############################################################
#
# Step 5: now create graphs
#
library(png)

png("BodyAcc.png")
with(dataset, {
   boxplot(tBodyAccMag.mean.. ~ activity_id, xlab="Activity", ylab="Acceleration")
   legend("topright", legend=c('1 - Walking', '2 - Upstairs', '3 - Downstairs', '4 - Sitting', '5 - Standing', '6 - Resting'))
})
dev.off()

