#!/bin/bash

# Borrar directorio foo
rm -rf foo

# Ejercicio 1
mkdir -p foo/dummy foo/empty
touch foo/dummy/file1.txt foo/dummy/file2.txt
echo "Me encanta la bash!!" > foo/dummy/file1.txt

# Ejercicio 2
cp foo/dummy/file1.txt foo/dummy/file2.txt
mv foo/dummy/file2.txt foo/empty/file2.txt

# Si hay algún parámetro informado se establece el valor de file1.txt con el valor de parámetro
# Si no hay ningún parámetro informado se establece el valor de file1.txt con el texto Que me gusta la bash!!!!
if [[ $# -eq 1 ]]; then
  echo $1 > foo/dummy/file1.txt
else
    TEXTO="Que me gusta la bash!!!!"
    echo $TEXTO > foo/dummy/file1.txt
    echo $TEXTO > foo/empty/file2.txt
    #echo "Que me gusta la bash!!!!" > foo/dummy/file1.txt
fi