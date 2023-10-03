
#########################
## Economía y religión ##
#########################

library(readxl)
library(haven)
library(dplyr)

###################
## Base de datos ##---------------------------------------------------------------------------------------------------------------------------
###################

dataset = read_dta("D:\\Desktop\\Economia_y_Religion\\Climate_Relig.dta")

# Base de datos sin valores imputados
dataset_0 = dataset %>% filter(`_mi_m` ==  0)
 
# Base de datos con valores imputados (m = 1)
dataset_1 = dataset %>% filter(`_mi_m` ==  1)
