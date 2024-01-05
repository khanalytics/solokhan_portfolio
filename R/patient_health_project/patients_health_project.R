### Mohammad Khan
### Part 1: Hospital patients Data Analysis


### 
### Make sure the BRFSS2015_650.csv file is in the same folder as your RScript
### file (BRFSS2015.R). In RStudio, set your Working Directory to your Source 
### File location and then read the data into the brf object using read_csv().
###
brf <- read_csv("BRFSS2015_650.csv", show_col_types = FALSE)

# spec(brf)
#head(brf, 10)

### 
### Q1: How many people reported their general health is excellent?
###     The answer should be assigned to Q1.
### 

# excellent is masked as dbl 1
excellent <- brf %>%
  filter(GENHLTH == 1) %>%
  count()


Q1 <- excellent
#Q1  
      
### 
### Q2: What is the highest value for the number of adult women in the 
###     household where someone has ever had a stroke? Summarise the value in 
###     a variable called max_num_women. 
###     The output should be a dataframe assigned to Q2.
### 

#checking for values in NUMWOMEN col
#table(brf$NUMWOMEN)


# Filter for stroke patients and select NUMWOMEN max value. Stroke = 1

filter_stroke <- brf %>%
  filter(CVDSTRK3 == 1) %>%
  filter(!is.na(NUMWOMEN)) %>%
  summarise(max_num_women = max(NUMWOMEN)) %>%
  as.data.frame()


Q2 <- filter_stroke
#Q2


### 
### Q3: Compute the mean and standard deviation for MENTHLTH comparing 
###     caregivers who managed personal care such as giving medications, 
###     feeding, dressing, or bathing and those who did not. The summary 
###     variable names should be mean_mental and sd_mental. 
###     The output should be a dataframe assigned to Q3.
### 

# Filter for caregivers(1,2) and group them, change MENTHLTH 88 values to 0 for calculations
# Filter for only day values in MENTHLTH
# Calculate mean and standard deviation

filter_mental <- brf %>%
  filter(CRGVPERS == 1 | CRGVPERS == 2) %>%
  mutate(MENTHLTH = ifelse(MENTHLTH == 88, 0, MENTHLTH)) %>%
  filter(MENTHLTH >= 0 & MENTHLTH <= 30) %>%
  group_by(CRGVPERS) %>%
  summarise(
    mean_mental = round(mean(MENTHLTH),2),
    sd_mental = round(sd(MENTHLTH),2)) %>%
  as.data.frame()


Q3 <- filter_mental
#Q3

  
### 
### Q4: What is the median age when respondents were told they had diabetes 
###     for those living in Pennsylvania? Only calculate it for those who gave 
###     an age. The summary variable name should be med_diab_age.
###     The output should be a dataframe assigned to Q4.
### 

###  Filter for respondents with diabetes and living in Pennsylvania(code =42), 
###  age values only. Calculate median age

filter_diab <- brf %>%
  filter(`_STATE` == 42 & DIABAGE2 >= 1 & DIABAGE2 <= 97 ) %>%
  summarise(med_diab_age = round(median(DIABAGE2),2)) %>%
  as.data.frame()
        

Q4 <- filter_diab   
#Q4

# Boxplot showing median diabetic age around 55
# ggplot(filter_diab, aes(y = DIABAGE2)) +
# geom_boxplot() 




### 
### Q5: Predict the number of days in the past 30 days that mental health was 
###     not good from marital status. Keep in mind that one of the possible 
###     answers to “how many days” is 0, not just 1-30. Make sure you know what 
###     type of variable MARITAL is. You’ll need to consider this when 
###     determining how to do linear regression with it.
###     Assign the summary of the model to Q5. 
###     Note: The general instructions say to round all output but the summary()
###           of a model is not able to be rounded. 
### 

# Filter days considering 0 days also change numeric marital values to 
# categorical values for linear regression
filter_marital <- brf %>%
  mutate(MENTHLTH = ifelse(MENTHLTH == 88, 0, MENTHLTH)) %>%
  filter(MENTHLTH >= 0 & MENTHLTH <= 30) %>%
  filter(MARITAL %in% c("1", "2", "3", "4", "5", "6"))



# Make regression model and summarize findings
marital_model <- lm(MENTHLTH ~ MARITAL, data = filter_marital)

Q5 <- summary(marital_model)
#Q5


### 
### Q6: Use summarise to compare the mean number of days in the past 30 days 
###     that mental health was not good by marital status. The summary variable 
###     name should be mean_mental. The mean value for marital status 1 should 
###     help you to confirm the intercept value from Q5. 
###     The output should be a dataframe assigned to Q6.
### 

# mean days by martial status groups reusing previous filter

mean_status  <- filter_marital %>%
  group_by(MARITAL) %>%
  summarise( mean_mental = round(mean(MENTHLTH),2)) %>%
  as.data.frame()

