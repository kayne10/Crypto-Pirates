#Scott Schubert & Team
#Data mining
#Final  Project

setwd("/Users/schubydooo/Documents/GitHub/Crypto-Pirates/cryptocurrencypricehistory")
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
bitcoin = read.csv("bitcoin_price.csv")
head(bitcoin)

ethereum = read.csv("ethereum_price.csv")
head(ethereum)

dash = read.csv("dash_price.csv")

iota = read.csv("iota_price.csv")

litecoin = read.csv("litecoin_price.csv")

monero = read.csv("monero_price.csv")



#

#Linear model ------

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
#It appears many of the days are clumbed together, therefore it was certain times when the market was volatile 



#
#
# XG BOOST --------
#
#

#Start by filling in blank values with best guess.  Volume is empty for early bits of all datasets
#Method will be to take the min of data points available.
#Reasoning is a linear model will not be representative because the volume of trading has grown exponentially.
#And the thinking is the min of vaules will be close enough compared to an exponential plot guess.

'%!in%' <- function(x,y)!('%in%'(x,y))
bitcoin$Volume <- as.numeric(gsub(",", "", bitcoin$Volume))
bitcoin$Market.Cap <- as.numeric(gsub(",", "", bitcoin$Market.Cap))
bitcoin2 <- bitcoin[bitcoin$Volume %!in% NA,]
minVol = min(bitcoin2$Volume)
remove(bitcoin2)
bitcoin$Volume[is.na(bitcoin$Volume)] <- minVol


ethereum$Volume <- as.numeric(gsub(",", "", ethereum$Volume))
ethereum$Market.Cap <- as.numeric(gsub(",", "", ethereum$Market.Cap))
ethereum2 <- ethereum[ethereum$Market.Cap %!in% NA,]
minVol = min(ethereum2$Market.Cap)
remove(ethereum2)
ethereum$Market.Cap[is.na(ethereum$Market.Cap)] <- minVol

dash$Volume <- as.numeric(gsub(",", "", dash$Volume))
dash$Market.Cap <- as.numeric(gsub(",", "", dash$Market.Cap))

iota$Volume <- as.numeric(gsub(",", "", iota$Volume))
iota$Market.Cap <- as.numeric(gsub(",", "", iota$Market.Cap))

litecoin$Volume <- as.numeric(gsub(",", "", litecoin$Volume))
litecoin$Market.Cap <- as.numeric(gsub(",", "", litecoin$Market.Cap))
litecoin2 <- litecoin[litecoin$Volume %!in% NA,]
minVol = min(litecoin2$Volume)
remove(litecoin2)
litecoin$Volume[is.na(litecoin$Volume)] <- minVol

monero$Volume <- as.numeric(gsub(",", "", monero$Volume))
monero$Market.Cap <- as.numeric(gsub(",", "", monero$Market.Cap))

#Now convert Date to UnixTime since 1/1/1970 for all datasets so the date value can be feature engineering
#POSSIBLE further exploring would be to change date to be the date since crypto currency openened
bitcoin$Date <- as.numeric(as.POSIXct(bitcoin$Date, format="%B %d, %Y"))
ethereum$Date <- as.numeric(as.POSIXct(ethereum$Date, format="%B %d, %Y"))
dash$Date <- as.numeric(as.POSIXct(dash$Date, format="%B %d, %Y"))
litecoin$Date <- as.numeric(as.POSIXct(litecoin$Date, format="%B %d, %Y"))
monero$Date <- as.numeric(as.POSIXct(monero$Date, format="%B %d, %Y"))

