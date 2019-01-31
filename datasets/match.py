import csv, editdistance

with open('attack_rej.csv') as file:
    reader = csv.reader(file, delimiter=',')
    rejected = list(reader)

with open('stats_player_15.csv') as file:
    reader = csv.reader(file, delimiter=',')
    stats = list(reader)


wtr = csv.writer(open ('merged_att.csv', 'w'), delimiter=',', lineterminator='\n')

print(rejected[0], stats[0])
found = {}

headerRow = ['LOCATION', 'SHOT_NUMBER', 'DRIBBLES', 'SHOT_DIST', 'CLOSEST_DEFENDER',
			 'CLOSE_DEF_DIST', 'SHOT_RESULT', 'SHOT_CLOCK', 'Player', 'Age_attack', 'PER_attack',
			 'TS_attack', 'BLK', 'BPM_attack', 'Yrs_Experience_attack', 'Height_attack', 'Weight_attack', 
			 'Rounded_Position_attack']

# headerRow = ['LOCATION','SHOT_NUMBER','SHOT_CLOCK', 'DRIBBLES', 'SHOT_DIST', 'CLOSEST_DEFENDER', 'CLOSE_DEF_DIST', 'SHOT_RESULT', 'missingKey', 'Year','Player','Pos','Age','PER','BLK_','TS_']

wtr.writerow(headerRow)

for count_i, i in enumerate(rejected[1:]):
    found[count_i] = False
    for j in stats[1:]:
        rejectedName = i[0]
        lookingUpName = j[1]
        if (editdistance.eval(rejectedName, lookingUpName) < 4):
            found[count_i] = True
            print(rejectedName,
                  lookingUpName,
                  editdistance.eval(rejectedName, lookingUpName))
            newRow = i[1:9] + j[1:]
            wtr.writerow(newRow)
    if not found[count_i]:
        print("Woops, '", rejectedName , "'not matched")        
