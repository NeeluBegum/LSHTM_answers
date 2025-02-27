setwd("/Users/nb3608/Desktop/LSHTM/Test/")

library(tidyverse)
library(ggplot2)
install.packages("deSolve")
library(deSolve)
library(dplyr)


#####TASK 1

natural_history <- function(times, states, parameters) {
  with(as.list(c(states, parameters)), {
    N = U + S + D + R + W + M
    
    foi_S = beta * (S + alpha * D + M) / N
    foi_R = beta * f * (R + (1-alpha) * D + W) / N
    
    dU = dur * N - U * (foi_S + foi_R) + gamma_s * (t * S + M) + gamma_r * (t * R + W + t * D) - dur * U
    dS = U * foi_S - gamma_s * t * S - theta * S - foi_R * S  - dur * S 
    dD = foi_R * S + foi_S * R - foi_R * D  - (gamma_s + gamma_r) * t * D - dur * D 
    dR = (U + D) * foi_R  - foi_S * R - gamma_r * t * R - theta * R + gamma_s * t * D  - dur * R 
    dW = theta * R - gamma_r * W - dur * W
    dM = theta * S - gamma_s * M  - dur * M
    
    list(c(dU, dS, dD, dR, dW, dM))
  })
} 

states <- c(U = 1240,
            S = 250,
            D = 45,
            R = 10, 
            W = 2,
            M = 3)

parameters <- c(beta = 0.6,  ## transmission parameter
                alpha = 0.5, ## reduced transmission from dual carriage 
                f = 0.8, ## relative fitness of resistant strain 
                
                gamma_s = 0.8, ## antibiotic exposure rate with susceptible effective drugs
                gamma_r = 0.7, ## antibiotic exposure rate with resistant effective drugs
                t = 0.5,  ## relative lower exposure of treatment for colonised 
                
                theta = 0.01, ## progression to infection rate from colonisation 
                dur = 1 / 8 ## average length of stay
)

run <- as.data.frame(ode(func = natural_history, 
                         y = states, 
                         parms = parameters, 
                         times = seq(0,1500,1))) %>% 
  pivot_longer(cols = "U":"M")

ggplot(run, aes(x = time, y = value, group = name)) + geom_line(aes(col = name), lwd = 2)
#ggplot(run, aes(x = time, y = value, group = name)) + geom_line(aes(col = name), lwd = 2) + scale_y_continuous(lim = c(0,100))


#####•••••••••••••••••••••••••••••••••••
#### TASK 2
# Load data
data <- read.delim("test_data_fship.csv", header=T, sep = ",", row.names = NULL, as.is=TRUE)



##### ANSWER 1
resistant_proportion <- data %>%
  group_by(bacteria, age) %>%
  summarise(
    total_cases = n(),
    resistant_cases = sum(result == "1"),
    prop_resistant = resistant_cases / total_cases
  ) %>%
  ungroup()

ggplot(resistant_proportion, aes(x = age, y = prop_resistant, color = bacteria)) +
  geom_line(size = 1) +  # Line plot
  geom_point(alpha = 0.7) +  # Points for better visualization
  theme_minimal() +
  labs(
    title = "Proportion of Antibiotic-Resistant Infections by Age",
    x = "Age",
    y = "Proportion Resistant",
    color = "Bacteria"
  ) +
  theme(legend.position = "right")



##### ANSWER 2
#1  LOGISTIC REGRESSION MODEL based on age
data$resistant_binary <- ifelse(data$result == "1", 1, 0)
logistic_model <- glm(resistant_binary ~ age, data = data, family = binomial)

data$predicted_prob <- predict(logistic_model, type = "response")

ggplot(data, aes(x = age, y = predicted_prob)) +
  geom_point(alpha = 0.3) +  # Actual data points
  geom_smooth(method = "glm", method.args = list(family = binomial), color = "red") +
  theme_minimal() +
  labs(title = "Logistic Regression: Probability of Resistance by Age",
       x = "Age",
       y = "Predicted Probability of Resistance")

# 2 LINEAR REGRESSION MODEL based on age
age_resistance <- data %>%
  group_by(age) %>%
  summarise(
    prop_resistant = mean(result == "1"))

linear_model <- lm(prop_resistant ~ age, data = age_resistance)

ggplot(age_resistance, aes(x = age, y = prop_resistant)) +
  geom_point() +  # Actual data points
  geom_smooth(method = "lm", color = "blue") +
  theme_minimal() +
  labs(title = "Linear Regression: Proportion of Resistance by Age",
       x = "Age",
       y = "Proportion Resistant")

##### ANSWER 3

# Logistic model is essentially binary and it would be a good idea to use generalised linear model (glm) to fit the data
logistic_model <- glm(resistant_binary ~ age, data = data, family = binomial)

#### ANSWER 4

#Github upload

##### ANSWER 5
#I would love to know about treatment history as this will inform us about risk of developing resistance and maybe we can see that use of antibiotics gives us higher resistance?
#I would also love to add geographical location information to see urban and rural effect with resistance presence

#We need to do some statistical analysis such as significance of age influencing resistance
#Linear and logistic models are assuming that the variables are independent so it would be good to do some correlation modelling to see if there is any biased estimates in the modelling

##### ANSWER 6

#We could do possibly multivariate analysis using the data of the geographical location (my experience in invasive species adaptation) and resistance genes (give us more functional knowledge of following the resistant function trend on how this is being acquired) that this was assessed in order to understand the differences of effect we are seeing with resistance bacteria and age

