require(dplyr)
require(magrittr)
require(forcats)
require(ggplot2)
require(caret)

hr.data <- read.csv("hr.csv")

hr.data <-
  hr.data %>%
  mutate(left = as.factor(left),
         Work_accident = as.factor(Work_accident),
         promotion_last_5years = as.factor(promotion_last_5years),
         average_monthly_hours = average_montly_hours,
         dept = fct_rev(fct_infreq(sales)),
         salary = fct_infreq(salary),
         work_accident = Work_accident) %>%
  select(-c(average_montly_hours, sales, Work_accident))