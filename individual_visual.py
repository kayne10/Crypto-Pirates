#this is a program that makes plots based on one attribute and dataset


import plotly.plotly as py
import plotly.graph_objs as go
import pandas
import argparse

parser = argparse.ArgumentParser(description='Input file name and or directory')
parser.add_argument("file1", help = "Filename/ directory", type = str)
#parser.add_argument("file2", help = "Filename/ directory", type = str)
parser.add_argument("a1", type=str,
    help="Type of Attribute for fname1. Select either open or high or low or close or volume",
    choices=['Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Market Cap', 'symbol', 'volume', 'Market Cap'])

args = parser.parse_args()

graph_data = pandas.read_csv(args.file1)
#raph_data2 = pandas.read_csv(args.file2)
#raw = eval(args.a1)


type = raw_input("What type of chart? \n")

if(type == 'hist' or type == 'hist '):

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
    py.plot(fig4)
########

elif(type == 'scatter' or type == 'scatter '):
    layout_open = go.Layout(title = 'Scatter plot')
    print("This will automatically use the date attribute as the x axis")
    data1 = go.Scatter(
    x = graph_data['Date'],
    y = graph_data[args.a1]
    )
    data3 = go.Scatter(
    x = graph_data1['Date'],
    y = graph_data2['MA'],
    name = 'moving average'
    )
    data = [data1, data3]
    fig = go.Figure(data = data, layout = layout_open)
    py.plot(fig)
######

elif(type == 'box' or type == 'box '):
    data1 = go.Box(
        y = graph_data[args.a1]
    )
    layout = go.Layout(title = 'boxplot of %s' % args.a1)
    data = [data1]
    fig = go.Figure(data = data, layout = layout)
    py.plot(fig)
