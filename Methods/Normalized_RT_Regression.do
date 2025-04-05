
************* Replication Package (Climate_Relig.dta) *********


******Codigo Tolerancia Religiosa********

log using "C:/Users/Portatil/Desktop/Economia_y_Religion/Output/RT_regression/sample_n0_normalized_rt.log", replace text

import excel "C:/Users/Portatil/Desktop/Economia_y_Religion/Version_2/STATA_Weighted_Relig_Tolerance_Climate (Regiones).xlsx", firstrow clear


************ Estadísticas descriptivas ************
ssc install asdoc

*Estadísticas descriptivas de todas las variables

asdoc su  ccps W_RTI_normalized  rel_and_science_uptow7 dogood_both_uptow7 Thisworld_both_uptow7 many_relig_uptow7 log_GDP globaliz coalp_cap dmcry inst cc_percp if _mi_m==0 & sam_uptow7==1


********* Regresiones_no robustas**********

** up to w7

reg ccps W_RTI_normalized i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if sam_uptow7==1 & _mi_m==0

reg ccps W_RTI_normalized  log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if sam_uptow7==1 & _mi_m==0


** por regiones

**crear variable categórica

encode Regiones, gen(regiones)

reg ccps c.W_RTI_normalized##regiones if sam_uptow7==1 & _mi_m==0

reg ccps c.W_RTI_normalized##regiones log_GDP globaliz coalp_cap dmcry inst cc_percp if sam_uptow7==1 & _mi_m==0


log close




