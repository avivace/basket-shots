set.seed(123)
setwd('~/github/basket-shots/datasets/')
library(rminer)
library(ggplot2)
library(doParallel)

# Import dataset
dataset = read.csv('shots_att_def_stats.csv', sep=",", fileEncoding="latin1")
setwd('~/github/basket-shots/docs/')

dataset = dataset[sample(1:nrow(dataset)),]

# Removing outlier
dataset = dataset[dataset$touch_time >= 0,]

# Remove unuseful features
dataset = dataset[-c(1, 2)]

# Use *only* the first X entries
dataset = head(dataset, 40000)

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
split.data = function(data, p = 0.8, s = 1) {
  set.seed(s)
  index = sample(1:dim(data)[1])
  train = data[index[1:floor(dim(data)[1] * p)], ]
  test = data[index[((ceiling(dim(data)[1] * p)) + 1):dim(data)[1]], ]
  return(list(train=train, test=test))
}

# Train model
allset = split.data(dataset, p = 0.8, s = 1)
trainset= allset$train
testset= allset$test

model=fit(shot_result~.,trainset,model="ksvm", task="prob", kernel="rbfdot", C=1)
print(model@time)

# Importance
I=Importance(model, trainset)
imax=which.max(I$imp)
L=list(runs=1,sen=t(I$imp),sresponses=I$sresponses) # create a simple mining list
# par(mar=c(2.0,2.0,2.0,2.0)) # enlarge PDF margin
mgraph(L,graph="IMP",leg=names(dataset),col="gray",Grid=10,PDF="importance-svm")

# Cross validation

valdata = crossvaldata(shot_result~., dataset, fit, predict, ngroup = 10, 
                       task="prob", model="ksvm", kernel="rbfdot", C=1)

# Print results
print(valdata$mpar)

# Metrics and confusion matrix
metrics=mmetric(dataset$shot_result,valdata$cv.fit,metric=c("ALL"))
print(metrics)
conf_matrix = mmetric(dataset$shot_result,valdata$cv.fit,metric=c("CONF"))
print(conf_matrix)

# AUC and ROC for SVM
auc=mmetric(dataset$shot_result,valdata$cv.fit,metric=c("AUC"))
print(auc)
txt=paste(levels(dataset$shot_result)[2],"AUC:",round(mmetric(dataset$shot_result,valdata$cv,metric="AUC",TC=2),2))
mgraph(dataset$shot_result,valdata$cv,graph="ROC",baseline=TRUE,Grid=10,main=txt,TC=2,PDF="roc-svm-missed")

txt=paste(levels(dataset$shot_result)[1],"AUC:",round(mmetric(dataset$shot_result,valdata$cv,metric="AUC",TC=1),2))
mgraph(dataset$shot_result,valdata$cv,graph="ROC",baseline=TRUE,Grid=10,main=txt,TC=1,PDF="roc-svm-made")
