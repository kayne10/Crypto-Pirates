#this is a program that makes plots based on one attribute and dataset

import plotly
import plotly.plotly as py
import plotly.graph_objs as go
import pandas
import argparse
import numpy as np
from pandas import Series

parser = argparse.ArgumentParser(description='Input file name and or directory')
parser.add_argument("file1", help = "Filename/ directory", type = str)
parser.add_argument("file2", help = "Filename/ directory", type = str)
parser.add_argument("file3", help = "Filename/ directory", type = str)
#parser.add_argument("file4", help = "Filename/ directory", type = str)
parser.add_argument("a1", type=str,
    help="Type of Attribute for fname1. Select either open or high or low or close or volume",
    choices=['Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Market Cap', 'symbol', 'volume'])
'''parser.add_argument("a2", type=str,
    help="Type of Attribute for fname1. Select either open or high or low or close or volume",
    choices=['Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Market Cap', 'symbol', 'volume'])'''


args = parser.parse_args()

graph_data1 = pandas.read_csv(args.file1)
graph_data2 = pandas.read_csv(args.file2)
graph_data3 = pandas.read_csv(args.file3)
#graph_data4 = pandas.read_csv(agrs.file4)
#raw = eval(args.a1)new
graph_data2['MA'] = graph_data2[args.a1].rolling(10).mean()
#print(graph_data2)
type = raw_input("What type of chart? \n")

'''if(type == 'hist' or type == 'hist '):

    bins = input("How many bins?\n")
    layout2 = go.Layout(title = 'Histogram for %s' % args.a1)
    volume = go.Histogram(
        x = graph_data[args.a1],
        histnorm = 'count',
        name = args.a1,
        xbins = dict(
            start = graph_data[args.a1].min(),
            end = graph_data[args.a1].max(),
            size = (graph_data[args.a1].max())/bins
        )
    )
    data = [volume]
    fig4 = go.Figure(data = data, layout = layout2)
    py.plot(fig4)'''

if(type == 'scatter' or type == 'scatter '):
    layout_open = go.Layout(title = 'Scatter plot of %s ' % args.a1)
    print("This will automatically use the date attribute as the x axis")

    data1 = go.Scatter(
    x = graph_data1['Date'],
    y = graph_data1[args.a1],
    name = args.file1
    )
    data2 = go.Scatter(
    x = graph_data1['Date'],
    y = graph_data2[args.a1],
    name = args.file2
    )
    data3 = go.Scatter(
    x = graph_data1['Date'],
    y = graph_data3[args.a1],
    name = args.file3
    )
    data4 = go.Scatter(
    x = graph_data1['Date'],
    y = (graph_data1[args.a1] - graph_data3[args.a1]),
    name = 'Difference'
    )

    data = [data1, data2, data3]
    fig = go.Figure(data = data, layout = layout_open)
    py.plot(fig)
######

if(type == 'box' or type == 'box '):
    data1 = go.Box(
        x = graph_data1[args.a1],
        name = args.file1
    )
    data2 = go.Box(
        x = graph_data2[args.a1],
        name = args.file2
    )
    layout = go.Layout(title = 'boxplot of %s' % args.a1)
    data = [data1, data2]
    fig = go.Figure(data = data, layout = layout)
    py.plot(fig)
