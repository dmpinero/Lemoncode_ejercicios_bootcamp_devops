# Laboratorio Módulo 1 - Linux
# Ejercicios

## Ejercicios CLI

### 1. Crea mediante comandos de bash la siguiente jerarquía de ficheros y directorios

```bash
foo/
├─ dummy/
│  ├─ file1.txt
│  ├─ file2.txt
├─ empty/
```

Donde `file1.txt` debe contener el siguiente texto:

```bash
Me encanta la bash!!
```

Y `file2.txt` debe permanecer vacío.

### Solución
```bash
# Crear directorios
mkdir -p foo/dummy foo/empty

# Crear archivos
touch foo/dummy/file1.txt foo/dummy/file2.txt

# Crear contenido en archivo foo/dummy/file1.txt
echo "Me encanta la bash\!\!" > foo/dummy/file1.txt
```

### 2. Mediante comandos de bash, vuelca el contenido de file1.txt a file2.txt y mueve file2.txt a la carpeta empty

El resultado de los comandos ejecutados sobre la jerarquía anterior deben dar el siguiente resultado.

```bash
foo/
├─ dummy/
│  ├─ file1.txt
├─ empty/
  ├─ file2.txt
```

Donde `file1.txt` y `file2.txt` deben contener el siguiente texto:

```bash
Me encanta la bash!!
```

### Solución
```bash

# Copiar contenido de archivo foo/dummy/file1.txt en archivo foo/dummy/file2.txt
cp foo/dummy/file1.txt foo/dummy/file2.txt

# Mover archivo file2.txt a directorio foo/empty 
mv foo/dummy/file2.txt foo/empty/file2.txt
```

### 3. Crear un script de bash que agrupe los pasos de los ejercicios anteriores y además permita establecer el texto de file1.txt alimentándose como parámetro al invocarlo

Si se le pasa un texto vacío al invocar el script, el texto de los ficheros, el texto por defecto será:

```bash
Que me gusta la bash!!!!
```
### Solución
```bash
# Invocación sin parámetros
./ejercicio3.sh

#Invocación con 1 parámetro
./ejercicio3.sh "Texto de file1"
```

### 4. Crea un script de bash que descargue el contenido de una página web a un fichero y busque en dicho fichero una palabra dada como parámetro al invocar el script

La URL de dicha página web será una constante en el script.

Si tras buscar la palabra no aparece en el fichero, se mostrará el siguiente mensaje:

```bash
$ ejercicio4.sh patata
> No se ha encontrado la palabra "patata"
```

Si por el contrario la palabra aparece en la búsqueda, se mostrará el siguiente mensaje:

```bash
$ ejercicio4.sh patata
> La palabra "patata" aparece 3 veces
> Aparece por primera vez en la línea 27
```

### Solución
```bash
# Invocación con palabra que SÍ existe
 ./ejercicio4.sh the

# Invocación con palabra que NO existe
./ejercicio4.sh patata
```

### 5. OPCIONAL - Modifica el ejercicio anterior de forma que la URL de la página web se pase por parámetro y también verifique que la llamada al script sea correcta

Si al invocar el script este no recibe dos parámetros (URL y palabra a buscar), se deberá de mostrar el siguiente mensaje:

```bash
$ ejercicio5.sh https://lemoncode.net/ patata 27
> Se necesitan únicamente dos parámetros para ejecutar este script
```

Además, si la palabra sólo se encuentra una vez en el fichero, se mostrará el siguiente mensaje:

```bash
$ ejercicio5.sh https://lemoncode.net/ patata
> La palabra "patata" aparece 1 vez
> Aparece únicamente en la línea 27
```

### Solución
```bash
# Invocación con un parámetro
./ejercicio5.sh the

# Invocación con más de 2 parámetros 
./ejercicio5.sh http://metaphorpsum.com/paragraphs/3 the parametro_3

#Invocación correcta (2 parámetros) 
./ejercicio5.sh http://metaphorpsum.com/paragraphs/3 the
```
