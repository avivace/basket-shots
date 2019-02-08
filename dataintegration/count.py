# -*- coding: utf-8 -*-
"""
Created on Fri Feb  8 14:46:03 2019

@author: luca
"""

import pandas as pd

data = pd.read_csv(r"C:\Users\luca\Documents\GitHub\basket-shots\datasets\shots_att_def_stats.csv")
df = data.sort_values(by=['name_att'])
print("Media di tiri in stagione:", round(df.groupby(['name_att']).size().mean(), 2))

# Media di tiri in stagione: 455.72

print("Media di blocchi:", round(df.groupby(['name_def']).size().mean(), 2))

# Media di blocchi: 271.31 

print("Media dei tiri con esito positivo:", round(df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().mean(), 2))

# Media dei tiri con esito positivo: 206.05

print("Media dei tiri con esito negativo:", round(df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().mean(), 2))

# Media dei tiri con esito negativo: 249.67

made_shots_hist = df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
fig = made_shots_hist.get_figure()
fig.savefig(r'C:\Users\luca\Documents\GitHub\basket-shots\docs\made_shots_hist.pdf')

missed_shots_hist = df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
fig = missed_shots_hist.get_figure()
fig.savefig(r'C:\Users\luca\Documents\GitHub\basket-shots\docs\missed_shots_hist.pdf')
