##Set working directory
setwd("C:/Users/zachary.lifman/Documents/Coursera Getting and Cleaning Data Project")
getwd()

##Download data
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

##download features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

##download test data
XTest<- read.table("UCI HAR Dataset/test/X_test.txt")
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")

##download training data
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")

##merge the training and test sets to create one data set
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)

##take only measurements on mean and standard deviation from features
featuresMeanStd<-grep("mean\\(\\)|std\\(\\)", features[,2])
X<-X[,featuresMeanStd]

##replace numeric values in Y with a lookup value from activity
Y[,1]<-activity[Y[,1],2]
head(Y)

##get names for variables
names<-features[featuresMeanStd,2]
##update column names for new dataset
names(X)<-names
names(Subject)<-"SubjectID"
names(Y)<-"Activity"

CleanData<-cbind(Subject,Y,X)
head(CleanData[,c(1:4)])

##create an independent tidy data set with the average of each variable for each activiy and each subject
CleanData<-data.table(CleanData)
Tidy<-CleanData[,lapply(.SD,mean),by = 'SubjectID,Activity']
dim(Tidy)

write.table(Tidy,file = "Tidy.txt",row.names=FALSE)
head(Tidy[order(SubjectID)][,c(1:4), with = FALSE],12) 