
##Import the data set in global environment 
Faltoons <- read.csv("C:\\Users\\KIIT\\Desktop\\assignment2021\\Data Science Assignment_LeepsaMahankud\\Hypothesis Testing\\Faltoons.csv")

### Hypothesis testing for male & female presence in store 
#### H0: mu_weekday = mu_weekend & 
###  Ha: mu_weekday != mu_weekend

## Extracting wekkdays & weekends days from faltoons dataset by slicing them 
x <- c(Faltoons$Weekdays)
x <- as.numeric(factor(x))
x
table(x)

y <- c(Faltoons$Weekend)
y <- as.numeric(factor(y))
y
table(y)

## Connducting t test for getting t value
Walk_pref <- t.test(x,y,alternative = 'two.sided', conf.level = 0.95 )
Walk_pref

## Find P value 
p <- 2*pt(-4.0384,791.47)
p

## Conducting proportion test 
table(x,y)
WD_WK <- prop.test(table(x,y), correct=TRUE) 
WD_WK


## As per above algorithm received p-value is less than 0.05 
#  then we reject null hypothesis or we can say that male & female are not similarly
#  walk in store on weekdays & weekends. 
