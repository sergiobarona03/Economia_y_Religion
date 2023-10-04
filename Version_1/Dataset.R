
#########################
## Econom?a y religi?n ##
#########################

install.packages("ggcorrplot")
install.packages("mice")
library(readxl)
library(haven)
library(dplyr)
library(Hmisc)
library(ggcorrplot)
library(ggplot2)
library(mice)

###################
## Base de datos ##---------------------------------------------------------------------------------------------------------------------------
###################

dataset = read_dta("Climate_Relig.dta")

# Base de datos sin valores imputados
dataset_0 = dataset %>% filter(`_mi_m` ==  0)
 
# Base de datos con valores imputados (m = 1)
dataset_1 = dataset %>% filter(`_mi_m` ==  1)


###########################
## Matriz de correlación ##-------------------------------------------------------------------------------------------------------------------------------------------------
###########################
dataset_index = dataset[c("relpers", "beliefgod",
                          "impgod", "relattend", "imprel")]
dataset.rcorr = rcorr(as.matrix(dataset_index))

dataset.corr = cor(dataset_index,use = "complete.obs")

# Plot con ggcorrplot
ggcorrplot(dataset.corr, method="square",
           type = "full", lab = T)


###########################
## Imputación múltiple   ##-------------------------------------------------------------------------------------------------------------------------------------------------
###########################

no.imp = dataset %>% filter(`_mi_m` ==  0)

# Stochastic regression imputation
no.imp = no.imp[c("relpers", "beliefgod",
                  "impgod", "relattend", "imprel")]
imp <- mice(no.imp, method = "norm.nob", m = 5) # Impute data

lista_datasets = list()
length(lista_datasets) = 5
lista_datasets[[1]] = complete(imp,1)
lista_datasets[[2]] = complete(imp,2)
lista_datasets[[3]] = complete(imp,3)
lista_datasets[[4]] = complete(imp,4)
lista_datasets[[5]] = complete(imp,5)

