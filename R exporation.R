#Scott Schubert & Team
#Data mining
#Final  Project

setwd("/Users/schubydooo/Documents/GitHub/Crypto-Pirates")
rm(list = ls()) 
install.packages("xgboost")
require(xgboost)
library(readr)
library(stringr)
library(caret)
library(car)


#

#Import the data

#
bitcoin = read.csv("Datasets/bitcoin_price.csv")
head(bitcoin)

ethereum = read.csv("Datasets/ethereum_dataset.csv")
head(ethereum)

plot(bitcoin)


#

#Linear model

#
#Initial trial
bitcoin.lmod <- lm(bitcoin$Close ~ bitcoin$Open)
summary(bitcoin.lmod)
plot(bitcoin$Open, bitcoin$Close, xlab = "Open", ylab = "Close", main = "Open vs Close")
abline(bitcoin.lmod, col = "red")
#Unsurprisingly, there is strong correlation between open and close with 99.6% of variation explained
#The dots further from our linear abline would be interesting to explore as they denote lines such that 
#the stock value of bitcoin changed beyond the norm

#
#Add a new column to denote change - for outlier analysis
#
bitcoin$Difference = bitcoin$Close - bitcoin$Open
mean(bitcoin$Difference) #Mean of 2.48 change per day
sd(bitcoin$Difference)  #sd of 53.58
#Outlier boundary is therefore 160.74
bitcoinOutliers <- bitcoin[abs(bitcoin$Difference) > sd(bitcoin$Difference)*3,]
#Very interesting to note that days this outlier change is witnessed are almost exclusively in 2017, with 2 days from 2013.
#Most likely due to fact that the true outlier boundary should change with time
#Might be more interesting to explore outlier in terms of percent change rather than value changed 


bitcoin$PDifference = (bitcoin$Close - bitcoin$Open)/bitcoin$Open
mean(bitcoin$PDifference) #0.0029% change expected per day
sd(bitcoin$PDifference)  #0.043% sd 
bitcoinPOutliers <- bitcoin[abs(bitcoin$PDifference) > sd(bitcoin$PDifference)*3,]
#This does in fact result in a wider spread of days of interest with many days from 2013-2017
#Largest % change was 41% on nov 18, 2013.  Woah!





