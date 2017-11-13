import pandas as pd
import numpy as np
import plotly
import plotly.plotly as py
import plotly.graph_objs as go

# use plotly API access key
plotly.tools.set_credentials_file(username='tkayne10', api_key='ucP2JLwCw0pvU0MIFPtp')

df = pd.read_csv('/Users/troy/Github/courses/crypto-pirates/Datasets/bitcoin_price.csv')

trace = go.Scatter(
    x = df['Date'],
    y = df['Close'],
    mode = 'markers'
)

data = [trace]

py.plot(data, filename='basic-scatter')
