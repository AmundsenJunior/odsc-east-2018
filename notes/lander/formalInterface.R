boros <- tibble::tribble(
  ~ Boro, ~ Pop, ~ Size, ~ Random,
  'Manhattan', 1600000, 23, 7,
  'Brooklyn', 2600000, 78, 24,
  'Queens', 2330000, 104, pi,
  'Bronx', 1455000, 42, 21,
  'Staten Island', 475000, 60, 3
)
#tibble - fancier data frame
boros

library(useful)

# formula y ~ x
build.x( ~ Pop, data=boros)
# now a matrix, with only numbers
# easier to do matrix algebra

# add a second variable
build.x( ~ Pop + Size, boros)

# Linear Model  Y = f(X) = XB + e
# in matrix form
# column of responses = variable-observations 2d matrix * column of coefficients + column of errors

# this is what happens under the hood of lm and glm

# interaction terms - the multiplicative effect

# create a matrix with both the individual terms and the interaction term, preferred by oldfashioned statisticians
build.x( ~ Pop * Size, boros)

# create a matrix with just the interaction term
build.x( ~ Pop:Size, boros)

# if I want pop and interaction
build.x( ~ Pop + Pop:Size, boros)
# or
build.x( ~ Pop * Size - Size, boros)
# easier method when you have multiple predictors

# get rid of intercept
build.x( ~ Pop - 1, boros)

# how to model the categorical borough name "Boro"
# usually use factor variable or dummy variable
# in machine learning, may not want to imply ordinality
# in education, "some high school, high school grad...." that could work

# here, use a boolean with each category as a column
build.x( ~ Boro, boros)
# leaves out BoroBronx, by default the first category alphabetically
# in matrix algebra, can't allow for collinearity where can't have every column add up to 1
# doesn't matter as much w/collinearity in machine learning

# include the Bronx column
build.x( ~ Boro, boros, contrasts=FALSE)

build.x( ~ Pop + Boro, boros, contrasts=FALSE)

build.x( ~ Pop * Boro, boros)


# create a sparse matrix - do you need to store all the zeroes? where an integer is the same size in memory regardless of value
# sparse matrices save storage space and compute time
# need to use sparse matrix algebra
build.x( ~ Pop * Boro, boros, sparse=TRUE)





