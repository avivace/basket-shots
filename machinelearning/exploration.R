set.seed(123)
setwd('~/github/basket-shots/datasets/')
library(rminer)
library(ggplot2)
library(svglite)

# Import dataset
dataset = read.csv('shots_att_def_stats.csv', sep=",", fileEncoding="latin1")
setwd('~/github/basket-shots/docs/')

# Shot result - total and percentage
shot_result_plot = ggplot(dataset, aes(x = shot_result)) + geom_bar() +
  theme(text = element_text(size=20))
ggsave(file="shot_result.pdf", plot=shot_result_plot, width=10)

made = sum(dataset$shot_result == 'made')
missed = sum(dataset$shot_result == 'missed')
total = made+missed
perc_made = round(made/total, 2)
perc_missed = round(missed/total, 2)

# Correlation between position and shots
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


perc_made_c = round(made_c/(made_c + missed_c), 2)
perc_missed_c = round(missed_c/(made_c + missed_c), 2)


data = rbind(c(made_c, made_pg, made_pf, made_sf, made_sg), 
             c(missed_c, missed_pg, missed_pf, missed_sf, missed_sg))

C = cbind(data[, 1], 1, c(1:2))
PG =  cbind(data[, 2], 2, c(1:2))
PF = cbind(data[, 3], 3, c(1:2))
SF = cbind(data[, 4], 4, c(1:2))
SG = cbind(data[, 5], 5, c(1:2))

data = as.data.frame(rbind(C, PG, PF, SF, SG))
colnames(data) = c("Shots", "Position", "Label")
data$Position = factor(data$Position, labels = c("C", "PG", "PF", "SF", "SG"))
data$Label = factor(data$Label, labels = c("Made", "Missed"))

plot_made_missed = ggplot(data = data, aes(x = Position, y = Shots, fill = Label)) + 
  geom_bar(stat = "identity") + theme(text = element_text(size=20)) +
  geom_text(aes(label = Shots), position = position_stack(vjust = 0.5))
ggsave(file="made_missed_barplot.pdf", plot=plot_made_missed, width=10)

# Correlation between position and shot distance
dist_c = aggregate(dataset, by=list(dataset$position_attack), FUN=mean)
shot_dist_position = dist_c[c("Group.1", "shot_dist")]
colnames(shot_dist_position)[colnames(shot_dist_position)=="Group.1"] = "position"
shot_dist_with_position = ggplot(data = shot_dist_position, aes(x = position, y = shot_dist)) + 
  geom_bar(stat = "identity") + theme(text = element_text(size=20))

ggsave(file="shot_dist_with_position.pdf", plot=shot_dist_with_position, width=10)

# Correlation between shot distance and distance from the most near defender
plot_shot_distance = ggplot(data=dataset, aes(x=shot_dist, y=close_def_distance)) +
  geom_point(aes(color=shot_result)) + theme(text = element_text(size=20))
ggsave(file="plot_shot_dist_def.pdf", plot=plot_shot_distance, width=10)
