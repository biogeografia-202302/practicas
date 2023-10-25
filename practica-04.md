Practica 2. Describe resultados de ecología numérica
================
<b>José-Ramón Martínez-Batlle</b> (<jmartinez19@uasd.edu.do>) <br>
Facultad de Ciencias, Universidad Autónoma de Santo Domingo (UASD) <br>
Santo Domingo, República Dominicana

<!-- README.md se genera a partir de README.Rmd. Por favor, edita ese archivo. -->

> Fecha de entrega: 7 de noviembre, 23:59 horas.

> Entrega tu práctica en archivo(s) en formato nativo (editable) del
> programa que hayas usado y, opcionalmente, en formato PDF. Por
> ejemplo, si trabajaste tu documento en Microsoft Word, envía el
> correspondiente archivo .docx o .doc. Si lo hiciste en LibreOffice
> Writer, envía el archivo .odt o el que corresponda, pero que sea
> nativo y editable. Si trabajaste en LaTeX, envía el archivo .tex y los
> asociados a éste.

``` r
# Cargar las bibliotecas necesarias
library(tidyverse)
library(vegan)

# Leer la lista de estudiantes
estudiantes <- read_csv("fuentes/practica-04/lista-de-estudiantes.csv")

# Función para generar matrices
generar_matrices <- function(aleatorizacion) {
  # Crear matriz de comunidad binaria aleatoria
  set.seed(aleatorizacion)
  comunidad <- matrix(sample(c(0,1), 150, replace=TRUE), nrow=15)
  colnames(comunidad) <- paste0("sp", sprintf("%02d", 1:10))
  
  # Crear matriz ambiental aleatoria
  set.seed(aleatorizacion)
  ambiental <- matrix(runif(60), nrow=15)
  colnames(ambiental) <- paste0("var", 1:4)
  
  # Elegir aleatoriamente especies y variables para asociación
  set.seed(aleatorizacion)
  especies_assoc1 <- sample(1:10, 4, replace=FALSE)
  especies_assoc2 <- setdiff(1:10, especies_assoc1)[1:4]
  
  set.seed(aleatorizacion)
  vars_assoc1 <- sample(1:4, 2, replace=FALSE)
  vars_assoc2 <- setdiff(1:4, vars_assoc1)
  
  # Reordenar
  orden_vars_assoc1 <- order(ambiental[,vars_assoc1[1]] + ambiental[,vars_assoc1[2]])
  comunidad[orden_vars_assoc1[1:4], especies_assoc1] <- 1
  
  # Reordenar
  orden_vars_assoc2 <- order(ambiental[,vars_assoc2[1]] + ambiental[,vars_assoc2[2]])
  comunidad[orden_vars_assoc2[1:4], especies_assoc2] <- 1
  
  return(list(comunidad = comunidad, ambiental = ambiental))
}

# Generar matrices para cada estudiante y guardar en una lista
resultados <- lapply(1:nrow(estudiantes), function(x) {
  matrices <- generar_matrices(aleatorizacion = x)
  list(
    nombre = iconv(
      gsub(" ", "-", estudiantes[x, "Nombres y apellidos"]),
      from = "UTF-8", to = "ASCII//TRANSLIT"),
    comunidad = matrices$comunidad,
    ambiental = matrices$ambiental)
})

# Guardar resultados en archivos CSV para cada estudiante
for (res in resultados) {
  write.csv(res$comunidad, paste0("fuentes/practica-04/matriz-comunidad-", res$nombre, ".csv"))
  write.csv(res$ambiental, paste0("fuentes/practica-04/matriz-ambiental-", res$nombre, ".csv"))
}
```

## 

## Describe resultados de análisis de agrupamiento

Estas preguntas te podrían guiar:

-   Las unidades muestrales, ¿se organizan en grupos diferenciados según
    la composición de las especies de hormigas?

-   Si existe algún patrón, ¿es consistente con alguna variable de la
    matriz ambiental?

-   ¿Hay especies indicadoras o con preferencia por determinadas
    variables?

## Describe resultados de técnicas de ordenación

Estas preguntas te podrían guiar:

-   En un espacio bidimensional, ¿existen tendencias apreciables de
    ordenación de las especies?

-   Si existen tendencias de ordenación, ¿se asocian éstas con
    determinadas variables?

## Describe resultados de análisis de diversidad + análisis de agrupamiento

Estas preguntas te podrían guiar:

-   Según los análisis de estimación de riqueza, ¿está suficientemente
    representada la comunidad? Consideremos como buena representación un
    80% del total esperado.

-   ¿Es la riqueza esperada mayor o menor según en qué hábitats
    (caracterizados según variables) nos encontremos?

-   ¿Existe asociación de la diversidad alpha con las variables, es
    decir, es mayor o menor la diversidad alpha según en qué grupo de
    muestras nos encontremos?

-   ¿Existe contribución local o por alguna especie a la diversidad
    beta?

## Criterios de evaluación y escala de valoración

## Referencias
