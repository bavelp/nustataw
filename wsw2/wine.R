setwd("SET TO YOUR WORKING DIRECTORY")

# tidyverse contains readr, dplyr, ggplot2, magrittr, and other packages with functions we will be using
require(tidyverse)
# gridExtra allows us to put multiple visuals on the same plot
require(gridExtra)
# caret consolidates model packages into a single syntax
require(caret)

# load the red wine quality dataset
red.df <-
  read_delim("winequality-red.txt", delim = ';') %>%
  # we need to rename some variables to remove whitespace
  rename(fixed.acidity = `fixed acidity`,
         volatile.acidity = `volatile acidity`,
         citric.acid = `citric acid`,
         residual.sugar = `residual sugar`,
         free.sulfur.dioxide = `free sulfur dioxide`,
         total.sulfur.dioxide = `total sulfur dioxide`) %>%
  # add a color variable for when we combine datasets, 1 = red, 0 = white
  mutate(color = 1)
# load the white wine quality dataset
white.df <-
  read_delim("winequality-white.txt", delim = ';') %>%
  # we need to rename some variables to remove whitespace
  rename(fixed.acidity = `fixed acidity`,
         volatile.acidity = `volatile acidity`,
         citric.acid = `citric acid`,
         residual.sugar = `residual sugar`,
         free.sulfur.dioxide = `free sulfur dioxide`,
         total.sulfur.dioxide = `total sulfur dioxide`) %>%
  # add color variable
  mutate(color = 0)

# create a variable to make our y-scale on our graphs consistent across graphs using the quality variable limits
y.scale <- scale_y_continuous(breaks = seq(0, 10, 1), limits = c(0, 10))

for(i in names(select(red.df, -c(quality, color)))) {
  print(i)
  # create a variable to make our x-scale consistent within our plot
  x.limits <- scale_x_continuous(limits = c(min(red.df[i], white.df[i]), max(red.df[i], white.df[i])))
  # save each graph to a variable so we can put them into our grid.arrange() function
  plot1 <-
    # plot for red wine, eval(parse(text = i)) turns the string i, which is the name of the variable,
    # into the actual variable
    ggplot(red.df, aes_(x = i, y = quote(quality))) +
    theme_bw() +
    ggtitle("Red Wine") +
    # we want to jitter values because quality is discrete, but we don't want to jitter continuous values
    geom_jitter(width = 0) +
    xlab(NULL) +
    x.limits +
    y.scale
  plot2 <-
    # plot for white wine. the variable names are the same for both datasets
    ggplot(white.df, aes_(x = i, y = quote(quality))) +
    theme_bw() +
    ggtitle("White Wine") +
    geom_jitter(width = 0) +
    ylab(NULL) +
    xlab(NULL) +
    x.limits +
    y.scale
  plot3 <-
    ggplot(red.df, aes_(x = i)) +
    theme_bw() +
    geom_density() +
    xlab(NULL) +
    x.limits
  plot4 <-
    ggplot(white.df, aes_(x = i)) +
    theme_bw() +
    geom_density() +
    xlab(NULL) +
    ylab(NULL) +
    x.limits
  
  # put down all the plots wanted on the page, ncol is the number of columns (2 plots per row)
  grid.arrange(plot1, plot2, plot3, plot4, bottom = i, ncol = 2)
}

wine.df <- rbind(red.df, white.df)

set.seed(34)

train.index <- createDataPartition(wine.df$quality, p = 0.8,
                                   list = FALSE, times = 1)

wine.train <-  wine.df[train.index, ]
wine.test <- wine.df[-train.index, ]

# attempt to develop a model that can be used to predict wine color
fitControl1 <- trainControl(...)
fit1 <- train(...,
             data = wine.train,
             trControl = fitControl1,
             ...)

fit1

# confusion matrix for determining misclassification error of model
confusionMatrix(predict(fit1, wine.test), wine.test$color)

# attempt to develop a model that can be used to predict wine quality
fitControl2 <- trainControl(...)
fit2 <- train(...,
              data = wine.train,
              trControl = fitControl2,
              ...)

fit2

# compare results given in fit to resample
postResample(pred = predict(fit2, wine.test), obs = wine.test$quality)