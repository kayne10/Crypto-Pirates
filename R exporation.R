#Scott Schubert & Team
#Data mining
#Final  Project

setwd("/Users/schubydooo/Documents/GitHub/Crypto-Pirates")
rm(list = ls()) 

#

#Import the data

#
bitcoin = read.csv("Datasets/bitcoin_price.csv")
head(bitcoin)

ethereum = read.csv("Datasets/ethereum_dataset.csv")
head(ethereum)

plot(bitcoin)
