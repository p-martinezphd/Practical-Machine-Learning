
library(lattice)
library(ggplot2)
library(plyr)
library(randomForest)

training.raw <- read.csv('~/pml-training.csv')
testing.raw <- read.csv('~/pml-testing.csv')

dim(training.raw)


remove.packages(c("ggplot2", "data.table"))
install.packages('Rcpp', dependencies = TRUE)
install.packages('ggplot2', dependencies = TRUE)
install.packages('data.table', dependencies = TRUE)

maxNAPerc = 20
maxNACount <- nrow(training.raw) / 100 * maxNAPerc
removeColumns <- which(colSums(is.na(training.raw) | training.raw=="") > maxNACount)
training.cleaned01 <- training.raw[,-removeColumns]
testing.cleaned01 <- testing.raw[,-removeColumns]

removeColumns <- grep("timestamp", names(training.cleaned01))
training.cleaned02 <- training.cleaned01[,-c(1, removeColumns )]
testing.cleaned02 <- testing.cleaned01[,-c(1, removeColumns )]


classeLevels <- levels(training.cleaned02$classe)
training.cleaned03 <- data.frame(data.matrix(training.cleaned02))
training.cleaned03$classe <- factor(training.cleaned03$classe, labels=1)
testing.cleaned03 <- data.frame(data.matrix(testing.cleaned02))




training.cleaned <- training.cleaned03
testing.cleaned <- testing.cleaned03

update.packages()

set.seed(19791108)

update.packages('cli')

library(caret)


classeIndex <- which(names(training.cleaned) == "classe")

partition <- createDataPartition(y=training.cleaned$classe, p=0.75, list=FALSE)
training.subSetTrain <- training.cleaned[partition, ]
training.subSetTest <- training.cleaned[-partition, ]
