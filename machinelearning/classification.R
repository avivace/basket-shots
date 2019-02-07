set.seed(123)
setwd('~/github/basket-shots/datasets/')
library(rminer)
library(ggplot2)

# Import dataset
dataset = read.csv('shots_att_def_stats.csv', sep=",", fileEncoding="latin1")
dataset = dataset[sample(1:nrow(dataset)),]

# Removing outlier
dataset = dataset[dataset$touch_time >= 0,]

# Remove unuseful features
dataset = dataset[-c(1, 2)]

# Use *only* the first X entries
dataset = head(dataset, 25000)
#dataset$SHOT_CLOCK = as.numeric(as.character(dataset$SHOT_CLOCK))

# Scaling dataset 
performScaling <- TRUE  # Turn it on/off for experimentation.

if (performScaling) {
  
  # Loop over each column.
  for (colName in names(dataset)) {
    
    # Check if the column contains numeric data.
    if(class(dataset[,colName]) == 'integer' | class(dataset[,colName]) == 'numeric') {
      
      x = dataset[,colName]
      # Scale this column (scale() function applies z-scaling).
      dataset[,colName] <- (x-min(x))/(max(x)-min(x))
    }
  }
}

# One-hot encoding
library(ade4)
library(data.table)
feats = c('location', 'position_attack', 'position_defend')

for (f in feats){
  dataset_dummy = acm.disjonctif(dataset[f])
  dataset[f] = NULL
  dataset = cbind(dataset, dataset_dummy)
}

str(dataset)

# Split dataset helper function
split.data = function(data, p = 0.7, s = 1) {
  set.seed(s)
  index = sample(1:dim(data)[1])
  train = data[index[1:floor(dim(data)[1] * p)], ]
  test = data[index[((ceiling(dim(data)[1] * p)) + 1):dim(data)[1]], ]
  return(list(train=train, test=test))
}

allset = split.data(dataset, p = 0.8, s = 1)
trainset= allset$train
testset= allset$test

# Train model
model=fit(shot_result~.,trainset,model="svm", task="prob")
# Importance
I = Importance(model, trainset, method="1D-SA")

i = 1
for (colName in names(dataset)) {
  message(colName, round(I$imp[i],digits=2))
  i = i + 1
  # Check if the column contains numeric data.
}

# Print model parameters
print(model@mpar)
print(model@time)
prediction = predict(model, testset)
accuracy=mmetric(testset$shot_result,prediction,metric=c("ACC", "TPR"))
print(accuracy)
m=mmetric(testset$shot_result,prediction,metric=c("AUC"))
print(m) # confusion matrix

# ROC
txt=paste(levels(testset$shot_result)[2],"AUC:",round(mmetric(testset$shot_result,prediction,metric="AUC",TC=2),2))
mgraph(testset$shot_result,prediction,graph="ROC",baseline=TRUE,Grid=10,main=txt,TC=2,PDF="roc-1")

# Cross validation
valdata = crossvaldata(shot_result~., dataset, fit, predict, ngroup = 10, task="prob", model="svm")
accuracy=mmetric(dataset$shot_result,valdata$cv.fit,metric=c("ACC"))
print(accuracy)
m=mmetric(dataset$shot_result,prediction,metric=c("AUC"))
print(m)
txt=paste(levels(testset$shot_result)[2],"AUC:",round(mmetric(testset$shot_result,prediction,metric="AUC",TC=2),2))
mgraph(testset$shot_result,prediction,graph="ROC",baseline=TRUE,Grid=10,main=txt,TC=2,PDF="roc-1")

