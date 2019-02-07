import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv(r"shots_att_def_stats.csv")
df = data.sort_values(by=['name_att'])
print ("Attempted shots mean is:")
print (df.groupby(['name_att']).size().mean())
print ("Attempted blocks mean is:")
print (df.groupby(['name_def']).size().mean())
print ("Made shots mean is:")
print(df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().mean())
print ("Missed shots mean is:")
print(df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().mean())
plt.subplot(2, 1, 1)
madeShotsHist = df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
plt.subplot(2, 1, 2)
missedShotsHist = df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
plt.show()