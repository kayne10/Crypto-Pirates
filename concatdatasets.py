import pandas as pd
import argparse
import numpy as np


parser = argparse.ArgumentParser(description='Input file name and or directory')
parser.add_argument("file1", help = "Filename/ directory", type = str)
parser.add_argument("a1", type=str,
    help="Type symbol to make new dataset")
args = parser.parse_args()

data1 = pd.read_csv(args.file1)


graph_data = data1[data1['Symbol'] == args.a1]
print(graph_data)

graph_data.to_csv(args.a1 + '.csv', encoding='utf-8')
