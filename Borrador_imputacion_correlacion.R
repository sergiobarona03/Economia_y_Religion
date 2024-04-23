
install.packages("ggcorrplot")
install.packages("miceadds")
install.packages("sandiwch")
install.packages("mice")
install.packages("Hmisc")
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

setwd("C:/Users/PC/Desktop/Economia_y_Religion/Version_2")
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


dataset_relig_tol = dataset_relig_tol %>% filter(sam_uptow7==1)


###########################
## Matriz de correlación ##-------------------------------------------------------------------------------------------------------------------------------------------------
###########################

## con_wave_7_tolerancia
##dataset_index = dataset[c( "rel_and_science_w7","dogood_both_w7",
##"Thisworld_both_w7",	"many_relig_w7",	"trust_w7")]
  
## sin_wave_7_tolerancia
dataset_index = dataset_relig_tol[c( "rel_and_science_uptow7","dogood_both_uptow7",
                                     "Thisworld_both_uptow7",	"many_relig_uptow7")]


dataset.corr = cor(dataset_index,use = "complete.obs")


# Plot con ggcorrplot
ggcorrplot(dataset.corr, method="square",
           type = "full", lab = T)



###### Componentes principales.




###########################
## Imputación múltiple                 ##-------------------------------------------------------------------------------------------------------------------------------------------------
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
