library(rpart)
library(rattle)
library(rminer)

set.seed(123)
setwd('~/github/basket-shots/datasets/')

# Import dataset
dataset = read.csv('shots_att_def_stats.csv', sep=",", fileEncoding="latin1")

setwd('~/github/basket-shots/docs/')

dataset = dataset[sample(1:nrow(dataset)),]

# Removing outlier
dataset = dataset[dataset$touch_time >= 0,]

# Remove unuseful features
dataset = dataset[-c(1, 2)]

# Use *only* the first X entries
#dataset = head(dataset, 60000)

# Scaling dataset 
performScaling <- FALSE  # Turn it on/off for experimentation.

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

rp <- rpart(shot_result~., data = dataset, method="class") #for tests only: cp = 0.001
fancyRpartPlot(rp)
printcp(rp)

plotcp(rp) # visualize cross-validation results
summary(rp) # detailed summary of splits

M=crossvaldata(shot_result~.,dataset,fit,predict,ngroup=10,model="rpart",task="class",
               control = rpart::rpart.control(cp=0.01))
C=mmetric(dataset$shot_result,M$cv.fit,metric="ALL")
print(C)