packages <- c('here', 'coefplot', 'useful', 'glmnet', 'ggplot2', 'magrittr')

# cool func - walk data frame and load into function
purrr::walk(packages, library, character.only=TRUE)

getwd()

setwd('/home/srussell/dev/r/odsc-2018/learningr')
getwd()

dir('data/landeranalytics-training/data')

# load lots data from csv
lots <- readRDS(here('data/landeranalytics-training/data', 'manhattan_Train.rds'))

# tabular rep of data
View(lots)
names(lots)

# linear model formula (don't include the intercept)
valueFormula <- TotalValue ~ FireService + ZoneDist1 + ZoneDist2 + Class + LandUse + OwnerType + LotArea + BldgArea + 
    ComArea + ResArea + OfficeArea + RetailArea + GarageArea + FactryArea + NumBldgs + NumFloors + UnitsRes + 
    UnitsTotal + LotFront + LotDepth + BldgFront + BldgDepth + LotType + Landmark + BuiltFAR + Built + HistoricDistrict - 1

class(valueFormula)

#initial linear model
value1 <- lm(valueFormula, data=lots)

# coefficient plot of all coefficients
# value estimate is the dot for each coefficient, with the wings the confidence intervals
coefplot(value1, sort='magnitude')
?coefplot
summary(value1)


# glmnet requires matrices
# easiest to create once, then apply multiple models against

lotsX <- build.x(valueFormula, data=lots, contrasts=FALSE, sparse=TRUE)
dim(lotsX)
class(lotsX)

lotsY <- build.y(valueFormula, data=lots)
head(lotsY)
class(lotsY)

value2 <- glmnet(x=lotsX, y=lotsY, family='gaussian')
# glmnet is fitting a regression for each value of lambda (fit 100 models sequentially)
# it's actually faster than lm fitting one model
# glmnet automatically scales all variables, calculates coefficients, then unscales the coefficients as output

value2$lambda
# bigger the lambda the more shrinkage, the smaller lambda, less shrinkage

plot(value2)

coefpath(value2)
# hover over
# x axis is log lambda - little to a lot of penalty/shrinkage
# y axis shows values of coefficients
# with each line representing the coefficient for a different variable, including one line per category in categorical variables

coef(value2)

range(value2$lambda)

# when choosing a small lambda, not a lot of penalty, so most variables still present
# large lambda - most vars removed
coefplot(value2, sort='magnitude', lambda=500)
coefplot(value2, sort='magnitude', lambda=2000000)
coefplot(value2, sort='magnitude', lambda=100000)

# what is the right lambda is the wrong question
# we can answer what the optimal lambda for the model to fit with the data

# cross-validation
# split dataset into k discrete sets
# check model against each subset

value3 <- cv.glmnet(x=lotsX, y=lotsY, family='gaussian', nfolds=5)
plot(value3)
# cross validation glmnet gives us the mean squared errors
# top of x axis is number of variables in your model for a specific log(lambda)
# left verical line provides best fiting model for your data based on cross-fitted modeling
value3$lambda.min
# right vertical line is the biggest lambda you can get within the best error - and a bigger lambda has a smaller set of variables
value3$lambda.1se

coefpath(value3)
coefplot(value3, sort='magnitude', lambda='lambda.min')
coefplot(value3, sort='magnitude', lambda='lambda.1se')
coefplot(value3, sort='magnitude', lambda='lambda.1se', plot=FALSE)

# glmnet, and cv.glmnet are more predictive than standard lm models, while still providing human-interpretable modelling
# glmnet family is dictated by your y variable type


# by default alpha =1, which is lasso; alpha = 0 is ridge regression
value4 <- cv.glmnet(x=lotsX, y=lotsY, family='gaussian', nfolds=5, alpha=0)
plot(value4)
# lasso, by having the discontinuities at 0, this creates value selection
# ridge never hits 0, so all variables are still selected
coefpath(value4)
coefplot(value4, sort='magnitude', lambda='lambda.1se')

value5 <- cv.glmnet(x=lotsX, y=lotsY, family='gaussian', nfolds=5, alpha=0.5)
coefpath(value5)
# cross-validation over alpha is manually done
# it's not automatically done in glmnet (either with caret or modelr)


lots_new <- readRDS(here('data/landeranalytics-training/data', 'manhattan_Test.rds'))

lotsX_new <- build.x(valueFormula, data=lots_new, contrasts=FALSE, sparse=TRUE)
value3Preds <- predict(value3, newx=lotsX_new, s='lambda.1se')
head(value3Preds)

value3$cvm[17]
