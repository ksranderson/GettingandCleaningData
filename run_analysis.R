
#DATA
#30 volunteers, wear Samsung Galaxy S II phone on the waist performing
#six activities -> walking, walking upstairs, walking downstairs, sitting, standing, laying
#accelerometer and gyroscope are sensors sending signal data
#Dataset random partitioned, 70%(21) generate training data, 30%(9) test data

#Records in dataset:
#1= Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration
#2= Triaxial angular velocity from the gyroscope
#3= 561-feature vector with time and frequency domain variables
#4= Activity Level
#5= An identifier of the subject who carried out the experiment

#set timeout to a longer time so file can load on poor internet web connection, almost 60MB file
options(timeout = 100)

#0 -> Get zip file and unzip revealing folder with files and subfolders
#getwd()	#get working directory where .csv file is
#setwd("C:/Users/Reuben.Anderson/OneDrive - USDA/Documents/MOOC/RProgramming/JH3rdCourse/JH3rd_Course_Project")	#set working directory
###original zip file retrieval below that suddenly stopped working but still works in browser###
#download.file(url='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 
#destfile ="SamsungData.zip")

#old way
#url <- c('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')
#destfile <- "~/MOOC/RProgramming/JH3rdCourse/JH3rd_Course_Project/SamsungData.zip"
#download.file(get('url'), destfile)
#download.file(url, destfile)
#zipF<- "C:/Users/Reuben.Anderson/OneDrive - USDA/Documents/MOOC/RProgramming/JH3rdCourse/JH3rd_Course_Project/SamsungData.zip"
#outDir<-"C:/Users/Reuben.Anderson/OneDrive - USDA/Documents/MOOC/RProgramming/JH3rdCourse/JH3rd_Course_Project/"
#unzip(zipF,exdir=outDir)

#PART 0.5 -> Clear the R environment of previous 'Values' and 'Data' to start fresh
rm(list = ls())

#new way to get at zip file and unzip
#see what working directory is, put in string, set zip file to working directory, remove spaces
wd <- getwd()
datawd <- paste(getwd(), "/SamsungData.zip")
datawd <- gsub(" ", "", datawd)
url <- c('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')
destfile <- datawd
download.file(url, destfile) #throws error on 'destfile' 'No such file or directory', try the non One Drive location using setwd()

zipF<- datawd
outDir<- wd
unzip(zipF,exdir=outDir)

#Load libraries needed:
library(dplyr)

#PART 1 -> Merges the training and the test sets to create one data set, step 1A load files into variables, step 1B merge
#1A LOAD FILES INTO VARIABLES
#Set directory to test/inertialsignals files and get all text files into dataframe variable
#set to text files
setwd("./UCI HAR Dataset/test/Inertial Signals/")

Files <- list.files( pattern = ".txt") #list of text files
for (i in 1:length(Files)) {
  temp <- paste('./',Files[i], sep = "") #file location
  assign(paste0("Variable", i), read.table(temp, sep = "" , header = F, na.strings ="", stringsAsFactors= F))
} #for loop puts all 9 variable text files into dataframe variables with name 'Variable#'

#Set directory to test/ to get 'subject', 'x', and 'y' files getting all these text files into dataframe variable
setwd("../../test/")	#set to text files
CoreTestFiles <- list.files( pattern = ".txt") #list of text files
for (i in 1:length(CoreTestFiles)) {
  temp <- paste('./',CoreTestFiles[i], sep = "") #file location
  assign(paste0("CoreTestVariable", i), read.table(temp, sep = "" , header = F, na.strings ="", stringsAsFactors= F))
} #for loop puts all 9 variable text files into dataframe variables with name 'Variable#'

#Set directory to test/inertialsignals files and get all text files into dataframe variable
setwd("../train/Inertial Signals/")	#set to text files
TrainFiles <- list.files( pattern = ".txt") #list of text files
for (i in 1:length(TrainFiles)) {
  temp <- paste('./',TrainFiles[i], sep = "") #file location
  assign(paste0("TrainVariable", i), read.table(temp, sep = "" , header = F, na.strings ="", stringsAsFactors= F))
} #for loop puts all 9 variable text files into dataframe variables with name 'Variable#'

#Set directory to train/ to get 'subject', 'x', and 'y' files getting all these text files into dataframe variable
setwd("../../train/")	#set to text files
CoreTrainFiles <- list.files( pattern = ".txt") #list of text files
for (i in 1:length(CoreTrainFiles)) {
  temp <- paste('./',CoreTrainFiles[i], sep = "") #file location
  assign(paste0("CoreTrainVariable", i), read.table(temp, sep = "" , header = F, na.strings ="", stringsAsFactors= F))
} #for loop puts all 9 variable text files into dataframe variables with name 'Variable#'

