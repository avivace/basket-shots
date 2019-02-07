set.seed(123)
setwd('~/github/basket-shots/datasets/')
library(rminer)
library(ggplot2)

# Import dataset
dataset = read.csv('shots_att_def_stats.csv', sep=",", fileEncoding="latin1")

# Dataset exploration
made = sum(dataset$shot_result == 'made')
missed = sum(dataset$shot_result == 'missed')
total = made+missed
perc_made = round(made/total, 2)
perc_missed = round(missed/total, 2)

made_c = sum(dataset$shot_result == 'made' & dataset$position_attack == 'C')
made_pg = sum(dataset$shot_result == 'made' & dataset$position_attack == 'PG')
made_pf = sum(dataset$shot_result == 'made' & dataset$position_attack == 'PF')
made_sf = sum(dataset$shot_result == 'made' & dataset$position_attack == 'SF')
made_sg = sum(dataset$shot_result == 'made' & dataset$position_attack == 'SG')
missed_c = sum(dataset$shot_result == 'missed' & dataset$position_attack == 'C')
missed_pg = sum(dataset$shot_result == 'missed' & dataset$position_attack == 'PG')
missed_pf = sum(dataset$shot_result == 'missed' & dataset$position_attack == 'PF')
missed_sf = sum(dataset$shot_result == 'missed' & dataset$position_attack == 'SF')
missed_sg = sum(dataset$shot_result == 'missed' & dataset$position_attack == 'SG')

data = rbind(c(made_c, made_pg, made_pf, made_sf, made_sg), 
             c(missed_c, missed_pg, missed_pf, missed_sf, missed_sg))

C = cbind(data[, 1], 1, c(1:2))
PG =  cbind(data[, 2], 2, c(1:2))
PF = cbind(data[, 3], 3, c(1:2))
SF = cbind(data[, 4], 4, c(1:2))
SG = cbind(data[, 5], 5, c(1:2))

data = as.data.frame(rbind(C, PG, PF, SF, SG))
colnames(data) = c("Shot", "Type", "Group")
data$Type = factor(data$Type, labels = c("C", "PG", "PF", "SF", "SG"))

perc_made_c = round(made_c/(made_c + missed_c), 2)
perc_missed_c = round(missed_c/(made_c + missed_c), 2)

ggplot(data = data, aes(x = Type, y = Shot, fill = Group)) + 
  geom_bar(stat = "identity") +
  geom_text(aes(label = Shot), position = position_stack(vjust = 0.5))
  #opts(legend.position = "none")

perc_made_c = round(made_c/(made_c + missed_c), 2)
perc_missed_c = round(missed_c/(made_c + missed_c), 2)


dist_c = aggregate(dataset, by=list(dataset$position_attack), FUN=mean)

bp_shot_result = barplot(summary(dataset$shot_result))
ggsave('~/github/basket-shots/datasets/plots/shot_result.png', plot=bp_shot_result)
barplot(summary(dataset$location))
barplot(summary(dataset$position_attack))
barplot(summary(dataset$position_defend))
hist(dataset$shot_dist)
hist(dataset$touch_time)

ggplot(data=dataset, aes(x=shot_dist, y=close_def_distance)) + geom_point(aes(color=factor(shot_result))) 