Q6 <- mean_status
#Q6

### 
### Q7: Calculate the means and standard deviations of MENTHLTH for those who 
###     have ever been diagnosed with a stroke and those who have not had a 
###     stroke only for those who do not have any kind of healthcare coverage. 
###     The summary variable names should be mean_mental and sd_mental.
###     The output should be a dataframe assigned to Q7.
### 

# Filter for respondents who have no healthcare coverage(No = 2) HLTHPLN1
# also who had/ did not have stroke( Yes= 1, No = 2) CVDSTRK3

filter_stroke <- brf %>%
  filter( HLTHPLN1 == 2) %>%
  filter( CVDSTRK3 == 1 | CVDSTRK3 == 2) %>%
  mutate(MENTHLTH = ifelse(MENTHLTH == 88, 0, MENTHLTH)) %>%
  filter(MENTHLTH >= 0 & MENTHLTH <= 30) %>%
  group_by(CVDSTRK3) %>%
  summarise(
    mean_mental = round(mean(MENTHLTH, na.rm = TRUE),2),
    sd_mental = round(sd(MENTHLTH, na.rm = TRUE),2)) %>%
  as.data.frame()

Q7 <- filter_stroke
#Q7

### 
### Q8: Each respondent was asked if they participated in any physical 
###     activities in the past month. They were then asked what physical 
###     activity they spent the most time doing (or did the most) in the past 
###     month. Next, they were asked how many times per week or per month they 
###     took part in that exercise/activity. Run an ANOVA comparing how many 
###     times per week they took part in that exercise/activity with marital 
###     status. You may need to do some research on how to do this in R. 
###     Assign the summary of the ANOVA to Q8. Use aov() not anova().
###     Note: the general instructions say to round all output but the summary 
###           of an ANOVA  is not able to be rounded.
### 

### EXEROFT1 weekly values (101-199) changed to omit 1 in front, change marital
# to categorical for regression

filter_aov <- brf %>%
  
  mutate(MARITAL = factor(MARITAL, levels = c(1, 2, 3, 4, 5, 6))) %>%
  mutate(EXEROFT1 = (ifelse(EXEROFT1 >= 101 & EXEROFT1 <= 199, (EXEROFT1-100),EXEROFT1))) %>%
  filter(EXEROFT1 >= 1 & EXEROFT1 <= 99)

#table(brf$EXEROFT1)
#table(filter_week$EXEROFT1)

Q8 <-summary(aov(EXEROFT1 ~ MARITAL, data = filter_aov))



### 
### Q9: Consider only men for the following question. Each respondent was 
###     asked if they participated in any physical activities in the past month.
###     They were then asked what physical activity they spent the most time 
###     doing (or did the most) in the past month. Respondents were also asked 
###     to consider the past 30 days and answer either a) how many days per week
###     or b) how many days per month did they have at least one drink of any 
###     alcoholic beverage. For each type of physical activity or exercise, 
###     calculate the variance of the number of days per week a respondent 
###     drank alcohol. Note: pay careful attention to how values are coded in 
###     the Codebook. The summary variable name should be called var_drinks.
###     Arrange in descending order, and include only the six with the highest 
###     variance in drinks.
###     The output should be a dataframe assigned to Q9.
###

### Filter : Men(Male = 1),omit 1 from ALCDAY5 values,888 values = 0 drinks/week
### Find variance alcohol drank per week  grouped by exercise type(EXRACT11)
### Arrange desc order 6 highest variance

#table(brf$ALCDAY5)

filter_var <- brf %>%
  mutate(ALCDAY5 = ifelse(ALCDAY5 >= 101 & ALCDAY5 <= 199, ALCDAY5 - 100,
                                 ifelse(ALCDAY5 == 888, 0, ALCDAY5 ))) %>%
  filter(SEX == 1 & ALCDAY5 >= 0 & ALCDAY5 <= 99) %>%
  group_by(EXRACT11) %>%
  summarise(var_drinks = round(var(ALCDAY5),2)) %>%
  arrange(desc(var_drinks)) %>%
  head(6) %>%
  as.data.frame()
  
#table(filter_var$ALCDAY5)

Q9 <- filter_var


### Part 2: FEATURE MODELING
# Predicting patients sex (Male or Female) based on height,weight and smoking habits. 


###############################################################################
#    Q10:                                                               
###############################################################################

#   For this part of project, I will choose 4 variables:
#     Predictors = HEIGHT3, WEIGHT2, SMOKE100 
#     Response = SEX
#   HEIGHT3,WEIGHT2, SMOKE100 will be use to predict the response, SEX(Male or Female)

#   I am outlining the values used for each variable below:


