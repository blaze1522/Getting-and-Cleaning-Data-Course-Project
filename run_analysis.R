library(data.table)

setwd("/home/goirik/Documents/Coursera/R Programming/3 Cleaning up Data/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset")

trainflist <- list.files("train", full.names=T)[-1]
testflist <- list.files("test", full.names=T)[-1]

files <- c(trainflist, testflist)
data <- lapply(files, read.table, stringsAsFactors=F, header=F)

# Step1: Merge the train and test datasets.

data1 <- mapply(rbind, data[c(1:3)], data[4:6])
data2 <- do.call(cbind, data1) #with do.call we can call a function and then pass arguments as a list

# Step2: Find the mean and standard dev for each measurement in data2

features <- fread("features.txt", header=F, stringsAsFactor=F)
measurements <- grep("std|mean\\(\\)", features$V2)

# Step4: Appropriately label the data set with descriptive variable names.

n <- length(features$V2)+2
setnames(data2, c(1:n), c("subject", features$V2, "activity"))
data3 <- data2[, c(1, measurements, n)] 

# Step3: Use descriptive names to name the activities

activities <- fread(list.files()[2], header=F, stringsAsFactor=F)
data3$activity <- activities$V2[match(data3$activity, activities$V1)]
# head(data3)

# Step5: Write final tidy table

data4 <- aggregate(. ~ subject+activity, data=data3, FUN=mean)
setwd("/home/goirik/Documents/Coursera/R Programming/3 Cleaning up Data/Getting-and-Cleaning-Data-Course-Project")
write.table(data4, "meantable.txt")
# write.csv(data4, "meantable.csv")