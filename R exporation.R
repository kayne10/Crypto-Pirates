#Scott Schubert & Team
#Data mining
#Final  Project

setwd("/Users/schubydooo/Documents/GitHub/Crypto-Pirates")
rm(list = ls()) 
install.packages("xgboost")
require(xgboost)


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


