import pandas as pd

data = pd.read_csv(r"shot_logs.csv")
df = data.sort_values(by=['player_name', 'GAME_ID'])
df_agg = df.groupby(['player_name', 'GAME_ID']).agg({'SHOT_NUMBER':'max', 'FGM':'sum'}).reset_index()
df_cs = df_agg.groupby('player_name').agg({'SHOT_NUMBER':'cumsum', 'FGM':'cumsum'})
df_agg = df_agg.drop(columns=['SHOT_NUMBER', 'FGM'])
df_agg = df_agg.join(df_cs)
df_agg['% Previous'] = round(df_agg['FGM'] / df_agg['SHOT_NUMBER'], 2)
df_shift = df_agg.groupby('player_name')['% Previous'].shift(1)
df_agg = df_agg.drop(columns=['SHOT_NUMBER', 'FGM', '% Previous'])
df_final = df_agg.join(df_shift)
df_final = pd.merge(df, df_final, on=['player_name', 'GAME_ID'], how='inner')
df_final.to_csv(r"shot_logs_wpp.csv")