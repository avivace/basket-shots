import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(r"C:\Users\luca\Documents\GitHub\basket-shots\datasets\shots_att_def_stats.csv")
print("Attempted shots mean is: ", round(df.groupby(['name_att']).size().mean(), 2))
print("Attempted defences mean is: ", round(df.groupby(['name_def']).size().mean(), 2))
print("Made shots mean is: ", round(df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().mean(), 2))
print ("Missed shots mean is: ", round(df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().mean(), 2))
plt.subplot(2, 1, 1)
madeShotsHist = df.loc[df['shot_result'] == 'made'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
plt.subplot(2, 1, 2)
missedShotsHist = df.loc[df['shot_result'] == 'missed'].groupby(['name_att']).size().plot.hist(bins=20, rwidth=0.5)
plt.show()
