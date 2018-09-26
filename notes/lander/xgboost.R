# decision trees
# binary splits on factors
# can be used for classification or regression
# sum over M discrete regions the average of all regions multiplied by the average of each region
# recursive partitioning
# model is learning the buckets from the data automatically, instead of manually creating the buckets

# random forest - taking different random subsets of variables and splits/buckets to find optimizations of prediction

# gradient boosted tree
# optimize subsequent models to make up for the difference in residuals (well-fit variables are downgraded, poorly-fit are upgraded)

rm(list = ls())

packages <- c('useful', 'coefplot', 'here', 'xgboost', 'magrittr', 'dygraphs')
purrr::walk(packages, library, character.only=TRUE)

# from dataset 80/10/10 or 70/20/10 for train/validate/test depending on dataset size
manTrain <- readRDS(here('data/landeranalytics-training/data', 'manhattan_Train.rds'))
manVal <- readRDS(here('data/landeranalytics-training/data', 'manhattan_Validate.rds'))
manTest <- readRDS(here('data/landeranalytics-training/data', 'manhattan_Test.rds'))

# changed from earlier session for outcome variable to ask is it a historic district
# reminder that you can ask different questions of the same data
histFormula <- HistoricDistrict ~ FireService + ZoneDist1 + ZoneDist2 + Class + LandUse + OwnerType + LotArea + BldgArea + 
ComArea + ResArea + OfficeArea + RetailArea + GarageArea + FactryArea + NumBldgs + NumFloors + UnitsRes + 
    UnitsTotal + LotFront + LotDepth + BldgFront + BldgDepth + LotType + Landmark + BuiltFAR + Built + TotalValue - 1

# build training, validation, and test matrices
manX_Train <- build.x(histFormula, data=manTrain, contrasts=FALSE, sparse=TRUE)
manY_Train <- build.y(histFormula, data=manTrain) %>% as.integer() - 1
manX_Val <- build.x(histFormula, data=manVal, contrast=FALSE, sparse=TRUE)
manY_Val <- build.y(histFormula, data=manVal) %>% as.integer() - 1
manX_Test <- build.x(histFormula, data=manTest, contrast=FALSE, sparse=TRUE)
manY_Test <- build.y(histFormula, data=manTest) %>% as.integer() - 1

# creates special object that stores both x matrix and y vector
xgTrain <- xgb.DMatrix(data=manX_Train, label=manY_Train)
xgVal <- xgb.DMatrix(data=manX_Val, label=manY_Val)


xg1 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', nrounds=1)

# added watchlist to get logloss value
xg2 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', nrounds=1, watchlist=list(train=xgTrain))
xg2$evaluation_log

xg3 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=100, print_every_n=1, watchlist=list(train=xgTrain))

xg4 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=300, print_every_n=1, watchlist=list(train=xgTrain))

# check for overfitting 
xg5 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=300, print_every_n=1, watchlist=list(train=xgTrain, validate=xgVal)
                 )

dygraph(xg5$evaluation_log)

xg6 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=1000, print_every_n=10, watchlist=list(train=xgTrain, validate=xgVal)
                 )
dygraph(xg6$evaluation_log)

# stop earlier than nrounds if the model isn't improving against validation data
xg7 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=1000, print_every_n=10, watchlist=list(train=xgTrain, validate=xgVal),
                 early_stopping_rounds=70
                 )
dygraph(xg7$evaluation_log)

# start a new model at a previous stopping point of a previous model
xg8 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=2000, print_every_n=10, watchlist=list(train=xgTrain, validate=xgVal),
                 early_stopping_rounds=70, xgb_model=xg3
                 )


# needs 'DiagrammeR' package, which fails to install
xgb.plot.multi.trees(xg7, feature_names=colnames(manX_Train))

# shows variables that have a lot of impact on tree splits
xgb.plot.importance(xgb.importance(xg7, feature_names=colnames(manX_Train)))
xgb.importance(xg7, feature_names=colnames(manX_Train)) %>% View


# can run gradient boosting on any supervised learning model, like linear
xg9 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gblinear', eval_metric='logloss', 
                 nrounds=1000, print_every_n=10, watchlist=list(train=xgTrain, validate=xgVal),
                 early_stopping_rounds=70
                 )
coefplot(xg9, sort='magnitude')

# xgboost can do penalized regressions 
xg10 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gblinear', eval_metric='logloss', 
                 nrounds=1000, print_every_n=10, watchlist=list(train=xgTrain, validate=xgVal),
                 early_stopping_rounds=70, alpha=100000, lambda=250
                 )
coefplot(xg10, sort='magnitude')
dygraph(xg10$evaluation_log)
# xgboost does better with a tree model than the linear here, because likely the data does not have anything close to a linear relationship



# we want weak learners, so trees don't overfit too fast, by setting max depth of number of splits in each iteration
xg11 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=1000, print_every_n=10, watchlist=list(train=xgTrain, validate=xgVal),
                 early_stopping_rounds=70, max_depth=3
                 )

# change the learning rate - the depth of each step as it moves over or under to get down gradient descent towards optimization
xg12 <- xgb.train(data=xgTrain, objective='binary:logistic', booster='gbtree', eval_metric='logloss', 
                 nrounds=2500, print_every_n=20, watchlist=list(train=xgTrain, validate=xgVal),
                 early_stopping_rounds=70, max_depth=3, eta=0.1
                 )
# there are seven different hyperparameters in xgb.train (different tuning knobs that make the model work better or worse)
# best to make a random search of a sampling of values across the range of each hyperparam, running each of those combinations
# caret can be used to handle that coordination around executing xgboost


# experimental feature to do random forest in xgboost
xg13 <- xgb.train(data=xgTrain, objective='binary:logistic', eval_metric='logloss', booster='gbtree',
                  watchlist=list(train=xgTrain, validate=xgVal), early_stopping_rounds=20, subsample=0.5,
                  nrounds=100, print_every_n=1
                  )

xg14 <- xgb.train(data=xgTrain, objective='binary:logistic', eval_metric='logloss', booster='gbtree',
                  watchlist=list(train=xgTrain, validate=xgVal), early_stopping_rounds=20, subsample=0.5,
                  nrounds=100, print_every_n=1, col_subsample=0.5
                  )

xg15 <- xgb.train(data=xgTrain, objective='binary:logistic', eval_metric='logloss', booster='gbtree',
                  watchlist=list(train=xgTrain, validate=xgVal), early_stopping_rounds=20, subsample=0.5,
                  nrounds=50, print_every_n=1, col_subsample=0.5, num_parallel_tree=20
                  )


# run in parallel on multiple cores
xg16 <- xgb.train(data=xgTrain, objective='binary:logistic', eval_metric='logloss', booster='gbtree',
                  watchlist=list(train=xgTrain, validate=xgVal), early_stopping_rounds=20, subsample=0.5,
                  nrounds=50, print_every_n=1, col_subsample=0.5, num_parallel_tree=20, nthread=4
                  )

