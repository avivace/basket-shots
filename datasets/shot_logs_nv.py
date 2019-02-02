# -*- coding: utf-8 -*-
"""
Created on Fri Feb  1 19:31:32 2019

@author: luca
"""
import pandas as pd

data = pd.read_csv(r"C:\Users\luca\Documents\GitHub\basket-shots\datasets\shot_logs.csv")
df = data.sort_values(by=['player_name', 'GAME_ID'])
df_agg = df.groupby(['player_name', 'GAME_ID']).agg({'SHOT_NUMBER':'max', 'FGM':'sum'})
df_agg = df_agg.reset_index()
df_shift = df_agg.groupby('player_name')['SHOT_NUMBER', 'FGM'].shift(1)
df_agg = df_agg.drop(columns=['SHOT_NUMBER', 'FGM'])
df_final = df_agg.join(df_shift)
#df_d['% shot_game'] = df_d['FGM'] / df_d['SHOT_NUMBER']
