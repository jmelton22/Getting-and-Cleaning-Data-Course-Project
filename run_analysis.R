library("dplyr")

## Reads in the variable and activity names
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## Reads in the test data: measurements, activities, subject id's
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Reads in the training data: measurements, activities, subject id's
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

run_analysis <- function() {
        ## Converts activity labels to vector of character strings
        activity_labels <- as.character(activity_labels[,2])
        
        ## Relabels columns of test and training data with descriptive names
        colnames(subject_test) <- "subject_id"
        colnames(Y_test) <- "activity_label"
        colnames(X_test) <- features[,2]
        
        colnames(subject_train) <- "subject_id"
        colnames(Y_train) <- "activity_label"
        colnames(X_train) <- features[,2]
        
        ## Replaces activity label integer values with descriptive names
        for (i in 1:length(activity_labels)) {
                Y_test[Y_test == i] <- activity_labels[i]
        }
        for (i in 1:length(activity_labels)) {
                Y_train[Y_train == i] <- activity_labels[i]
        }
        
        ## Combines subject_id, activities, and measurements for test and training data into a single df
        test_data <- cbind(subject_test, Y_test, X_test)
        train_data <- cbind(subject_train, Y_train, X_train)
        
        merged_data <- rbind(train_data, test_data)
                merged_data$activity_label <- as.factor(merged_data$activity_label)
                merged_data$subject_id <- as.factor(merged_data$subject_id)
        
        ## Creates integer vector containing column indices that contain "mean()" and "std()"
                ## Excludes angle measures based on means, e.g. "angle(tBodyAccMean, gravity)"
        mean_indices <- grep("mean()", colnames(merged_data))
        std_indices <- grep("std()", colnames(merged_data))
        ## Adds back in subject_id and activity label column indices
        indices <- sort(c(1, 2, mean_indices, std_indices))
        
        ## Subsets out columns based on the indices vector
                ## Sorts data subset by subject_id then by activity_label
        data_subset <- merged_data[indices]
        sorted_data <- arrange(data_subset, subject_id, activity_label)
        
        ## Splits data into a list by subject_id and activity_label
        data_list <- split(sorted_data, list(sorted_data$subject_id, sorted_data$activity_label))
        
        ## Creates a matrix where each row contains the average of each variable/column
                ## Excludes subject_id and activity_label columns
        temp_matrix <- matrix(nrow = 0, ncol = 81)
        for(i in 1:length(data_list)) {
                temp <- colMeans(data_list[[i]][, -c(1,2)])
                ## Adds back in subject_id and activity_label to column means vector
                temp <- c(subject_id = data_list[[i]][1,1], activity_label = as.character(data_list[[i]][1,2]), temp)
                temp_matrix <- rbind(temp_matrix, temp); row.names(temp_matrix) = NULL
        }

        ## Converts matrix to data frame and sorts by subject_id
                ## Converts subject_id from factor to numeric for sorting
        temp_df <- as.data.frame(temp_matrix)
                temp_df$subject_id <- as.numeric(levels(temp_df$subject_id)[temp_df$subject_id])
        tidy_data <- arrange(temp_df, subject_id)
        
        return(tidy_data)
}