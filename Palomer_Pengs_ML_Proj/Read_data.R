## Reading in data

library(readr)

peng_data <- read.csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins.csv")

write.csv(peng_data, "Palomer_Pengs_ML_Proj/Data/peng_data.csv") #Save data to a new file
