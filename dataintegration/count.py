# -*- coding: utf-8 -*-
"""
Created on Fri Feb  8 14:46:03 2019

@author: luca
"""

import pandas as pd

data = pd.read_csv(r"C:\Users\luca\Documents\GitHub\basket-shots\datasets\shots_att_def_stats.csv")
df = data.sort_values(by=['name_att'])
print("Attempted shots mean is:", round(df.groupby(['name_att']).size().mean(), 2))
print("Attempted blocks mean is:", round(df.groupby(['name_def']).size().mean(), 2))
print("Made shots mean is:", round(df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().mean(), 2))
print("Missed shots mean is:", round(df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().mean(), 2))

made_shots_hist = df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
fig = made_shots_hist.get_figure()
fig.savefig(r'C:\Users\luca\Documents\GitHub\basket-shots\docs\made_shots_hist.pdf')

missed_shots_hist = df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
fig = missed_shots_hist.get_figure()
fig.savefig(r'C:\Users\luca\Documents\GitHub\basket-shots\docs\missed_shots_hist.pdf')
