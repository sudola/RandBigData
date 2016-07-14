library(randomForest)
irisRf <- randomForest(Species ~ ., data=iris, ntree=1000000)
saveRDS(irisRf, 'irisRf.rds')