#Set directory to UCI HAR Dataset to get 'features.txt' and 'activity_labels.txt' files into dataframe variable
setwd("../../UCI HAR Dataset/")	#set to text files
FeatureLabelFiles <- c("features.txt","activity_labels.txt") #list of text files
for (i in 1:length(FeatureLabelFiles)) {
  temp <- paste('./',FeatureLabelFiles[i], sep = "") #file location
  assign(paste0("FeatureLabelVariable", i), read.table(temp, sep = "" , header = F, na.strings ="", stringsAsFactors= F))
} #for loop puts all 9 variable text files into dataframe variables with name 'Variable#'

#1B MERGE TRAIN AND TEST DATA SETS FROM THESE VARIABLES
#
#Core Test/Train 'Variables' 1-3 should have 1 & 3 added to the 2nd to which will give subject(1) and activity(3)
#'FeatureLabelVariable' 1 give decoding of proper names for 561 variables outside of 'subject' and 'activity'
#'FeatureLabelVariable' 2 give decoding of proper names for activity column
CoreTestVariable2 <- cbind(Activity = CoreTestVariable3$V1, CoreTestVariable2)
CoreTestVariable2 <- cbind(Subject = CoreTestVariable1$V1, CoreTestVariable2)
#import list of variable names in 'FeatureLabelVariable1' and put into colnames of 'CoreTestVariable2'
#also add 'Subject' and 'Activity column names added above to have all test folder files in 1 dataframe
Names <- character()
Names <- append(Names, "Subject")
Names <- append(Names, "Activity")
Names <- append(Names, as.list(FeatureLabelVariable1$V2))
colnames(CoreTestVariable2) <- Names
#Repeat above code for colnames only for 'Train' files so we have all train folder files in 1 dataframe
CoreTrainVariable2 <- cbind(Activity = CoreTrainVariable3$V1, CoreTrainVariable2)
CoreTrainVariable2 <- cbind(Subject = CoreTrainVariable1$V1, CoreTrainVariable2)
#Use already created 'Names' variable with all column names needed
colnames(CoreTrainVariable2) <- Names

#Train/Test 9 'variable' datasets need the Core Test/Train Variable 1 added to give the subject ID variable column
#Train/Test 9 'variable' has 128 columns per row representing 128 readings in a 2.56 second 'window' w/50% overlap 

