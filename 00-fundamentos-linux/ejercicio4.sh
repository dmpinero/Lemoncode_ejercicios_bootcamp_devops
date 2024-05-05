#!/bin/bash
mkdir -p ejercicio4

URL=http://metaphorpsum.com/paragraphs/3
OUTPUT_URL=./ejercicio4/metaphorpsum.com.txt

if [[ $# -lt 1 ]]; then
  echo "Es necesario al menos 1 parámetro"
else
  $(curl $URL -o $OUTPUT_URL)
  OCCURS=$(grep -io $1 $OUTPUT_URL | wc -l) # Número de ocurrencias
  FIRST_LINE=$(grep -m 1 -n $1 $OUTPUT_URL | cut -d: -f1) # Primera línea en la que aparece
  
  if [[ $OCCURS -lt 1 ]]; then
    echo "No se ha encontrado la palabra \"$1\""
  else
    echo "La palabra \"$1\" aparece $OCCURS veces"
    echo "Aparece por primera vez en la línea $FIRST_LINE"
  fi
fi