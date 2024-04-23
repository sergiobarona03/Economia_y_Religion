# Trabajo de grado. 
# Revisión base de datos WVS. Señor, ayúdame!!!

setwd("C:/Users/PC/Desktop/Economia_y_Religion/Version_2")

#install.packages("haven")
library(haven)
#install.packages("dplyr")
library(dplyr)
library(openxlsx)

# Descargar la base completa
WVS <- readRDS("WVS_trends_3_0.rds")

#Crear una base seleccionando las variables relevantes para nuestro estudio
# las variables a utilizar son las siguientes. 
# Se incluyen acá las variables utilizadas en el estudio de Sharma junto a la que queremos proponer

WVS_religion_sinW_7 <- select (WVS, wave=s002, 
                        #Wave de la 1 a la 7
                        
                        país=s003,
                        # Código del País
                        
                        Belong_Relorg_w2_4=a065,
                        # Belong to a religious organization
                        # 0- not a member
                        # 1- inactive member
                        # 2-active member
                        # We take 2
                        
                        
                        Member_Relorg=a098,
                        # Member of a religious organization
                        # 0- not a member
                        # 1- inactive member
                        # 2-active member
                        # We take 2
                        
                        pray=f028b,
                        # Apart from weddings and funerals, about how often do you pray? 
                        # 1- Several times a day
                        # 2- Once a day
                        # 3- Several times each week
                        # 4- Only when attending religious services
                        # 5-  Only on special holy days
                        # 6-  Once a year
                        # 7-  Less often
                        # 8- Never, practically never
                        # We take 1 - 4.
                        
                        
                        Imprelig=a006, 
                        # How important is religion un your life
                        # 1- Very important
                        # 2- Rather important
                        # 3- Not very important
                        # 4- Not at all important
                        
                        religattend=f028, 
                        # Apart from weddings and funerals, about how often do you attend religious services? 
                        # 1- More than once a week
                        # 2- Once a week
                        # 3- Once a month
                        # 4- Only on special holy days
                        # 5- Once a year
                        # 6- Less often
                        # 7- Never, practically never
                        
                        religpers=f034, 
                        # Independently of whether you attend religious services or not, would you say you are?
                        # 1- A religious person 
                        # 2- Not a religious person 
                        # 3- An atheist
                        
                        beliefgod=f050, 
                        # Do you believe in God?
                        # 1- Yes
                        # 2- No
                        # Los valores empiezan en 1 hasta -5 se asume que "1" sí "0" no. 
                        
                        impgod=f063, 
                        # How important is God in your life?
                        # Scale between
                        # (1)Not at all important - (10) Very important
                        
                        mrel_norms_dogood=f200,
                        #With which one of the following statements do you agree most?
                        # The basic meaning of religion is:
                        # 1. To follow religious norms and ceremonies
                        # 2. To do good to other people
                        # 3. Neither of them, other
                        # 4. Both
                        #We take 1 for intolerance. 
                        # We take 2 and 4 for tolerance. 
                        
                        mrel_afterdeath_thisworld=f201, 
                        #With which one of the following statements do you agree most?
                        # The basic meaning of religion is:
                        # 1. To make sense of life after death
                        # 2. To make sense of life in this world
                        # 3. Neither of them, other
                        # 4. Both
                        # We take 1 for intolerance
                        # We take 2 and 4 for tolerance. 
                        
                        
                        relright_sciencewrong=f202,
                        #  Whenever science and religion conflict, religion is always right
                        # 1- Strongly agree
                        # 2- Agree
                        # 3- Disagree
                        # 4- Strongly disagree
                        # we take 1 - 2 for intolerance.
                        # we take 3 - 4 for tolerance
                        
                        onlymyrel_accept=f203, 
                        # The only acceptable religion is my religion
                        # 1- Strongly agree
                        # 2- Agree
                        # 3 Disagree
                        # 4- Strongly disagree
                        # we take 1 - 2 for intolerance
                        # we take 3 - 4 for tolerance. 
                        
                        trust_people_another_rel=g007_34_b,
                        # Trust people of another religion
                        # 1- Trust completely
                        # 2- Trust somewhat
                        # 3- Do not trust very much
                        # 4 - Do not trust at all  
                        # we take 3 - 4 for intolerance
                        # we take 1 - 2 for tolerance. 
                        
          
                        
)

