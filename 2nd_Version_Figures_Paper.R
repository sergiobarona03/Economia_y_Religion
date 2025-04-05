
################################################
## Figures: paper "Religious tolerance index" ##
################################################

library(miceadds)
library(sandwich)
library(readxl)
library(haven)
library(dplyr)
library(Hmisc)
library(ggcorrplot)
library(ggplot2)
library(mice)
library(MASS)
library(ggplot2)
library(reshape2)
library(sf)
library(terra)
library(maptools)
library(rnaturalearth)
library(readxl)
library(RColorBrewer)
library(factoextra)
library(ggpubr)

setwd("C:/Users/Portatil/Desktop/Economia_y_Religion/Version_2")
dataset = read_excel("STATA_Relig_Tolerance_Climate (Regiones).xlsx")
dataset = dataset %>% filter(`_mi_m` ==  0)
dataset$id = seq(1,nrow(dataset), by=1 )

dataset_relig_tol=dataset

for (i in 1:nrow(dataset)) {
  if (is.na(dataset_relig_tol$Relig_Tol_uptow6[i])){
    dataset_relig_tol$sam_uptow6[i]=0
    
  }
}


for (i in 1:nrow(dataset)) {
  if (is.na(dataset_relig_tol$Relig_Tol_uptow7[i])){
    dataset_relig_tol$sam_uptow7[i]=0
    
  }
}

for (i in 1:nrow(dataset)) {
  if (is.na(dataset_relig_tol$Relig_Tol_onlyw6[i])){
    dataset_relig_tol$sam_onlyw6[i]=0
    
  }
}

for (i in 1:nrow(dataset)) {
  if (is.na(dataset_relig_tol$Relig_Tol_onlyw7[i])){
    dataset_relig_tol$sam_onlyw7[i]=0
    
  }
}


dataset_relig_tol <- dataset_relig_tol %>% filter(sam_uptow7==1)

#-------------------------------------#
# Spatial distribution of CCPS Index  #-------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------#
dataset <- dataset_relig_tol

# Dataset: paper religious tolerance index
world <- ne_countries(scale = "medium",
                      returnclass = "sf") %>% filter(admin != "Antarctica")

dataset$country[which(dataset$country== "Korea, Rep.")] = "Republic of Korea"
dataset$country[which(dataset$country == "Macedonia")] = "North Macedonia"
dataset$country[which(dataset$country == "Russia")] = "Russian Federation"

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

ggsave(plot_ccps, filename = "Output/Plot_CCPS_Index.png",
       height = 20, width = 4)

# Guardar para la prueba usando Tableau
writexl::write_xlsx(dataset_country,
                    "Data/dataset_country_Tableau.xlsx")

###########################
## Matriz de correlación ##-------------------------------------------------------------------------------------------------------------------------------------------------
###########################

# Eliminar valores NA
dataset_paper <- dataset_country

# Supongamos que las variables son las siguientes:
index_vars = c( "rel_and_science_uptow7","dogood_both_uptow7",
                "Thisworld_both_uptow7",	"many_relig_uptow7")
corr_dataset <- dataset_paper %>% dplyr::select("country", index_vars)

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

# Cambiar el nombre a las variables
colnames(corr_dataset)[which(colnames(corr_dataset) == "rel_and_science_uptow7")] = "Religion and science"
colnames(corr_dataset)[which(colnames(corr_dataset) == "dogood_both_uptow7")] = "Do good to others"
colnames(corr_dataset)[which(colnames(corr_dataset) == "Thisworld_both_uptow7")] = "Meaning this world"
colnames(corr_dataset)[which(colnames(corr_dataset) == "many_relig_uptow7")] = "Acceptable religions"

png("Output/corr_plot_3.png")
pairs.panels(corr_dataset[setdiff(colnames(corr_dataset),
                                             c("id", "country"))],
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
# Principal Components Analysis #-------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------#
pca <- prcomp(dataset_paper[index_vars], scale = T, center = T)
summary(pca)

# To compute PVE and eigenvalues
pve.eigen <- data.frame(pc = 1:4,
                   pve = 100*pca$sdev^2/sum(pca$sdev^2),
                  eig.val = get_eigenvalue(pca)$eigenvalue)
pve.eigen$diff = pve.eigen$pve/pve.eigen$eig.val
pve.eigen$cpve = cumsum(pve.eigen$pve)
pve.eigen$diff2 = pve.eigen$cpve/pve.eigen$eig.val



pve.eigen.plot <- ggplot(pve.eigen, aes(pc, pve)) + 
  geom_col(aes(x = pc , y = pve),
           color = "gray70",
           fill = "gray70", width = 0.5) +
  geom_line(aes(x = pc, 
                y = pve),
            color = "black"
  )+geom_hline(yintercept = 25, col = "black",
               linetype = "dashed") + geom_point()+
  scale_y_continuous(limits =c(0,100),
    "Proportion of variance explained", 
    sec.axis = sec_axis(~ . /25, name = "Eigenvalues")
  ) + labs(x = "Principal Component") + theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))


