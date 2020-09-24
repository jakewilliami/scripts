#!/usr/bin/env Rscript

# install.packages("pacman")
library(pacman)
pacman::p_load(tidyverse, readr, psyphy, ggplot2)

# df <- read.csv("motion_coherence_data.csv", header=TRUE, skip=3)
df <- read_csv("motion_coherence_data.csv", skip = 3)

df2 <- df %>%
  select(correct, condition1) %>%
  transmute(y = as.integer(correct),
            x = condition1)

m_p <- glm(y ~ 1 + x, data = df2, family = binomial(link = mafc.probit(2)))
m_l <- glm(y ~ 1 + x, data = df2, family = binomial(link = mafc.logit(2)))


    ## The output of coef(m_l) is -2.7 and 14.2.

    ## When the condition is 0, the expected log-odds of being correct is -2.7. When you increase the condition value by 1, the log-odds of being correct increase by 14.2.

    ## When the condition is 0, the expected probabilityof being correct is g_inv(-2.7) = 0.53. When you increase the condition value by 1, the probability of being correct increases to g_inv(-2.7+14.2)=0.999... This makes sense considering that a condition of 1 means that all dots are moving in the same direction.

    ## But a step size of 1 doesn\'t really mean much in your data, since the x values only go up to 0.32.

    ## So we can calculate the log-odds of being correct at condition=0.2 as -2.7 + 14.2*(0.2) = 0.111. Verify this by calling the following:

x02 <- predict(m_l, data.frame(x = 0.2))

    ## To translate it to the probability scale, we use the inverse link function!  That is:

predicted_prob <- predict(m_l, data.frame(x = 0.2), type = "response")


myTheme <- theme(plot.title = element_text(family = "Helvetica", face = "bold", size = (15)),
    axis.title = element_text(family = "Helvetica", size = (10), colour = "steelblue4"),
    axis.text = element_text(family = "Courier", colour = "cornflowerblue", size = (10)))


# 2afc probit link
p <- function(x) 0.5 + 0.5 * pnorm(x)
# 2afc logit link
l <- function(x) 0.5 + 0.5 * plogis(x)


# get the coefficients
a_p <- coef(m_p)[1]
b_p <- coef(m_p)[2]
a_l <- coef(m_l)[1]
b_l <- coef(m_l)[2]


df2 %>%
  group_by(x) %>%
  summarise(p = mean(y)) %>%
  ggplot(aes(x, p)) +
  geom_point(size = 4, shape = 1) +
  stat_function(fun = function(x) p(a_p + b_p*x),
                aes(color = "Probit")) +
  stat_function(fun = function(x) l(a_l + b_l*x),
                aes(color = "Logit")) +
  labs(x = "Coherence",
       y = "Accuracy",
       color = "Fitted Curve") +
  scale_y_continuous(limits = c(0, 1))
