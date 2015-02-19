# Getting and Cleaning Data - Course Project
Nancy Chang

=====================
##Course Project:
    
1. The original data "Human Activity Recognition Using Smartphones Dataset" is from the course website represent data collected from the accelerometers of the Samsung Galaxy S smartphone.

2. The goal is to prepare a tidy data which average each variable for each activity and each subject. The variables include 79 items listed in column names from column 3 to 81. The "subjects" listed in column 1 are a group of 30 volunteers within an age bracket of 19-48 years and listed in 1 to 30. The "activities" contain with walking, walking upstairs, walking downstairs, sitting, standing and laying respectively. 

3. The finalized tidy data called "DataSummary", it lists the subject 1 to 30, with 6 activities (column 2), about the average of their 79 kinds of movement variables (column 3 to 81).

4. The code named "run_analysis.R" is used to transform the original dataset called "UCI HAR Dataset" to make the tidy dataset "DataSummary.txt".