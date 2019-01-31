set.seed(123)
setwd('~/github/basket-shots/datasets/')
library(rminer)

# Import dataset
dataset = read.csv('shots_att_def_clean.csv', sep=",", fileEncoding="latin1")
# Remove
dataset = dataset[-c(1, 7, 9)]
# Use *only* the first X entries
dataset = head(dataset, 2000)
dataset$SHOT_CLOCK = as.numeric(as.character(dataset$SHOT_CLOCK))
str(dataset)
# Split dataset helper function
split.data = function(data, p = 0.7, s = 1) {
  set.seed(s)
  index = sample(1:dim(data)[1])
  train = data[index[1:floor(dim(data)[1] * p)], ]
  test = data[index[((ceiling(dim(data)[1] * p)) + 1):dim(data)[1]], ]
  return(list(train=train, test=test))
}

allset = split.data(dataset, p = 0.7, s = 1)
trainset= allset$train
testset= allset$test

# Train model
model=fit(SHOT_RESULT~.,trainset,model="svm", task="class")
# Print model parameters
print(model@mpar)
prediction = predict(model, testset)
accuracy=mmetric(testset$SHOT_RESULT,prediction,metric=c("ACC", "TPR"))
print(accuracy)
m=mmetric(testset$SHOT_RESULT,prediction,metric=c("CONF"))
print(m$conf) # confusion matrix

# LIFT and ROC curves
txt=paste(levels(trainset$SHOT_RESULT)[2],"AUC:",round(mmetric(trainset$SHOT_RESULT,prediction,metric="AUC",TC=2),2))
mgraph(trainset$SHOT_RESULT,prediction,graph="ROC",baseline=TRUE,Grid=10,main=txt,TC=2,PDF="roc-1")
txt=paste(levels(trainset$SHOT_RESULT)[2],"ALIFT:",round(mmetric(trainset$SHOT_RESULT,prediction,metric="ALIFT",TC=2),2))
mgraph(testset$SHOT_RESULT,prediction,graph="LIFT",baseline=TRUE,Grid=10,main=txt,TC=2,PDF="lift-1")

# Cross validation
valdata = crossvaldata(SHOT_RESULT~., dataset, fit, predict, ngroup = 10, task="class", model="svm",control = rpart::rpart.control(cp=0.05))
m=mmetric(dataset$SHOT_RESULT,valdata$cv.fit,metric=c("ACC"))
print(m)
