
################################################
## Figures: paper "Religious tolerance index" ##
################################################
library(sf)
library(terra)
library(maptools)
library(rnaturalearth)
library(readxl)

#-------------------------------------#
# Spatial distribution of CCPS Index  #
#-------------------------------------#
world <- ne_countries(scale = "medium",
                      returnclass = "sf") %>% filter(admin != "Antarctica")

# Dataset: paper religious tolerance index
dataset <- read_excel("STATA_Relig_Tolerance_Climate (Regiones).xlsx")
dataset$country[which(dataset$country== "Korea, Rep.")] = "Republic of Korea"
dataset$country[which(dataset$country == "Macedonia")] = "North Macedonia"
dataset$country[which(dataset$country == "Russia")] = "Russian Federation"

View(dataset)

# Merge: dataset and world .shp
dataset_country <- merge(dataset, world,
                         by.x = "country", by.y = "name_long")

# plot by CCPS index

plot_ccps <- ggplot() +
  geom_sf(data = st_as_sf(world),fill = alpha("white"), 
          col = alpha("black", 0.3)) +
  geom_sf(data = st_as_sf(dataset_country),
          aes(fill = ccps, col = ccps))+ theme_bw() +
  theme(legend.position = c(0.1, 0.3),
        legend.background = element_rect(fill = "white",
                                         size = 0.2,
                                         linetype = "solid",
                                         colour = "black"),
        legend.key.size = unit(0.8, "cm"),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) + labs(fill = "CCPS index") +
  guides(colour = F) + scale_fill_gradientn(colors = brewer.pal(8,"Oranges")) +
  scale_colour_gradientn(colors = brewer.pal(8, "Oranges"))

ggsave(plot_ccps, filename = "Plot_CCPS_Index.png",
       height = 16, width = 9)

#-------------------------------------#
# Spatial distribution of CCPS Index  #
#-------------------------------------#

# Eliminar valores NA
dataset_paper <- dataset_country %>% filter(!is.na(beliefgod))

# Supongamos que las variables son las siguientes:
index_vars = c("beliefgod", "impgod",
               "relattend", "imprel")
corr_dataset <- dataset_paper %>% select("country", index_vars)

# Figura 1A: matriz de correlación e histogramas
library(PerformanceAnalytics)
chart.Correlation(corr_dataset[index_vars],
                  histogram = T, 
                  pch = 4,
                  method = "pearson",ci = T)

# Figura 1B: matriz de correlación (mapa de calor)
library(corrplot)
corrplot::corrplot(cor(corr_dataset[index_vars]),
                   method = "circle", type = "upper")


# Figura 1C: matriz de correlación (correlation matrix and histogram)
library(psych)
png("corr_plot.png")
pairs.panels(corr_dataset[index_vars],
             smooth = TRUE,
             scale = F,
             density = T,
             ellipses = F,
             method = "pearson",
             pch = 1,
             lm =F,
             cor = T,
             rug = F,
             factor = 2,
             hist.col = "lightgray",
             stars = T,
             ci = F,
             breaks = 7,
             cex.cor = 0.52)
dev.off()

#-------------------------------#
# Principal Components Analysis #
#-------------------------------#

pca <- prcomp(dataset_paper[index_vars], scale = T, center = T)
summary(pca)

# Screeplot
pve <- 100*pca$sdev^2/sum(pca$sdev^2)

# PVE and cumulative PVE plot
png("pca_pve_and_cpve.png")
par(mfrow = c(1, 2))
plot(pve, type = "o",
           ylab = "Proportion of variance explained",
           xlab = "Principal Component",
           col = "black")
plot(cumsum(pve), type = "o",
           ylab = "Cumulative proportion of variance explained",
           xlab = "Principal Component",
           col = "black")
dev.off()