#add column names to all 9 dataframes in 'test', length of for() loop 128
#create column names list and change names for each of 9 test files
#1
readings1 <- character() #empty vector
for (i in 1:length(colnames(Variable1))) {
  readings1 <- append(readings1, paste('test_body_acc_x_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable1) <- readings1 #insert 'readings' into Variable2 column names to create better names
#2
readings2 <- character() #empty vector
for (i in 1:length(colnames(Variable2))) {
  readings2 <- append(readings2, paste('test_body_acc_y_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable2) <- readings2 #insert 'readings' into Variable2 column names to create better names
#3
readings3 <- character() #empty vector
for (i in 1:length(colnames(Variable3))) {
  readings3 <- append(readings3, paste('test_body_acc_z_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable3) <- readings3 #insert 'readings' into Variable2 column names to create better names
#4
readings4 <- character() #empty vector
for (i in 1:length(colnames(Variable4))) {
  readings4 <- append(readings4, paste('test_body_gyro_x_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable4) <- readings4 #insert 'readings' into Variable2 column names to create better names
#5
readings5 <- character() #empty vector
for (i in 1:length(colnames(Variable5))) {
  readings5 <- append(readings5, paste('test_body_gyro_y_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable5) <- readings5 #insert 'readings' into Variable2 column names to create better names
#6
readings6 <- character() #empty vector
for (i in 1:length(colnames(Variable6))) {
  readings6 <- append(readings6, paste('test_body_gyro_z_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable6) <- readings6 #insert 'readings' into Variable2 column names to create better names
#7
readings7 <- character() #empty vector
for (i in 1:length(colnames(Variable7))) {
  readings7 <- append(readings7, paste('test_tot_acc_x_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable7) <- readings7 #insert 'readings' into Variable2 column names to create better names
#8
readings8 <- character() #empty vector
for (i in 1:length(colnames(Variable8))) {
  readings8 <- append(readings8, paste('test_tot_acc_y_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable8) <- readings8 #insert 'readings' into Variable2 column names to create better names
#9
readings9 <- character() #empty vector
for (i in 1:length(colnames(Variable9))) {
  readings9 <- append(readings9, paste('test_tot_acc_z_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(Variable9) <- readings9 #insert 'readings' into Variable2 column names to create better names

#Bind 'test' 'Core' dataframe and 9 Inertial dataframes together to get all variables for 'test' in same dataframe
Test_df <- bind_cols(CoreTestVariable2, Variable1, Variable2, Variable3, Variable4, Variable5, Variable6, Variable7, Variable8, Variable9)

#Repeat above dataframe consolidation for Train dataframes to reduce data to just 2 dataframes 'Test_df' and 'Train_df'

#1
readings1 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable1))) {
  readings1 <- append(readings1, paste('train_body_acc_x_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable1) <- readings1 #insert 'readings' into TrainVariable2 column names to create better names
#2
readings2 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable2))) {
  readings2 <- append(readings2, paste('train_body_acc_y_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable2) <- readings2 #insert 'readings' into TrainVariable2 column names to create better names
#3
readings3 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable3))) {
  readings3 <- append(readings3, paste('train_body_acc_z_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable3) <- readings3 #insert 'readings' into TrainVariable2 column names to create better names
#4
readings4 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable4))) {
  readings4 <- append(readings4, paste('train_body_gyro_x_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable4) <- readings4 #insert 'readings' into TrainVariable2 column names to create better names
#5
readings5 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable5))) {
  readings5 <- append(readings5, paste('train_body_gyro_y_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable5) <- readings5 #insert 'readings' into TrainVariable2 column names to create better names
#6
readings6 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable6))) {
  readings6 <- append(readings6, paste('train_body_gyro_z_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable6) <- readings6 #insert 'readings' into TrainVariable2 column names to create better names
#7
readings7 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable7))) {
  readings7 <- append(readings7, paste('train_tot_acc_x_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable7) <- readings7 #insert 'readings' into TrainVariable2 column names to create better names
#8
readings8 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable8))) {
  readings8 <- append(readings8, paste('train_tot_acc_y_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable8) <- readings8 #insert 'readings' into TrainVariable2 column names to create better names
#9
readings9 <- character() #empty vector
for (i in 1:length(colnames(TrainVariable9))) {
  readings9 <- append(readings9, paste('train_tot_acc_z_reading', i, sep = "")) #colnames for readings every 2.56 seconds for inertial signals
}
colnames(TrainVariable9) <- readings9 #insert 'readings' into TrainVariable2 column names to create better names

Train_df <- bind_cols(CoreTrainVariable2, TrainVariable1, TrainVariable2, TrainVariable3, TrainVariable4, TrainVariable5, TrainVariable6, TrainVariable7, TrainVariable8, TrainVariable9)

#Merged Train_df AND Test_df dataframes into 1 big dataframe
#This needed some columns labeled NA so no reworking column names just kept these separate for the 9 variables
SamsungGalaxyS <- bind_rows(Test_df, Train_df)

#PART 2 -> Extracts only the measurements on the mean and standard deviation for each measurement. 
#grab column names that have 'mean' or 'std' in the name in 'FeatureLabelVariable'.  This has all SamsungGalaxyS column names except inertial
#signals which do not have mean or std in the large data frame(SamsungGalaxyS) 
FLVms <- FeatureLabelVariable1[grep("mean|std",FeatureLabelVariable1$V2),]

#column names to pull put into a character vector
Scol <- FLVms$V2 

#pulled columns into new data frame retaining Subject & Activity columns as well
Samsunglite <- SamsungGalaxyS[,c("Subject", "Activity", Scol)] 

#PART 3 -> Uses descriptive activity names to name the activities in the data set
#Use FeatureLabelVariable2 to change activity number to name
#take match template column desired and match OG data frame column to other template column not wanted to create a vector, then
#push that vector into the 'Activity column' of the OG data frame column replacing the old values
Samsunglite$Activity <- FeatureLabelVariable2$V2[match(Samsunglite$Activity, FeatureLabelVariable2$V1)] 
#now at 10299 x 81 data frame

#PART 4 -> Appropriately labels the data set with descriptive variable names. 
#Already done

#PART 5 -> From the data set in step 4, creates a second, independent tidy data set 
#PART 5(cont) with the average of each variable for each activity and each subject.
#library(dplyr) already loaded
#group by A then summarize that grouping by sum but I want mean
#example -> df %>% group_by(colA) %>% summarise(B = sum(B))
TidySamsung <- Samsunglite %>% group_by(Subject, Activity) %>% summarise_all("mean")
View(TidySamsung)
