import csv, editdistance

with open('rejected_att.csv') as file:
    reader = csv.reader(file, delimiter=',')
    rejected = list(reader)

with open('stats_player_15.csv') as file:
    reader = csv.reader(file, delimiter=',')
    stats = list(reader)


wtr = csv.writer(open ('merged_att.csv', 'w'), delimiter=',', lineterminator='\n')

print(rejected[0], stats[0])
found = {}

headerRow = ['LOCATION','SHOT_NUMBER','SHOT_CLOCK', 'DRIBBLES', 'SHOT_DIST', 'CLOSEST_DEFENDER', 'CLOSE_DEF_DIST', 'SHOT_RESULT', 'missingKey', 'Year','Player','Pos','Age','PER','BLK_','TS_']

wtr.writerow(headerRow)

for count_i, i in enumerate(rejected[1:]):
    found[count_i] = False
    for j in stats[1:]:
        rejectedName = i[0]
        lookingUpName = j[1]
        if (editdistance.eval(rejectedName, lookingUpName) < 3):
            found[count_i] = True
            print(rejectedName,
                  lookingUpName,
                  editdistance.eval(rejectedName, lookingUpName))
            newRow = i[1:] + j
            wtr.writerow(newRow)
    if not found[count_i]:
        print("Woops, '", rejectedName , "'not matched")        
