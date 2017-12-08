#Buy / Sell Command line Based on given dates / currency
import sys
import datetime
import calendar


print ('Welcome to the CryptoPirate Buy/Sell Predictor' "\n")
months = [x for x in calendar.month_abbr[3]]

try:
    format_date = datetime.datetime.strptime(s, "%")
    date =  input('Please choose a Date in the following format: e.g. Oct 03, 2017' "\n")

except ValueError:
    print("Invalid Date formatting")

print ('You have chosen', date, "\n")
cc = input('Please choose a Crypto Currency: e.g. Bitcoin, Litecoin, Monero' "\n")
print ('You have chosen', cc, "\n")
choice = input('Would you like to use the buy/sell predictor, or the +/- predictor?' "\n")

#if(choice == 'buy/sell predictor'):

#if(choice == '+/- predictor'):
