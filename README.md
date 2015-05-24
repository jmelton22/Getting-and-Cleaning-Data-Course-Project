==================================================================
Coursera Getting and Cleaning Data Course Project
jmelton22
==================================================================

This script takes the Human Activity Recognition Using Smartphones 
Dataset containing measurements from smartphone accelerometers and
gyroscopes of 30 volunteers performing 6 activities (walking,
walking_upstairs, walking_downstairs, sitting, standing, laying)
(see UCI HAR Dataset for more details). Within both the test and 
training data, the subject_ids, activity_labels, and measurements 
are merged into single datasets. The test and training datasets 
are then merged into a single large dataset. The script applies 
descriptive names for each variable in the dataset. See 
'codebook.md' for more details.

From the merged dataset, the variables measuring the means and standard deviations of measurements from the Human Activity Recognition Using Smartphones Dataset are subsetted out from the main dataset. The data are then split by subject_id and activity_label.The averages of each variable from each subject and activity are calculated, and a new dataset is generated containing one measurement of the average of each variable for every subject and activity.

This dataset includes the following files:
==================================================================
- "README.md"

- 'codebook.md'

- 'run_analysis.R'
