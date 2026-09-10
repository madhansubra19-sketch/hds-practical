import pandas as pd

df = pd.read_csv("data/patients.csv")
print(df.describe())