#Excluimos de la base la wave 7, los missing values y exportamos la información
WVS_religion_sinW_7 <- WVS_religion_sinW_7 %>% filter(wave!=7)
write.xlsx(WVS_religion_sinW_7,file= "Data/WVS_Data_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

#Posibles variables
Belong_relorg <- WVS_religion_sinW_7 %>% filter(Belong_Relorg_w2_4 %in% c(0,1))
Belong_relorg <- table(Belong_relorg$país, Belong_relorg$Belong_Relorg_w2_4)
Belong_relorg <- prop.table(Belong_relorg, margin=1)
Belong_relorg
write.xlsx(Belong_relorg,file= "Data/Belong_Relorg_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

Member_relorg <- WVS_religion_sinW_7 %>% filter(Member_Relorg %in% c(0,1,2))
Member_relorg <- table(Member_relorg$país, Member_relorg$Member_Relorg)
Member_relorg <- prop.table(Member_relorg, margin=1)
Member_relorg
write.xlsx(Member_relorg,file= "Data/Member_Relorg_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

pray <- WVS_religion_sinW_7 %>% filter(pray %in% c(1,2,3,4,5,6,7,8))
pray <- table(pray$país, pray$pray)
pray <- prop.table(pray, margin=1)
pray
write.xlsx(pray,file= "Data/pray_sin7.xlsx",rowNames =FALSE, colNames = TRUE)





#Variables de nuestra propuesta
trustanotherrel <- WVS_religion_sinW_7 %>% filter(trust_people_another_rel %in% c(1,2,3,4))
trustanotherrel <- table(trustanotherrel$país, trustanotherrel$trust_people_another_rel)
trust_anotherrel <- prop.table(trustanotherrel, margin=1)
trust_anotherrel
write.xlsx(trust_anotherrel,file= "Data/trust_another_rel_sin7.xlsx",rowNames =FALSE, colNames = TRUE)


religionacceptance <- WVS_religion_sinW_7 %>% filter(onlymyrel_accept %in% c(1,2,3,4))
religionacceptance <- table(religionacceptance$país, religionacceptance$onlymyrel_accept)
onlymyrel_acceptable <- prop.table(religionacceptance, margin=1)
onlymyrel_acceptable
write.xlsx(onlymyrel_acceptable,file= "Data/onlymyrel_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

relvsscience <- WVS_religion_sinW_7 %>% filter(relright_sciencewrong %in% c(1,2,3,4))
relvsscience <- table(relvsscience$país, relvsscience$relright_sciencewrong)
relright_sciencewrong <- prop.table(relvsscience, margin=1)
relright_sciencewrong
write.xlsx(relright_sciencewrong,file= "Data/rel_vs_science_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

meaningrel_normgood <-  WVS_religion_sinW_7 %>% filter(mrel_norms_dogood %in% c(1,2,3,4))
meaningrel_normgood <- table(meaningrel_normgood$país, meaningrel_normgood$mrel_norms_dogood)
mrel_norms_doggod <- prop.table(meaningrel_normgood, margin=1)
mrel_norms_doggod
write.xlsx(mrel_norms_doggod,file= "Data/meaning_norms_dogood_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

meaningrel_afterthisworld <- WVS_religion_sinW_7 %>% filter(mrel_afterdeath_thisworld %in% c(1,2,3,4))
meaningrel_afterthisworld <- table(meaningrel_afterthisworld$país, meaningrel_afterthisworld$mrel_afterdeath_thisworld)
mrel_aftherdeath_thisworld <- prop.table(meaningrel_afterthisworld, margin=1)
mrel_aftherdeath_thisworld
write.xlsx(mrel_aftherdeath_thisworld,file= "Data/meaning_after_this_sin7.xlsx",rowNames =FALSE, colNames = TRUE)


#variables Sharma
importance_god <- WVS_religion_sinW_7 %>% filter(impgod %in% c(1,2,3,4,5,6,7,8,9,10))
importance_god <- table(importance_god$país, importance_god$impgod)
impgod <- prop.table(importance_god, margin=1)
impgod
write.xlsx(impgod,file= "Data/impgod_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

believe <- WVS_religion_sinW_7 %>% filter(beliefgod %in% c(0,1))
believe <- table(believe$país, believe$beliefgod)
belief_god <- prop.table(believe, margin=1)
belief_god
write.xlsx(belief_god,file= "Data/belief_god_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

religiousperson <- WVS_religion_sinW_7 %>% filter(religpers %in% c(1,2,3))
religiousperson <- table(religiousperson$país, religiousperson$religpers)
religpersn <- prop.table(religiousperson, margin=1)
religpersn
write.xlsx(religpersn,file= "Data/religperson_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

religionattendance <- WVS_religion_sinW_7 %>% filter(religattend %in% c(1,2,3,4,5,6,7,8))
religionattendance <- table(religionattendance$país, religionattendance$religattend)
religattend <- prop.table(religionattendance, margin=1)
religattend
write.xlsx(religattend,file= "Data/religattendance_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

Importantrelig <- WVS_religion_sinW_7 %>% filter(Imprelig %in% c(1,2,3,4))
Importantrelig <- table(Importantrelig$país, Importantrelig$Imprelig)
imprel <- prop.table(Importantrelig, margin=1)
imprel
write.xlsx(imprel,file= "Data/imprel_sin7.xlsx",rowNames =FALSE, colNames = TRUE)

