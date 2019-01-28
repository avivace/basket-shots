setwd('~/shared')
library(factoextra)
library(FactoMineR)
library(caTools)
#library(e1071)
library(caret)
library(ggplot2)

dataset = read.csv('shots_att_def_clean.csv', sep=",", fileEncoding="latin1")
hist(dataset$SHOT_DIST, breaks=30, xlim=c(0,20))
dataset = dataset[-c(1, 7, 9)]

ggplot(data=dataset, aes(x=SHOT_DIST, y=CLOSE_DEF_DIST)) + geom_point(aes(color=factor(SHOT_RESULT))) + 
  geom_vline(xintercept = c(15,22), color="black")
#dataset$SHOT_RESULT = factor(dataset.SHOT_RESULT)
dataset = head(dataset, 20000)
str(dataset)

split.data = function(data, p = 0.7, s = 1){
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
svm.model <- svm(SHOT_RESULT ~ ., trainset, max_gamma=25)
svm.pred <- predict(svm.model, testset)
svm.table=table(svm.pred, testset$SHOT_RESULT)
svm.table
sum(diag(svm.table))/sum(svm.table)
# library(e1071)
# svm.model = svm(SHOT_RESULT~ ., data=trainset, kernel='linear',
#                 cost=10000, scale=FALSE)
# svm.pred = predict(svm.model, testset)
# svm.table=table(svm.pred, testset$SHOT_RESULT)
# svm.table

# library(rpart)
# decisionTree = rpart(SHOT_RESULT~ ., data=trainset, method="class")
# testset$Prediction <- predict(decisionTree, testset, type = "class")
# confusion.matrix = table(testset$SHOT_RESULT, testset$Prediction)
# sum(diag(confusion.matrix))/sum(confusion.matrix)
# 
# library(rattle)
# library(rpart.plot)
# library(RColorBrewer)
# fancyRpartPlot(decisionTree)




# 
# dataset = read.csv('shots_def_att.csv', sep=",", fileEncoding="latin1")
# 
# dataset <- dataset[!(is.na(dataset$defend_Player)),]
# 
# dataset = dataset[c(-1, -2, -9)]
# dataset$SHOT_RESULT = factor(dataset$SHOT_RESULT)
# # PCA and MCA to evaluate features
# 
# #res.famd <- FAMD(dataset, graph = FALSE)
# #fviz_eig(res.famd)
# 
# #dataset[(dataset$averageRating > 8  ), c("averageRating")] <- 'Ottimi'
# #dataset[(dataset$averageRating > 5.5 & dataset$averageRating <= 8), c("averageRating")] <- 'Buoni'
# #dataset[(dataset$averageRating <= 5.5 & dataset$averageRating > 3), c("averageRating")] <- 'Pessimi' 
# #dataset[(dataset$averageRating <= 3), c("averageRating")] <- 'Orribili' 
# 
# #dataset$averageRating = factor(dataset$averageRating, levels = c('Ottimi','Buoni', 'Pessimi', 'Orribili'))
# 
# # Splitting the dataset into the Training set and Test set
# 
# set.seed(123)
# split = sample.split(dataset$SHOT_RESULT, SplitRatio = 0.75)
# training_set = subset(dataset, split == TRUE)
# test_set = subset(dataset, split == FALSE)
# 
# # Feature Scaling
# #training_set[-3] = scale(training_set[-3])
# #test_set[-3] = scale(test_set[-3])
# 
# 
# # method <- readline(prompt="Scrivi il metodo da utilizzare (SVM/BAYES/DT): ")
# # 
# # if(method == "SVM"){
# #   classifier = svm(formula = vote_average ~ .,
# #                        data = training_set,
# #                        type = 'C-classification',
# #                        kernel = 'linear')
# #   # Predicting the Test set results
# #   y_pred = predict(classifier, newdata = test_set[-3])
# # } else if (method == "BAYES") {
# #   classifier = naiveBayes(x = training_set[-3],
# #                           y = training_set$vote_average)
# #   # Predicting the Test set results
# #   y_pred = predict(classifier, newdata = test_set[-3])
# # } else if (method == "DT") {
# #   library(rpart)
# #   classifier = rpart(formula = vote_average ~ .,
# #                      data = training_set)
# #   # Predicting the Test set results
# #   y_pred = predict(classifier, newdata = test_set, type = 'class')
# # }
# 
# # Cross validation -> change method parameter of train for check others techniques
# 
# 
# train_control = trainControl(method="cv", number=10, savePredictions = TRUE)
# 
# # add in train this variable: preProcess=c("pca")
# model <- train(SHOT_RESULT~., data=training_set, trControl=train_control,
#                method="svmLinear")
# model$pred
# print(model)
# confusionMatrix(test_set, reference=model$pred)
# 
# 
# 
