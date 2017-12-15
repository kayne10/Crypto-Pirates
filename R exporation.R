#Scott Schubert & Team
#Data mining
#Final  Project

setwd("/Users/schubydooo/Documents/GitHub/Crypto-Pirates/cryptocurrencypricehistory")
rm(list = ls()) 
install.packages("xgboost")
require(xgboost)
library(ggplot2)




#

#Import the data

#
bitcoin = read.csv("bitcoin_price_rev.csv")
head(bitcoin)

ethereum = read.csv("ethereum_price_rev.csv")

dash = read.csv("dash_price_rev.csv")

iota = read.csv("iota_price_rev.csv")

litecoin = read.csv("litecoin_price_rev.csv")

monero = read.csv("monero_price_rev.csv")



#

#Linear model ------

#
#Initial trial
bitcoin.lmod <- lm(bitcoin$Close ~ bitcoin$Date)
summary(bitcoin.lmod)
plot(bitcoin$Open, bitcoin$Close, xlab = "Open", ylab = "Close", main = "Bitcoin: Open vs Close")
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

dat = litecoin
dat$PDifference = (dat$Close - dat$Open)/dat$Open
mean(dat$PDifference) #0.29% change expected per day
sd(dat$PDifference)  #4.3% sd 
datPOutliers <- dat[abs(dat$PDifference) > sd(dat$PDifference)*3,]
#This does in fact result in a wider spread of days of interest with many days from 2013-2017
#Largest % change was 41% on nov 18, 2013.  Woah!
#It appears many of the days are clumbed together, therefore it was certain times when the market was volatile 

#Add data frame indicating if the row is a percent outlier
dat["Outlier"] <- NA
dat$Outlier <- abs(dat$PDifference) > sd(dat$PDifference)*3

ggplot(dat,aes(x=Open,y=Close)) + geom_point(size=0.5) + geom_point(aes(col = Outlier)) + labs(title = "Bitcoin Open vs Close")
#+ geom_text(aes(label=ifelse(Outlier==TRUE,as.character(Date),'')),hjust=0,vjust=0)

#Plot how regular presence of outlier is 



#Correlation------

bit <- bitcoin$Close;
eth <- ethereum$Close;
cor(bit, eth)



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
#POSSIBLE further exploring would be to change date to be the date since crypto currency openened -> done
#Date field now indicates days since corresponding currency launched
bitcoin$Date <- (as.numeric(as.POSIXct(bitcoin$Date, format="%B %d, %Y"))-1230768000)/(24*60*60)
ethereum$Date <- (as.numeric(as.POSIXct(ethereum$Date, format="%B %d, %Y"))-1438214400+0)/(24*60*60)
dash$Date <- (as.numeric(as.POSIXct(dash$Date, format="%B %d, %Y"))-1390003200+0)/(24*60*60)
litecoin$Date <- (as.numeric(as.POSIXct(litecoin$Date, format="%B %d, %Y"))-1317945600+0)/(24*60*60)
monero$Date <- (as.numeric(as.POSIXct(monero$Date, format="%B %d, %Y"))-1396310400+0)/(24*60*60)

bitcoin <-  bitcoin[dim(bitcoin)[1L]:1,]
ethereum <-  ethereum[dim(ethereum)[1L]:1,]
dash <-  bitcoin[dim(dash)[1L]:1,]
litecoin <-  litecoin[dim(litecoin)[1L]:1,]
monero <-  monero[dim(monero)[1L]:1,]

#Combine data sets into singular large one? 

#Split the data into train and test
require(caTools)
set.seed(101) 
sample = sample.split(bitcoin, SplitRatio = .75)
train = subset(bitcoin, sample == TRUE)
test  = subset(bitcoin, sample == FALSE)




#Testing XGboost--------
#https://www.r-bloggers.com/forecasting-markets-using-extreme-gradient-boosting-xgboost/


install.packages("xgboost")
install.packages("quantmod")
install.packages("DiagrammeR")

# Load the relevant libraries
library(quantmod); library(TTR); library(xgboost);

#Split the data if needed
bitcoinSub = bitcoin[bitcoin$Close < 500,]


# Read the stock data 
df = bitcoin;
colnames(df) = c("Date","Open","High", "Low", "Close","Volume", "Market.Cap")

# Define the technical indicators to build the model 
rsi = RSI(df$Close, n=14, maType="WMA")
adx = data.frame(ADX(df[,c("High","Low","Close")]))
sar = SAR(df[,c("High","Low")], accel = c(0.02, 0.2))
trend = df$Close - sar

# create a lag in the technical indicators to avoid look-ahead bias 
rsi = c(NA,head(rsi,-1)) 
adx$ADX = c(NA,head(adx$ADX,-1)) 
trend = c(NA,head(trend,-1))

#Our objective is to predict the direction of the daily stock price change (Up/Down)
#using these input features. This makes it a binary classification problem. We compute 
#the daily price change and assigned a positive 1 if the daily price change is positive. 
#If the price change is negative, we assign a zero value.

# Create the target variable
price = df$Close-df$Open
class = ifelse(price > 0,1,0)

# Create a Matrix
model_df = data.frame(class,rsi,adx$ADX,trend)
model = matrix(c(class,rsi,adx$ADX,trend), nrow=length(class))
model = na.omit(model)
colnames(model) = c("class","rsi","adx","trend")


# Split data into train and test sets 
train_size = 0.9
breakpoint = nrow(model) * train_size

training_data = model[1:breakpoint,]
test_data = model[(breakpoint+1):nrow(model),]

# Split data training and test data into X and Y
X_train = training_data[,2:4] ; Y_train = training_data[,1]
class(X_train)[1]; class(Y_train)

X_test = test_data[,2:4] ; Y_test = test_data[,1]
class(X_test)[1]; class(Y_test)

# Train the xgboost model using the "xgboost" function
dtrain = xgb.DMatrix(data = X_train, label = Y_train)
#xgModel = xgboost(data = dtrain, nround = 5, objective = "binary:logistic")
xgModel = xgboost(data = dtrain, nround = 5, objective = "reg:linear")

# Using cross validation
dtrain = xgb.DMatrix(data = X_train, label = Y_train)
cv = xgb.cv(data = dtrain, nround = 10, nfold = 10, objective = "binary:logistic")
#cv = xgb.cv(data = dtrain, nround = 10, nfold = 5, objective = "reg:linear")

# Make the predictions on the test data
preds = predict(xgModel, X_test)

# Determine the size of the prediction vector
print(length(preds))

# Limit display of predictions to the first 6
print(head(preds))

prediction = as.numeric(preds > 0.5)
print(head(prediction))

# Measuring model performance
error_value = mean(as.numeric(preds > 0.5) != Y_test)
print(paste("test-error=", error_value))

# View feature importance from the learnt model
importance_matrix = xgb.importance(model = xgModel)
print(importance_matrix)

# View the trees from a model
xgb.plot.tree(model = xgModel)

# View only the first tree in the XGBoost model
xgb.plot.tree(model = xgModel, n_first_tree = 0)

