# Read the feature data sets from files
features_test <- read.table("UCI HAR Dataset/test/X_test.txt")
features_train <- read.table("UCI HAR Dataset/train/X_train.txt")

# Read the feature names and assign them to both datasets
feature_names <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE, strip.white=TRUE)
colnames(features_test) = feature_names[,2]
colnames(features_train) = feature_names[,2]

# Grab only those columns that contain "std" or "mean" inside their name
features_test <- features_test[ , grepl( "std" , names( features_test )) | grepl( "mean" , names( features_test )) ]
features_train <- features_train[ , grepl( "std" , names( features_train )) | grepl( "mean" , names( features_train )) ]

# Read activity labels 
feature_names <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE, strip.white=TRUE, col.names = c("ID", "Activity"))

# Read labels and subjects and then bbind all tables together
labels_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity_Label")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
labels_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity_Label")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")


test_dataset <- cbind(subject_test, features_test, labels_test)
train_dataset <- cbind(subject_train, features_train, labels_train)

# Bind test and train together
dataset <- rbind(test_dataset, train_dataset)
# Merge with Activity names
dataset <- merge(dataset, feature_names, by.x="Activity_Label", by.y = "ID")
# Remove activity number as we opt for label only
dataset <- dataset[,2:82]

# Reshape the data for step 5
require(reshape2)
final_dataset <- recast(dataset, Subject+Activity ~ variable, mean, id.var = c("Subject", "Activity"))
# Write the data set
write.table(final_dataset, file ="output.txt", row.names = FALSE)