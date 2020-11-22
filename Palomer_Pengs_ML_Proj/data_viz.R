## Loading Libraries

library(tidyverse)

##Reading in our data.

peng_data <- read.csv("Palomer_Pengs_ML_Proj/Data/peng_data.csv")

skimr::skim(peng_data)

#Let's do a quick viz

bill_plot <- peng_data %>% 
  ggplot(aes(bill_length_mm, bill_depth_mm, color = species)) +
  geom_point(alpha = 0.8, size = 2, show.legend = FALSE)+
  theme_light()+
  labs(
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = ""
  )

bill_plot

mass_plot <- peng_data %>% 
  ggplot(aes(body_mass_g, flipper_length_mm, color = species))+
  geom_point(alpha = 0.8, size = 2)+
  theme_light()+
  labs(
    color = "",
    x = "Body Mass (g)",
    y = "Flipper Length (g)"
  )
mass_plot

library(cowplot)

plot_row <-  plot_grid(bill_plot, mass_plot)

title <- ggdraw()+
  draw_label(
    "Palomer Penguins", 
    fontface = 'bold',
    x = 0,
    hjust = 0
  )+
  theme(
    plot.margin = margin(0,0,0,7)
  )

peng_plot <- plot_grid(
  title, plot_row,
  ncol = 1,
  rel_heights = c(0.1,1)
)

ggsave("Palomer_Pengs_ML_Proj/Imgs/peng_plot.png", peng_plot,
       width = 8, height = 5,
       dpi = 750)
