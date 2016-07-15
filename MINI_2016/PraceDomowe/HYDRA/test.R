library(randomForest)
irisRf <- randomForest(Species ~ ., data=iris, ntree=100000)
saveRDS(irisRf, 'irisRf.rds')
