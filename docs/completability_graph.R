setwd('~/github/basket-shots/docs/')
library(ggplot2)
dataset = read.csv('completeness_over_time.csv', sep=",")

dataset$Date = as.Date(dataset$Date,"%d/%m/%Y %H:%M")

completability = ggplot( data = dataset, aes( Date, Completeness )) + 
  expand_limits(y = 0) + 
  geom_line() +
  geom_ribbon(data = dataset[dataset$Date <= dataset$Date[500],], aes(ymin=0, ymax=Completeness), fill = "gray") +
  geom_ribbon(data = dataset[dataset$Date >= dataset$Date[500],], aes(ymin=50, ymax=Completeness), fill = "orange") +
  geom_ribbon(data = dataset[dataset$Date >= dataset$Date[500],], aes(ymin=0, ymax=50), fill = "lightgreen") +
  annotate("text", label = "A", x = dataset$Date[1100], y = 25, size = 8, colour = "black") +
  annotate("text", label = "Cb", x = dataset$Date[1100], y = 75, size = 8, colour = "black") +
  theme(text = element_text(size=20)) +
  ylab("Completeness %")

ggsave(file="completability.pdf", plot=completability, width=10)

# geom_ribbon(aes(ymin=0, ymax=50), fill = "black")
  