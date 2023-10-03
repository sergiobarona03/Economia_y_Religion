
************* Replication Package (Climate_Relig.dta) *********** 

************ Table 2 ************
ssc install asdoc

asdoc su ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp if _mi_m==0 & sam==1

*Note: The figures are reported after rounding to two decimal places. As the number of observations is the same for all variables, it is reported in "notes" of Table 2 of the paper. 


************ Table 3 **************** 
ssc install estout

reg ccps relig_indx i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if sam==1 & _mi_m==0, r

estimates store m1
reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if sam==1 & _mi_m==0, r

estimates store m2
reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if sam==1 & _mi_m==0, r

estimates store m3
esttab m1 m2 m3 using Tab3, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (_cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) obslast nogaps onecell modelwidth(6) title(Table 3: Religiosity and the stringency of climate change policies)
drop _est_m1 _est_m2 _est_m3 


************ Table 4 **************** 

*---------- For replicating Column 1 ----------
*---------- For coefficients ----------
mi estimate: reg ccps relpers log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r 

*---------- For R-square ----------
*search mibeta and install
mibeta ccps relpers log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r 

*Note: As output table syntaxes such as estout or esttab are not compatible with imputation regression which is a specialized syntax, the results are noted from the stata output (coefficient of the main variable) and reported in the paper. 

*---------- For replicating Column 2 ----------
*---------- For coefficients ----------
mi estimate:reg ccps beliefgod log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r

*---------- For R-square ----------
mibeta ccps beliefgod log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r

*Note: As output table syntaxes such as estout or esttab are not compatible with imputation regression which is a specialized syntax, the results are noted from the stata output (coefficient of the main variable) and reported in the paper. 

*---------- For replicating Column 4 ----------
*-------- For coefficients ------- 
mi estimate:reg ccps relattend log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r

*-------- For R-square ------- 
mibeta ccps relattend log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r

*Note: As output table syntaxes such as estout or esttab are not compatible with imputation regression which is a specialized syntax, the results are noted from the stata output (coefficient of the main variable) and reported in the paper. 

*---------- For replicating Column 5 ----------
*-------- For coefficients ------- 
mi estimate:reg ccps imprel log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r

*-------- For R-square ------- 
mibeta ccps imprel log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP, r

*---------- For replicating Column 3 and Column 6 ----------

reg ccps impgod log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m3
reg ccps religimput log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m6
esttab m3 m6 using Tab4, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (log_GDP globaliz coalp_cap dmcry inst cc_percp _cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) obslast nogaps onecell modelwidth(6) title(Tabl3 4:Results based on imputed values of religiosity)
drop _est_m3 _est_m6


************ Table 5 **************** 

pwcorr relindx_wave1 relindx_wave2 relindx_wave3 relindx_wave4 relindx_wave5 relindx_wave6 relig_indx if _mi_m==0 , sig star(0.01) 
*Note: Output correlation coefficient with star shows the significance level of 0.01.  

pwcorr relindx_wave1 relindx_wave2 relindx_wave3 relindx_wave4 relindx_wave5 relindx_wave6 relig_indx if _mi_m==0, sig star(0.05)
*Note: Output correlation coefficient with star shows the significance level of 0.05.

*Note: Correlation coefficients are reported after rounding to two decimal places, the conventional symbols of significance levels are used while reporting the results in the paper: *, ** and *** indicate significance at the 10%, 5%, and 1% level, respectively. 


************ Table 6 **************** 

reg ccps relindx_wave6 log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m1
reg ccps relindx_new log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m2
reg ccps rscale_Inglehart log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m3
reg ccps relindex_alt log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m4
esttab m1 m2 m3 m4 using Tab6, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (log_GDP globaliz coalp_cap dmcry inst cc_percp _cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) obslast nogaps onecell title(Table 6: Alternative samples and measures of religiosity)
drop _est_m1 _est_m2 _est_m3 _est_m4 


************ Table 7 **************** 

*----Table 7: Columns 1, 2 & 3-------------

reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp Muslim_2010 Hindu_2010 Budhist_2010 Jewish_2010 Oth_Folk_2010 i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m1
reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp Muslim1900 Hindu1900 BudhEast1900 Jews1900 Othrel1900 i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m2
reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp i.hgwestern i.hglamerica i.hgorthodox i.hgeastern i.hgmuslim i.hgssafrica if _mi_m==0, r
estimates store m3
esttab m1 m2 m3 using Tab7_A, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (log_GDP globaliz coalp_cap dmcry inst cc_percp _cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) nobaselevels obslast nogaps onecell modelwidth(6) title(Table 7: Sensitivity to religious affiliations and civilizations)
drop _est_m1 _est_m2 _est_m3 


*----Table 7: Columns 4, 5 & 6-------------

reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0 & hgmuslim==0, r
estimates store m1
reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0 & hgorthodox==0, r
estimates store m2
reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0 & hgwestern==0, r
estimates store m3
esttab m1 m2 m3 using Tab7_B, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (log_GDP globaliz coalp_cap dmcry inst cc_percp _cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) obslast nogaps onecell modelwidth(6) title(Table 7: Sensitivity to religious affiliations and civilizations)
drop _est_m1 _est_m2 _est_m3  


************ Table 8 **************** 

reg ccps relig_indx scc log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m1
reg ccps relig_indx abat_cost log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m2
esttab m1 m2 using Tab8, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (log_GDP globaliz coalp_cap dmcry inst cc_percp _cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) obslast nogaps onecell modelwidth(6) title(Table 8: Sensitivity to climate change impacts and abatement cost)
drop _est_m1 _est_m2


**************** Table 9 **************** 

*______ Panel I _________

reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP if _mi_m==0, r
*ssc install psacalc
psacalc beta relig_indx, rmax(0.88) delta (1) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)
psacalc delta relig_indx, rmax(0.88) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)

*Note: Relevant figures from the Stata output are reported in Table 9 in the paper: uncontrolled and controlled coefficients, beta (as bias-adjusted effect), and delta.  

*______ Panel II _________

reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp Muslim_2010 Hindu_2010 Budhist_2010 Jewish_2010 Oth_Folk_2010 WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP if _mi_m==0, r
psacalc beta relig_indx, rmax( 0.89) delta (1) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)
psacalc delta relig_indx, rmax( 0.89) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)

*Note: Relevant figures from the Stata output are reported in Table 9 in the paper: uncontrolled and controlled coefficients, beta (as bias-adjusted effect), and delta. 

*______ Panel III _________

reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp Muslim1900 Hindu1900 BudhEast1900 Jews1900 Othrel1900 WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP if _mi_m==0, r
psacalc beta relig_indx, rmax(0.89) delta (1) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)
psacalc delta relig_indx, rmax(0.89) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)

*Note: Relevant figures from the Stata output are reported in Table 9 in the paper: uncontrolled and controlled coefficients, beta (as bias-adjusted effect), and delta. 

*______ Panel IV _________

reg ccps relig_indx scc log_GDP globaliz coalp_cap dmcry inst cc_percp WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP if _mi_m==0, r
psacalc beta relig_indx, rmax(0.88) delta (1) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)
psacalc delta relig_indx, rmax(0.88) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)

*Note: Relevant figures from the Stata output are reported in Table 9 in the paper: uncontrolled and controlled coefficients, beta (as bias-adjusted effect), and delta. 

*______ Panel V _________

reg ccps relig_indx abat_cost log_GDP globaliz coalp_cap dmcry inst cc_percp WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP if _mi_m==0, r
psacalc beta relig_indx, rmax(0.89) delta (1) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)
psacalc delta relig_indx, rmax(0.89) mcontrol(WB_EUCA WB_LAAC WB_MEANA WB_SAsia WB_SSAfrica WB_EAP)

*Note: Relevant figures (from the Stata output) are reported in Table 9 in the paper: uncontrolled and controlled coefficients, beta (as bias-adjusted effect), and delta. 


**************** Table A4 **************** 

reg ccps relpers log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r     
estimates store m1
reg ccps beliefgod log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m2
reg ccps impgod log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m3
reg ccps relattend log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m4
reg ccps imprel log_GDP globaliz coalp_cap dmcry inst cc_percp i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m5
esttab m1 m2 m3 m4 m5 using TabA4, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (_cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) obslast nogaps onecell modelwidth(6) title(Table A4: Distinct measures of religiosity and stringency of climate change policies)
drop _est_m1 _est_m2 _est_m3 _est_m4 _est_m5

************ Table A5 **************** 

reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp c.relig_indx#c.Muslim_2010 c.relig_indx#c.Hindu_2010 c.relig_indx#c.Budhist_2010 c.relig_indx#c.Jewish_2010 c.relig_indx#c.Oth_Folk_2010 i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m1
reg ccps relig_indx log_GDP globaliz coalp_cap dmcry inst cc_percp c.relig_indx#c.Muslim1900 c.relig_indx#c.Hindu1900 c.relig_indx#c.BudhEast1900 c.relig_indx#c.Jews1900 c.relig_indx#c.Othrel1900 i.WB_EUCA i.WB_LAAC i.WB_MEANA i.WB_SAsia i.WB_SSAfrica i.WB_EAP if _mi_m==0, r
estimates store m2
esttab m1 m2 using TabA5, rtf b(2) t(2) star(* 0.10 ** 0.05 *** 0.01) r2 drop (log_GDP globaliz coalp_cap dmcry inst cc_percp _cons *.WB_EUCA *.WB_LAAC *.WB_MEANA *.WB_SAsia *.WB_SSAfrica *.WB_EAP) nobaselevels obslast nogaps onecell modelwidth(6) title(Table A5: Sensitivity to religious affiliation interactions)
drop _est_m1 _est_m2 

