Visualization Beyond Two Variables
========================================================
author: Bailey Pleva
date: Wednesday, October 11th, 2017
width: 1700
height: 1000



Why
========================================================

Plotting two variables allows us to see potential
interactions between them, but what about when there
are more than 2 variables?

- 2 Variables per plot -> n(n-1)/2 plots
  - Space and attention intensive
  - Potentially miss details

Packages & Volcano Data
========================================================

x, y, z levels for a volcano

- Hard to see whole picture, literally
- Limited to x-by-z or y-by-z interactions

***

```r
require(reshape2)
require(dplyr)
require(ggplot2)
require(gridExtra)
require(lattice)
```

```r
volcano.df <-
  melt(volcano) %>%
  rename(x = Var1,
         y = Var2,
         z = value)
```

2D Profiles
========================================================

```r
p1 <- volcano.df %>%
  group_by(x) %>%
  slice(which.max(z)) %>%
  ggplot(aes(x = x, y = z)) +
  theme_bw() +
  geom_line()
p2 <- volcano.df %>%
  group_by(y) %>%
  slice(which.max(z)) %>%
  ggplot(aes(x = y, y = z)) +
  theme_bw() +
  geom_line()

grid.arrange(p1, p2, ncol = 2)
```
***
![plot of chunk unnamed-chunk-4](Visualization Intro-figure/unnamed-chunk-4-1.png)

Add Color (Raster Plot)
========================================================

```r
raster.plt <-
  ggplot(volcano.df,
         aes(x = x, y = y)) +
  theme_bw() +
  geom_raster(aes(fill = z))
```
***
![plot of chunk unnamed-chunk-6](Visualization Intro-figure/unnamed-chunk-6-1.png)

Contour
========================================================

```r
raster.plt +
  geom_contour(aes(z = z),
               color = "white",
               binwidth = 25)
```
***
![plot of chunk unnamed-chunk-8](Visualization Intro-figure/unnamed-chunk-8-1.png)

Facet
========================================================

```r
volcano.df %>%
  mutate(high_points = ifelse(z >= 160, 1, 0)) %>%
  ggplot(aes(x = x, y = z)) +
  theme_bw() +
  geom_raster(aes(fill = z)) +
  facet_wrap(~high_points)
```
***
![plot of chunk unnamed-chunk-10](Visualization Intro-figure/unnamed-chunk-10-1.png)

3D
========================================================

```r
wireframe(z ~ x*y, data = volcano.df,
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 0,
                        x = -45,
                        y = -6))
```
***
![plot of chunk unnamed-chunk-12](Visualization Intro-figure/unnamed-chunk-12-1.png)

Human Resources Data
========================================================

- Available at github.com/bavelp/nustataw
  - nustataw/ws1/hr.csv
- Company dataset on employees
  - (simulated)
- 10 Variables
  - 10*(10-1)/2 = 45 different 2-variable plots
  - (of single plot-type)

Types of Variables
========================================================

## Nominal Variables
- `sales`
- `left`
- `promotion_last_5years`
- `Work_accident`

## Ordinal Variable(s)
- `salary`

***

## Ratio Variables
- `satisfaction_level`
- `last_evaluation`
- `number_project`
- `average_montly_hours`
- `time_spend_company`

Task
========================================================

- The company is curious about why people might have left. We want to look for relationships between the `left` variable and all other variables. It would also help to look at interactions between these other variables. Develop visuals that can be used to tell a story about how these variables might be related.

- BONUS TASKS:
  - Develop a dashboard that allows somebody else to adjust your plots to look further into the data. Think about a model that could be applied to the dataset based upon relationships you see.
  
- File format:
  - When uploading your file to github, make sure to name it as "lastname1_lastname2_lastname3_code.R", replacing "lastname1" and such with your last name, and ending the file with the appropriate file ending. Make sure your code is readable and reproducible so that others can look through it.
  - Upload your file to nustataw/ws1/ws_code
