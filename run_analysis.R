#download zip file and unzip the files into working directory
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
list.files(unzip(temp,exdir=".",overwrite=TRUE))
unlink(temp)

install.packages("data.table")
library(data.table)
features <- read.table("./UCI HAR Dataset/features.txt", sep="\t", stringsAsFactors=FALSE)
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="\t", stringsAsFactors=FALSE)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", sep="\t", stringsAsFactors=FALSE)
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="\t", stringsAsFactors=FALSE)

train_set <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="\t", stringsAsFactors=FALSE)
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", sep="\t", stringsAsFactors=FALSE)
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="\t", stringsAsFactors=FALSE)

#step1: Merges the training and the test sets to create one data_set
data_set<- rbind(train_set, test_set)
data_label<- rbind(train_labels, test_labels)
data_subject<- rbind(train_subject, test_subject)

featureName <- grep("mean|std", features$V1, value=TRUE)
feature_no <- as.matrix(as.numeric(gsub("([0-9]+).*$", "\\1",featureName)))
feature_name <- as.matrix(gsub("[0-9]+ ", "",featureName))
feature_name <- sub("(\\(\\))","", feature_name)

#step 2: The inner loop is to extract only the measurements on the mean and standard 
#        deviation for each measurement.
#step 3: The outer loop is to extract the descriptive activity names to name the 
#        activities in the data set, and store the data set into a table called dt. 
dataset <- function(x){
    Num <- length(feature_no[,1])
    dt <- data.table()
    for(i in 1:length(x[,1])){
        table_r <-c()
        at<- as.numeric(unlist(strsplit(as.character(x[i,1]),".. ")))    
        
        for (i in 1:Num){
            ii <- feature_no[i] 
            table_r <- c(table_r,at[ii])
        }
        
        row <- data.frame(matrix(table_r, nrow=1, ncol=79))
        dt <- rbind(dt, row)        
    }        
    dt <- setattr(dt, 'names', feature_name)
    #write in temp file
    write.csv(dt, temp, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
    #return(dt)
}
dataset(data_set)
dt <- read.table(temp, sep=",", header=TRUE)

#step 4: Appropriately labels the data set with descriptive variable names, 
#        and called it bigData
data_col <- cbind(data_subject, data_label)
colnames(data_col)<- c("subject", "activity")
bigData <- data.table(cbind(data_col, dt))

#step 5:  creates a second, independent tidy data set with the average of each variable 
#         for each activity and each subject, and store as txt file named DataSummary
Data_summary <- bigData[,lapply(.SD, mean), by = c("subject", "activity")]
DataSummary <- Data_summary[order(subject, activity)]
write.table(DataSummary, file="E:/2014_Study/4_Getting and Cleaning Data/Course Project/DataSummary.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

