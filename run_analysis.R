##Getting and cleaning Data
#Course project
require(dplyr)

#descargamos el archivo

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ",
              "data")

#Ja se fara

#descompresion de los archivos


#DATA DOWNLOAD

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

con <- unz(temp, "UCI HAR Dataset/features.txt")
features <- matrix(scan(con,what="character",quote='"\"'),ncol =2, byrow=TRUE)

con <-unz(temp,"UCI HAR Dataset/train/subject_train.txt")
subject_train <-  matrix(scan(con,what="numeric",quote='"\"'))
con <- unz(temp, "UCI HAR Dataset/train/y_train.txt")
y_train <- matrix(scan(con),ncol = 1, byrow = TRUE)
con <- unz(temp, "UCI HAR Dataset/train/X_train.txt")
x_train <- matrix(scan(con,what = "numeric"), ncol = 561, byrow = TRUE)

train_set <- cbind(x_train,y_train,subject_train)
colnames(train_set) <- c(features[,2],"activity","subject")

con <-unz(temp,"UCI HAR Dataset/test/subject_test.txt")
subject_test <- matrix(scan(con,what="numeric",quote='"\"'))
con <- unz(temp, "UCI HAR Dataset/test/y_test.txt")
y_test <- matrix(scan(con),ncol = 1, byrow=TRUE)
con <- unz(temp, "UCI HAR Dataset/test/X_test.txt")
x_test <- matrix(scan(con,what = "numeric"), ncol = 561, byrow=TRUE)

test_set <- cbind(x_train,y_train,subject_train)
colnames(test_set) <- c(features[,2],"activity","subject")

con <- unz(temp, "UCI HAR Dataset/activity_labels.txt")
labels <- matrix(scan(con,what = "character",quote='"\"'),ncol = 2, byrow=TRUE)

unlink(temp)

#END DATA DOWNLOAD

all_set <- rbind(train_set,test_set)

das <- as.data.frame.matrix(all_set)
for(i in 1:ncol(das))  das[,i]<-  as.numeric(as.character(das[,i]))

meancol <-grep(pattern = "mean",x =names(das))
stdcol <- grep(pattern = "std", x = names(das))

namcol <- names(das)[sort(c(meancol,stdcol))]
dast <- das[,c(namcol,"activity","subject")]

lapply(1:ncol(dast), function(i) class(dast[,i]))

dast$activity <- unlist(lapply(1:nrow(dast), function(i) labels[das$activity[i],2]))             
            
tidy = aggregate(dast, by=list(activity = dast$activity, subject=dast$subject), mean)

write.table(tidy,"tidy.txt",row.names=FALSE)
