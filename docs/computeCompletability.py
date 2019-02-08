import csv
i = 0
totalPerYear = 1232.0
pastYearsConsidered = 2

wtr = csv.writer(open ('completeness_over_time.csv', 'w'), delimiter=',', lineterminator='\n')

with open('nba-2018-EasternStandardTime.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        if (i !=0):
            completeness = round((((totalPerYear * pastYearsConsidered) + i - 5) / (totalPerYear * (pastYearsConsidered + 1)) * 100),1)
            print(row[1], completeness)
            wtr.writerow([row[1], completeness])
        else:
            wtr.writerow(["Date", "Completeness"])
        i+=1
