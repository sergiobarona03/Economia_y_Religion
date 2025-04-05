
##-------------------------------##
## Principal Components Analysis ##
##-------------------------------##

##------------##
## Input data ##-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##------------##

# Directorio de trabajo
setwd("C:/Users/Portatil/Desktop/Economia_y_Religion/")

# Conjuntos de datos
dataset_paper <- readxl::read_excel("Version_2/Data/dataset_country_Tableau.xlsx")

# Selección de variables
index_vars = c( "rel_and_science_uptow7","dogood_both_uptow7",
                "Thisworld_both_uptow7",	"many_relig_uptow7")

##-------------------------##
## PCA Loadings and Scores ##-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##-------------------------##

# Análisis de Componentes Principales
pca <- prcomp(dataset[index_vars], scale = TRUE, center = TRUE)
summary(pca)

# Eigen values
eig.val = get_eigenvalue(pca)

# Screeplot
pve <- 100*pca$sdev^2/sum(pca$sdev^2)

png("Output/PCA/PVE_PCA.png")
plot(pve, type = "o", 
     ylab = "Proportion of variance explained", 
     xlab = "Principal Component", 
     col = "black")
dev.off()

png("Output/PCA/CPVE_PCA.png")
plot(cumsum(pve), type = "o", 
     ylab = "Cumulative proportion of variance explained", 
     xlab = "Principal Component", 
     col = "black")
dev.off()

setEPS()
postscript("Output/PCA/PVE_PCA.eps")
plot(pve, type = "o", 
     ylab = "Proportion of variance explained", 
     xlab = "Principal Component", 
     col = "black")
dev.off()

setEPS()
postscript("Output/PCA/CPVE_PCA.eps")
plot(cumsum(pve), type = "o", 
     ylab = "Cumulative proportion of variance explained", 
     xlab = "Principal Component", 
     col = "black")
dev.off()


# Explaining first two PCA
png("Output/PCA/Biplot_PCA.png")
fviz_pca_biplot(pca, label = "var",
                col.ind = "gray",
                col.var = "contrib",
                repel = TRUE, select.var = list(contrib = 10)) + scale_colour_gradient2(name = "Contribution") 
dev.off()

setEPS()
postscript("Output/PCA/Biplot_PCA.eps")
fviz_pca_biplot(pca, label = "var",
                col.ind = "gray",
                col.var = "contrib",
                repel = TRUE, select.var = list(contrib = 10)) + scale_colour_gradient2(name = "Contribution") 
dev.off()

# New Dataset
elbow = 1

new_pca = prcomp(dataset[index_vars], scale = TRUE, 
                 center = TRUE, rank = elbow)


# Multi-Class -> Transforming The Labels
new_dataset =  predict(new_pca, dataset[index_vars])
new_dataset = as.data.frame(new_dataset)
new_dataset$country = dataset$country

writexl::write_xlsx(new_dataset, 
                    "Output/PCA/PCA_Index_Output.xlsx")

##--------------##
## New Dataset  ##-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##--------------##

# Base de datos original
n0_dataset <- read_excel("STATA_Relig_Tolerance_Climate (Regiones).xlsx") 

### Dos opciones:
# Opción 1: loadings como ponderaciones
# Ponderadores
new_pca$rotation

w_mean <- n0_dataset %>% mutate(Weighted_RT_uptow7 = ((Thisworld_both_uptow7*new_pca$rotation[3]) 
                            + (dogood_both_uptow7*new_pca$rotation[2]) +
                              (rel_and_science_uptow7*new_pca$rotation[1]) +
                              (many_relig_uptow7*new_pca$rotation[4]))/ sum(new_pca$rotation))

### Opción 2: PC1 score normalizado
new_dataset$W_RTI_normalized <- (new_dataset$PC1 - min(new_dataset$PC1)) / 
  (max(new_dataset$PC1) - min(new_dataset$PC1))

# Agregar PC1 normalizado
final_dataset = w_mean %>% left_join(new_dataset, by = "country")

writexl::write_xlsx(final_dataset, "STATA_Weighted_Relig_Tolerance_Climate (Regiones).xlsx")

