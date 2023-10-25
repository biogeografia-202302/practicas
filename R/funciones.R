evaluar_arbol <- function(arbol, num_optimo_por_anchsil) {
  # Verificar si hay grupos con 2 elementos o menos al cortar en el número óptimo
  grupos <- cutree(arbol, num_optimo_por_anchsil)
  tabla_grupos <- table(grupos)
  
  if (all(tabla_grupos > 2)) {
    return(paste(
      "Árbol útil para análisis posteriores, siempre que se corte en", num_optimo_por_anchsil, "grupos"))
  } else if (num_optimo_por_anchsil >= 3) {
    for (k in seq(num_optimo_por_anchsil, 2, by = -1)) {
      grupos <- cutree(arbol, k)
      tabla_grupos <- table(grupos)
      if (all(tabla_grupos > 2)) {
        return(paste("Árbol útil para análisis posteriores, siempre que se corte en", k, "grupos"))
      }
    }
    return("Árbol no recomendado para usarse por producir grupos compuestos por dos elementos o menos")
  } else {
    return("Árbol no recomendado para usarse por producir grupos compuestos por dos elementos o menos")
  }
}

seleccionar_y_cortar_arbol <- function(arbol_upgma = lista_cl$cl_upgma, arbol_ward = lista_cl$cl_ward,
                                       resultado_evaluacion_upgma, resultado_evaluacion_ward) {
  # Extraer el número de grupos sugerido de las cadenas de texto
  num_grupos_upgma <- as.numeric(sub(".*corte en (\\d+) grupos.*", "\\1", resultado_evaluacion_upgma))
  num_grupos_ward <- as.numeric(sub(".*corte en (\\d+) grupos.*", "\\1", resultado_evaluacion_ward))
  
  # Aplicar las reglas especificadas para determinar qué árbol cortar y en cuántos grupos
  if (resultado_evaluacion_upgma == "Árbol no recomendado para usarse por producir grupos compuestos por dos elementos o menos" && 
      resultado_evaluacion_ward == "Árbol no recomendado para usarse por producir grupos compuestos por dos elementos o menos") {
    return(cutree(arbol_ward, 3))
  } else if (resultado_evaluacion_upgma == "Árbol no recomendado para usarse por producir grupos compuestos por dos elementos o menos") {
    return(cutree(arbol_ward, num_grupos_ward))
  } else if (resultado_evaluacion_ward == "Árbol no recomendado para usarse por producir grupos compuestos por dos elementos o menos") {
    return(cutree(arbol_upgma, num_grupos_upgma))
  } else if (!is.na(num_grupos_upgma) && !is.na(num_grupos_ward) && num_grupos_upgma == num_grupos_ward) {
    return(cutree(arbol_ward, num_grupos_ward))
  } else if (!is.na(num_grupos_upgma) && !is.na(num_grupos_ward)) {
    if (num_grupos_upgma < num_grupos_ward) {
      return(cutree(arbol_upgma, num_grupos_upgma))
    } else {
      return(cutree(arbol_ward, num_grupos_ward))
    }
  }
}