#     About how tall are you without shoes? (If respondent answers in metrics, put a 9 in the first column)[Round
#     fractions down.]
#     In the original data set, HEIGHT3 uses metric system(meters) and imperial system(foot). ONLY imperial
#     values are used for this project(missing,refused,unsure data points are also excluded): 
#     Height (ft/inches) Notes: 0 _ / _ _ = feet / inches, VALUES range: 200-711 (2 feet - 7 feet 11 inches).

#     About how much do you weigh without shoes? (If respondent answers in metrics, put a 9 in the first column)
#     [Round fractions up.]
#     WEIGHT2 variable also includes data from metric and imperial. ONLY imperial
#     values are used for this project(missing,refused,unsure data points are also excluded):
#     Weight (pounds) Notes: 0 _ _ _ = weight in pounds , VALUES range: 50 - 0999 (50lbs - 999 lbs)

#     The question asked to respondents for SMOKE100: Have you smoked at least 100 cigarettes in your entire life? 
#                                                                         [Note: 5 packs = 100 cigarettes] 
#     Two values for SMOKE100 used for this project : YES(smoked) = 1, NO(Did not smoke) = 2, all other values excluded

#     For respondent's SEX only two different values : Male = 1, Female = 2. 
#     The predictors will be used to predict the respondent's SEX

clean_data <- brf %>%
  filter((HEIGHT3 >= 200 & HEIGHT3 <= 711) & 
           (WEIGHT2 >=50 & WEIGHT2 <= 999) & 
           (SMOKE100 == 1 | SMOKE100 == 2 )) %>%
  select(HEIGHT3, WEIGHT2, SMOKE100, SEX)

print(clean_data)

###############################################################################
#    Q11:                                                               
###############################################################################

# Identify outliers outside of -3 standard deviations(SD) and +3SD:
# 99.7% of data included : 0.15 % Outliers in Upper portion of data and 
# 0.15% Outliers in Lower portion of data are exluded.



# Set up upper and lower boundary for each variable then remove outliers that dont fall in range
# WEIGHT2 and HEIGHT3 are continuous variables  
# SMOKE100 and SEX are binary so no outlier calculations were performed

# WEIGHT2
weight_upper <- quantile(clean_data$WEIGHT2, 0.9985)
print(weight_upper)
weight_lower <- quantile(clean_data$WEIGHT2, 0.0015)
print(weight_lower)

# Outliers to remove from WEIGHT2

weight_out<- which( clean_data$WEIGHT2 > weight_upper |  clean_data$WEIGHT2 < weight_lower)

# Checked for Percent remaining on weight variable
#percent_weight <- (nrow(clean_data) - length(weight_out))/ nrow(clean_data) *100


# HEIGHT3
height_upper <- quantile(clean_data$HEIGHT3, 0.9985)
print(height_upper)
height_lower <- quantile(clean_data$HEIGHT3, 0.0015)
print(height_lower)

# Outliers to remove from HEIGHT3

height_out <- which( clean_data$HEIGHT3 > height_upper |  clean_data$HEIGHT3 < height_lower)

# Checked for Percent remaining on height variable
#percent_height <- (nrow(clean_data) - length(height_out))/ nrow(clean_data) *100
#percent_height


# Unique indices were filtered out from weight and height variables so no 
# conflict of indices

outliers <- unique(c(weight_out, height_out))


# Made new variable excluding all outliers. THIS dataset will be used for rest of questions

dataset <-clean_data[-outliers,]
print(dataset)


###############################################################################
#    Q12:                                                               
###############################################################################

# Created bar plots for SMOKE100 and SEX to show distribution between the two binary values
# Values changed from numeric to categorical using factor on columns 
# and scale_x_discrete() to manually change labels on graph

# SMOKE100 distribution shows there are more nonsmokers than smokers
smoke100_bar <-
  ggplot(dataset) +
  geom_bar(mapping = aes(x = factor(SMOKE100)), fill = 'orange') +
  scale_x_discrete(labels = c("1" = "YES", "2" = "NO"))

print(smoke100_bar)

# SEX distribution show there are more female than male respondents
sex_distribution <-
  ggplot(dataset) +
  geom_bar(mapping = aes(x = factor(SEX)),fill = "purple") +
  scale_x_discrete(labels = c("1" = "Male", "2" = "Female"))


print(sex_distribution)


# Created boxplots for WEIGHT2 AND HEIGHT3 based on SEX differences

# WEIGHT2 boxplots shows clear differences in weight between males and females.
# Males had significantly higher weight medians than females 
# Outliers outside the 4 quartiles for both males and females still present

weight_plot <-
  ggplot(dataset) +
  geom_boxplot(mapping = aes(x = factor(SEX), y = WEIGHT2)) +
  scale_x_discrete(labels = c("1" = "Male", "2" = "Female"))

print(weight_plot)

