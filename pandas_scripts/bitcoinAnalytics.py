# this will analyze bitcoin data
# this will contain the pandas code
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv('/Users/troy/Github/courses/crypto-pirates/Datasets/bitcoin_price.csv')

plt.scatter(data['Date'], data['Volume'])
# plt.savefig(sample.pdf)