cpve.eigen.plot <- ggplot(pve.eigen, aes(pc, cpve)) + 
  geom_col(aes(x = pc , y = cpve),
           color = "gray70",
           fill = "gray70", width = 0.5) +
  geom_line(aes(x = pc, 
                y = cpve),
            color = "black"
  ) + geom_point() +  scale_y_continuous(limits =c(0,100),
    "Cumulative proportion of variance explained"
  ) + labs(x = "Principal Component") + theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))


ggarrange(pve.eigen.plot, cpve.eigen.plot, ncol = 2, nrow = 1)

ggsave(ggarrange(pve.eigen.plot, cpve.eigen.plot, ncol = 2, nrow = 1),
       filename = "Output/PVE_PCA.png",
       width= 1070/100, height  = 492/100)


###########################
## Imputación múltiple   ##-------------------------------------------------------------------------------------------------------------------------------------------------
###########################
no.imp = dataset_relig_tol

var = c("id", "ccps", "Relig_Tol_uptow7",
        "log_GDP", "globaliz", "coalp_cap",  "dmcry",  "inst",
        "WB_EUCA", "WB_LAAC", "WB_MEANA", "WB_SAsia", 
        "WB_SSAfrica", "WB_EAP")

# Stochastic regression imputation
no.imp = no.imp[c(var, "meaning_this_world", "meaning_do_good",
                                     "relig_and_science", "relig_acceptable")]
imp <- mice(no.imp, method = "norm.nob", m = 5) # Impute data

lista_datasets = list()
length(lista_datasets) = 5
lista_datasets[[1]] = complete(imp,1)
lista_datasets[[2]] = complete(imp,2)
lista_datasets[[3]] = complete(imp,3)
lista_datasets[[4]] = complete(imp,4)
lista_datasets[[5]] = complete(imp,5)

for (k in 1:5) {
  
  
  lista_datasets[[k]]$rel_and_science_uptow7 [lista_datasets[[k]]$rel_and_science_uptow7 > 1] = 1 
  lista_datasets[[k]]$rel_and_science_uptow7[lista_datasets[[k]]$rel_and_science_uptow7 < 0] = 0 
  
  lista_datasets[[k]]$dogood_both_uptow7[lista_datasets[[k]]$dogood_both_uptow7 > 1] = 1 
  lista_datasets[[k]]$dogood_both_uptow7 [lista_datasets[[k]]$dogood_both_uptow7 < 0] = 0
  
  lista_datasets[[k]]$Thisworld_both_uptow7[lista_datasets[[k]]$Thisworld_both_uptow7 > 1] = 1 
  lista_datasets[[k]]$Thisworld_both_uptow7 [lista_datasets[[k]]$Thisworld_both_uptow7 < 0] = 0
  
  lista_datasets[[k]]$many_relig_uptow7 [lista_datasets[[k]]$many_relig_uptow7 > 1] = 1 
  lista_datasets[[k]]$many_relig_uptow7 [lista_datasets[[k]]$many_relig_uptow7 < 0] = 0
}

for (im in 1:5) {
  lista_datasets[[im]]$imp=im
}

WVS_Trust_CCPS = rbind(lista_datasets[[1]],
                       lista_datasets[[2]],
                       lista_datasets[[3]],
                       lista_datasets[[4]],
                       lista_datasets[[5]])

WVS_Trust_CCPS = WVS_Trust_CCPS [c("id", "rel_and_science_uptow7", "dogood_both_uptow7",
                                   "Thisworld_both_uptow7",	"many_relig_uptow7", "imp")]

no.imp_1 = no.imp

no.imp_1$imp = rep(0, nrow(no.imp_1))

no.imp_1 = no.imp_1[c("id", "rel_and_science_uptow7", "dogood_both_uptow7",
                                "Thisworld_both_uptow7",	"many_relig_uptow7", "imp")]

no.imp_1 = no.imp_1[complete.cases(no.imp_1),]

Imputaciónfinal = rbind(WVS_Trust_CCPS, no.imp_1)

Imputaciónfinal.melt = melt(Imputaciónfinal, id.vars = c("id", "imp"))

Imputaciónfinal.melt$imp = as.numeric(Imputaciónfinal.melt$imp)

Imputaciónfinal.melt = Imputaciónfinal.melt[order(Imputaciónfinal.melt$imp),]

ggplot(data=Imputaciónfinal.melt, aes(x=imp, y=value, group=imp))+ geom_boxplot() + facet_grid(variable ~ .)
