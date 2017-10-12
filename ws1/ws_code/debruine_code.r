 setwd("~/Desktop/NUSTATAW/nustataw/ws1")
 #HR <- read.csv("hr.csv")
 attach(HR)
 
require(reshape2)
require(dplyr)
require(ggplot2)
require(gridExtra)
require(lattice)
require(forcats)
 
#to rename variables
HR <-
  read.csv("hr.csv") %>%
  rename(work_accident = Work_accident,
         avg_monthly_hours = average_montly_hours,
         dept = sales) %>%
  mutate(salary = fct_infreq(salary))

#looking at ratio variables first:
#this was not helpful at all, too high density
pairs(~satisfaction_level+ last_evaluation+ number_project+ average_montly_hours+ time_spend_company, data=HR)

plt1 <- ggplot(HR, aes(x = satisfaction_level,
                       y = avg_monthly_hours,
                       color = left))

plt2 <- ggplot(HR, aes(x = satisfaction_level,
                       y = avg_monthly_hours,
                       color = number_project))
plt1 + geom_jitter()
plt2 + geom_jitter() + facet_wrap(work_accident~left) #what exactly does jitter do?
# seems like work accident didn't have much impact:
# subset of plots without that facet
plt2 + geom_jitter() + facet_grid(left~dept)
#also seems like department doesn't play much of a role

ggplot(HR, aes(x = satisfaction_level)) +
  geom_density() +
  facet_grid(~left)
#matches what we saw above

ggplot(HR, aes(x = promotion_last_5years,
               y = salary,
               color = left)) +
  geom_jitter()
# no one who had a promotion and has a high salary left

ggplot(HR, aes(x = satisfaction_level,
               y= avg_monthly_hours)) +
  geom_jitter() +
  facet_grid(promotion_last_5years~left)
#but wait! not many people have actually been promoted... 
#always look at multiple plots
#is there a way to look at # of data points?

#salary is an ordinal variable

#something must be causing the clustering???




# r shiny package to create a dashboard 