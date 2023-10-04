
#########################
## Econom?a y religi?n ##
#########################

install.packages("ggcorrplot")
install.packages("mice")
install.packages("Hmisc")
library(readxl)
library(haven)
library(dplyr)
library(Hmisc)
library(ggcorrplot)
library(ggplot2)
library(mice)
library(MASS)

set.seed(123)

###################
## Base de datos ##---------------------------------------------------------------------------------------------------------------------------
###################

dataset = read_dta("Climate_Relig.dta")
no.imp = dataset %>% filter(`_mi_m` ==  0)


dataset$id = seq(1, nrow(dataset), )

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
           type = "upper", lab = T)


###########################
## Imputación múltiple   ##-------------------------------------------------------------------------------------------------------------------------------------------------
###########################

no.imp = dataset %>% filter(`_mi_m` ==  0)

# Stochastic regression imputation
no.imp = no.imp[c(, "relpers", "beliefgod",
                  "impgod", "relattend", "imprel")]
imp <- mice(no.imp, method = "norm.nob", m = 5) # Impute data

lista_datasets = list()
length(lista_datasets) = 5
lista_datasets[[1]] = complete(imp,1)
lista_datasets[[2]] = complete(imp,2)
lista_datasets[[3]] = complete(imp,3)
lista_datasets[[4]] = complete(imp,4)
lista_datasets[[5]] = complete(imp,5)

model = with(imp, rlm(relpers ~ beliefgod + impgod + relattend + imprel))
model_1 = model$analyses[[1]]

model_pool = pool(model)


for (k in 1:5) {
  lista_datasets[[k]]$relpers[lista_datasets[[k]]$relpers > 1] = 1 
  lista_datasets[[k]][lista_datasets[[k]] < 0] = 0 
  
}

#################
## Regresiones ##
#################
install.packages("miceadds")
install.packages("sandwich")
library(sandwich)
library(miceadds)

datlist = miceadds::mids2datlist(imp)

model2 = with(datlist, rlm(relpers ~ beliefgod + impgod + relattend + imprel),
              )


betas = lapply(model2, coef)
vars = lapply(model2, 
              FUN = function(x){vcovCL(x, cluster = datlist[[1]]$relattend)})

summary(pool_mi(betas, vars))








