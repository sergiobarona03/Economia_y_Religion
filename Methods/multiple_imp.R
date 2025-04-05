
##------------------------------------------##
## Imputación múltiple de valores faltantes ##
##------------------------------------------##

# Definir directorio de trabajo
setwd("C:/Users/Portatil/Desktop/Economia_y_Religion/Version_2")

# Preparar input
dataset_relig_tol <- read_excel("STATA_Relig_Tolerance_Climate (Regiones).xlsx") %>%
  filter(`_mi_m` == 0) %>%
  mutate(
    id = row_number(),
    sam_uptow6 = if_else(is.na(Relig_Tol_uptow6), 0, sam_uptow6),
    sam_uptow7 = if_else(is.na(Relig_Tol_uptow7), 0, sam_uptow7),
    sam_onlyw6 = if_else(is.na(Relig_Tol_onlyw6), 0, sam_onlyw6),
    sam_onlyw7 = if_else(is.na(Relig_Tol_onlyw7), 0, sam_onlyw7)
  ) %>%
  filter(sam_uptow7 == 1 | is.na(sam_uptow7))

# Imputación
no.imp = dataset_relig_tol

var = c("id", "country", "ccps", "Relig_Tol_uptow7",
        "log_GDP", "globaliz", "coalp_cap",  "dmcry",  "inst",
        "WB_EUCA", "WB_LAAC", "WB_MEANA", "WB_SAsia", 
        "WB_SSAfrica", "WB_EAP")

# Stochastic regression imputation
no.imp = no.imp[c(var, "Thisworld_both_uptow7", "dogood_both_uptow7",
                  "rel_and_science_uptow7", "many_relig_uptow7")]

imp <- mice(no.imp, method = "norm.nob", m = 5) 

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