# HEIGHT3 boxplots also show clear differences median differences in height 
# between males and females. Males median height is bigger than females median height.
# Females seem to have extreme outliers on both sides of boxplot.

height_plot <-
  ggplot(dataset) +
  geom_boxplot(mapping = aes(x = factor(SEX), y = HEIGHT3)) +
  scale_x_discrete(labels = c("1" = "Male", "2" = "Female"))

print(height_plot)

###############################################################################
#    Q13:                                                               
###############################################################################

# These are few of the many possible descriptive satistic questions explored below to check for any further differences 
# in variables:

#### Calculate the mean, median, standard deviations, variance of both height and weight variables.

desc_stats <- dataset %>%
  summarise(mean_weight = mean(WEIGHT2),
            median_weight = median(WEIGHT2),
            sd_weight = sd(WEIGHT2),
            var_weight = var(WEIGHT2),
            
            mean_height = mean(HEIGHT3),
            median_height = median(HEIGHT3),
            sd_height = sd(HEIGHT3),
            var_height = var(HEIGHT3))

print(desc_stats) 


#### What are the average height and weight grouped by smoke100?

avg_smoker <- dataset %>%
  group_by(SMOKE100) %>%
  summarise(
    avg_height = mean(HEIGHT3),
    avg_weight = mean(WEIGHT2))

print(avg_smoker)

# There seems be not big differences in height and weight based on whether 
# respondents smoked or not.




#### What are the average height and weight of smokers vs non-smokers grouped by sex?

# Filter for smoker(1=YES), MALE=1, FEMALE = 2


smoker_x <-dataset %>%
  filter(SMOKE100 == 1) %>%  
  group_by(SEX) %>%
  summarise(
    avg_height = mean(HEIGHT3),
    avg_weight = mean(WEIGHT2))

print(smoker_x)



smoker_y <-dataset %>%
  filter(SMOKE100 == 2) %>%  
  group_by(SEX) %>%
  summarise(
    avg_height = mean(HEIGHT3),
    avg_weight = mean(WEIGHT2))

print(smoker_y)

# Results further shows not too much difference in height or weight based on smoking or not



#### What percent of males are smokers vs what percent of females are smokers among all smokers?



# Male=1, Female = 2 
smoker_pct <- dataset %>%
  filter(SMOKE100 == 1) %>%  
  group_by(SEX) %>%
  summarise(
    count = n()
  ) %>%
  mutate(
    pct = (count / sum(count)) * 100) %>%
  select(SEX, pct)

print(smoker_pct)

# The percentage of male and female smokers are close both close to 50%


###############################################################################
#    Q14:                                                               
###############################################################################

# Conducted 3 logistic regressions models to predict for SEX based on different predictors
# Inside summary of models:
# Deviance residuals show model fit, closer to zero = better fit
# Coefficients show log odds for each predictor, standard error and P-value(significance)
# AIC is used to compare different models of same datset. Lower score shows better fitting model


# Since log regressions requires 0,1 values SEX (1,2) values were reassigned. 
# Male is now 0 and Female is 1 

dataset$SEX[dataset$SEX == 1] <- 0
dataset$SEX[dataset$SEX == 2] <- 1


# Predicted SEX based on height 

height_model <- glm(SEX ~ HEIGHT3, data=dataset, family=binomial)
print(summary(height_model))

# Predicted SEX based on height and weight

htwt_model <- glm(SEX ~ HEIGHT3+ WEIGHT2, data=dataset, family=binomial)
print(summary(htwt_model))

# Predicted SEX based on height,weight, and smoker/non-smoker

htwtsmk_model <- glm(SEX ~ HEIGHT3 + WEIGHT2 + SMOKE100, data=dataset, family=binomial)
print(summary(htwtsmk_model))



# Discussion on Findings: 

# All three models looked to have decent model fit, based on close to zero deviance residuals
# in 1st,median, 3rd quartile but min and max values were high for all three model also. 

# The log odds indicate odds of being a male(the reference category) based on 1 unit increase 
##   For HEIGHT3: with one unit increase in height, the log odds of being male decrease by 0.18   
##   For WEIGHT2: with one unit increase in weight, the log odds of being male decreases by 0.01 
##   For SMOKE100: Those who smoke have 0.39 log odds chance of being male compared to those who dont smoke
# All the variables are statistically significant  with their p-value being close to zero

# AIC Score is the lowest for when all three variables were predicted(HEIGHT3 + WEIGHT2 + SMOKE100) for SEX,
# but the scores are not too far apart. 
## AIC Scores (For weight only predictor: 379084   vs all three: 376647)  2,437 score difference.
## So the AIC scores show that for this dataset, three variables model(htwtsmk_model) is better quality among the
## other two models.
## 

## One thing to note, increasing the number of predictors may lead to over fitting data, where new datasets might not
## perform well on these model.

