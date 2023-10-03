
##################################
## PCA Lab: James et al. (2014) ##
##################################

install.packages("ISLR")
library(MASS)
library(ISLR)

# Principal components analysis
states = row.names(USArrests)

# Las medias y varianzas son significativamente distintas
apply(USArrests, 2, mean)
apply(USArrests, 2, var)

# Implementar el análisis de componentes principales
pr.out = prcomp(USArrests, scale = TRUE)

# Nota: center corresponde a la media (el resultado es un proceso centrado: media cero)
# scale corresponde a la desviación estándar (estandarización)
pr.out$center
pr.out$scale

# La matriz de rotación muestra los loadings:
pr.out$rotation

# Existe cuatro componentes principales (tal que XF = Z). Nótese que
# hay min(n-1, p) componentes principales informativos

# The principal component score vectors están en la matriz X (the kth column is the kth PCscore vecto)
pr.out$x

# Los dos primeros componentes principales se pueden graficar así:
biplot(pr.out, scale = 0)

# Para replicar la representación, se puede 

