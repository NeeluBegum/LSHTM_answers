# LSHTM_answers
Answers for Gwen and Team

## TASK1

### ANSWER 2

I would assess the age stratification on resistant flows (orange highlighter) to each D, W and U. We can see the age range that is harbouring resistance and how this affects the other models. We could also go onto assess exposure rate and treatment options.

## TASK2

### ANSWER 3

Logistic model is essentially binary and it would be a good idea to use a generalised linear model (glm) to fit the data:

logistic_model <- glm(resistant_binary ~ age, data = data, family = binomial)

### ANSWER 4

Github upload

### ANSWER 5
I would love to know about treatment history as this will inform us about the risk of developing resistance and maybe we can see that use of antibiotics gives us higher resistance?
I would also love to add geographical location information to see urban and rural effects with resistance presence

We need to do some statistical analysis such as the significance of age-influencing resistance
Linear and logistic models are assuming that the variables are independent so it would be good to do some correlation modelling to see if there are any biased estimates in the modelling

### ANSWER 6

We could do possibly perform multivariate analysis using the data of the geographical location (my experience in invasive species adaptation) and resistance genes (give us more functional knowledge of following the resistant function trend on how this is being acquired) that this was assessed to understand the differences of effect we are seeing with resistance bacteria and age
