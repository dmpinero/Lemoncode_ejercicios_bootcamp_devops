#!/bin/bash
mkdir -p ejercicio5

URL=$1
OUTPUT_URL=./ejercicio5/metaphorpsum.com.txt

if [[ $# -ne 2 ]]; then
  echo "Se necesitan únicamente dos parámetros para ejecutar este script"
else
  $(curl $URL -o $OUTPUT_URL)
  OCCURS=$(grep -io $2 $OUTPUT_URL | wc -l) # Número de ocurrencias
  FIRST_LINE=$(grep -m 1 -n $2 $OUTPUT_URL | cut -d: -f1) # Primera línea en la que aparece
  
  if [[ $OCCURS -lt 1 ]]; then
    echo "No se ha encontrado la palabra \"$2\""
  else
    if [[ $OCCURS -eq 1 ]]; then
      echo "La palabra \"$2\" aparece $OCCURS vez"
      echo "Aparece únicamente en la línaa $FIRST_LINE"
    else
      echo "La palabra \"$2\" aparece $OCCURS veces"
      echo "Aparece por primera vez en la línea $FIRST_LINE"
    fi
  fi
fi