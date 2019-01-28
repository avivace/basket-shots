set.seed(123)
setwd('~/github/basket-shots/datasets/')
library(caTools)
library(caret)
library(ggplot2)
library(caret)
library(dplyr)


dataset = read.csv('shots_att_def_clean.csv', sep=",", fileEncoding="latin1")
hist(dataset$SHOT_DIST, breaks=30, xlim=c(0,20))
dataset = dataset[-c(1, 7, 9,)]

ggplot(data=dataset, aes(x=SHOT_DIST, y=CLOSE_DEF_DIST)) + geom_point(aes(color=factor(SHOT_RESULT))) + 
  geom_vline(xintercept = c(15,22), color="black")
dataset = head(dataset,2500)
str(dataset)

split.data = function(data, p = 0.7, s = 1) {
  set.seed(s)
  index = sample(1:dim(data)[1])
  train = data[index[1:floor(dim(data)[1] * p)], ]
  test = data[index[((ceiling(dim(data)[1] * p)) + 1):dim(data)[1]], ]
  return(list(train=train, test=test)) }

allset = split.data(dataset, p = 0.7)
trainset= allset$train
testset= allset$test
table(trainset$SHOT_RESULT)
prop.table(table(trainset$SHOT_RESULT))



library(liquidSVM)

model <- init.liquidSVM(SHOT_RESULT ~ ., dataset)

setConfig(model, "scale", TRUE)
setConfig(model, "grid_choice", 0)
#setConfig(model, "max_gamma", 25)
setConfig(model, "folds", 10)
setConfig(model, "display", 1)
setConfig(model, "scenario", "rocSVM")
#setConfig(model, "max_lambda", 10)

trainSVMs(model)
selectSVMs(model)
result <- test(model, testset)

model <- svm(model)

pred <- predict(model, testset)
table=table(pred, testset$SHOT_RESULT)
table
sum(diag(table))/sum(table)
plotROC(result, testset$SHOT_RESULT)
