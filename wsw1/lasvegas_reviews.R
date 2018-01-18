setwd("~/programming/r_programs/lasvegas")

require(dplyr)
require(magrittr)
require(ggplot2)
require(caret)
require(MASS)
# NOTE: select() is a function that appears both in dplyr and MASS
# I want the select() from dplyr, so I write...
select <- dplyr::select

reviews <-
  read.csv("LasVegasTripAdvisorReviews-Dataset.csv", sep = ';') %>%
  as_tibble %>%
  select(-c(Pool, Gym, Tennis.court, Spa, Casino, Free.internet,
            Hotel.stars, Nr..rooms)) %>%
  mutate(Score = ordered(Score, levels = c(1, 2, 3, 4, 5),
                         labels = c('S1', 'S2', 'S3', 'S4', 'S5')))

summary(reviews)

ggplot(reviews, aes(x = Nr..reviews, y = Score)) +
  geom_jitter()

ggplot(reviews, aes(x = Nr..hotel.reviews, y = Score)) +
  geom_jitter()

ggplot(reviews, aes(x = Nr..hotel.reviews/Nr..reviews, y = Score)) +
  geom_jitter()

reviews %>%
  filter(Nr..hotel.reviews/Nr..reviews > 1 | Nr..hotel.reviews == 0)

reviews %<>%
  mutate(Nr..hotel.reviews = ifelse(Nr..hotel.reviews > Nr..reviews |
                                      Nr..hotel.reviews == 0,
                                    NA, Nr..hotel.reviews))

ggplot(reviews, aes(x = Nr..hotel.reviews/Nr..reviews, y = Score)) +
  geom_jitter()

reviews.miss <-
  reviews %>%
  filter(is.na(Nr..hotel.reviews))

reviews.pres <-
  reviews %>%
  filter(!is.na(Nr..hotel.reviews))

ks.test(as.integer(reviews.miss$Score), as.integer(reviews.pres$Score))

reviews <- reviews.pres

rm(reviews.miss, reviews.pres)

nearZeroVar(reviews, saveMetrics = TRUE)

set.seed(4)

train.index <- createDataPartition(reviews$Score, p = 0.8,
                                   list = FALSE, times = 1)

reviews.train <-  reviews[train.index, ]
reviews.test <- reviews[-train.index, ]

fitControl <- trainControl(method = "repeatedcv",
                           number = 10, repeats = 10,
                           classProbs = TRUE,
                           summaryFunction = multiClassSummary)

fit <- train(Score ~ Nr..hotel.reviews + Period.of.stay, 
             data = reviews.train,
             trControl = fitControl,
             method = "polr",
             tuneGrid = expand.grid(method = 'probit'),
             metric = 'ROC')

confusionMatrix(predict(fit, reviews.test), reviews.test$Score)
