### Mohammad Khan
### Clear memory
###
rm(list = ls())

suppressPackageStartupMessages(library(tidyverse))

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


