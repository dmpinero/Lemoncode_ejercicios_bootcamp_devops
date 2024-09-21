# Laboratorio Módulo 2 - Contenedores
## Ejercicio 1
### Dockeriza la aplicación dentro de lemoncode-challenge, la cual está compuesta de 3 partes:

- Un front-end con Node.js
- Un backend en .NET (dotnet-stack) o en Node.js (node-stack) que utiliza un MongoDB para almacenar la información.
El MongoDB donde se almacena la información en una base de datos.

Nota: como has podido comprobar, el directorio lemoncode-challenge tiene dos carpetas: dotnet-stack y node-stack. En ambos casos el frontend es el mismo, sólo cambia el backend. Usa el stack que prefieras.

## Requisitos del ejercicio
1. Los tres componentes deben estar en una red llamada lemoncode-challenge.
### Solución
```bash
docker network create lemoncode-challenge
```

2. El backend debe comunicarse con el mongodb a través de esta URL mongodb://some-mongo:27017.
### Crear archivo .dockerignore dentro de la carpeta backend\src con el siguiente contenido
```bash
.devcontainer
node_modules
Dockerfile
```
### Crear archivo .dockerignore dentro de la carpeta frontend con el siguiente contenido
```bash
.devcontainer
node_modules
Dockerfile
```

### Crear el archivo Dockerfile dentro del directorio backend con el siguiente contenido
```bash
# Imagen base
FROM node:18 AS builder

# Directorio de trabajo del contenedor
WORKDIR /opt/build

# Copiar contenido de node-stack/backend (host) a /opt/build (contenedor)
COPY . .

# Limpiar (c) e instalar dependencias (i) de frontend
RUN npm ci

# Ejecutar comando para crear carpeta node_modules
RUN npm run build

# Imagen base
FROM node:18

# Directorio de trabajo del contenedor
WORKDIR /opt/app

# Copiar desde la imagen previa el contenido de la carpeta /opt/build/dist (contenedor builder) a /opt/app (contenedor)
COPY --from=builder /opt/build/dist .

# Copiar todos los archivos con extensión .json desde la carpeta node-stack/backend (host) a /opt/app (contenedor)
COPY ./*.json .

# Limpiar (c) e instalar dependencias (i) de frontend. Solo las dependencias (apartado dependencies) del archivo package.json
RUN npm ci --only-production

# Puerto que expone la aplicación
EXPOSE 5000

# Ejecutar el archivo app.js con node para levantar la aplicación
CMD [ "node", "app.js" ]
```

### Crear imagen de backend con nombre topics-api
```bash
docker build -t backend-node .
```

### Levantar contenedor de backend
```bash
docker run -d \
-e DATABASE_URL="mongodb://root:lemoncode@some-mongo:27017" \
--name topics-api \
--network lemoncode-challenge \
backend-node
```

3. El front-end debe comunicarse con la api a través de http://topics-api:5000/api/topics.
### Crear el archivo Dockerfile dentro del directorio frontend con el siguiente contenido
```bash
# Imagen base
FROM node:18

# Directorio de trabajo del contenedor
WORKDIR /opt/build

# Copiar contenido de node-stack/frontend (host) a /opt/build (contenedor)
COPY . .

# Limpiar (c) e instalar dependencias (i) de frontend. Solo las dependencias (apartado dependencies) del archivo package.json
RUN npm ci --only-production

# Puerto que expone la aplicación
EXPOSE 3000

# Ejecutar el archivo app.js con node para levantar la aplicación
CMD [ "node", "server.js" ]
```

4. El front-end debe estar mapeado con el host para ser accesible a través del puerto 8080.
### Crear imagen de frontend con nombre frontend-node-challenge
```bash
docker build -t frontend-node-challenge .
```

### Levantar contenedor frontend
```bash
docker run -d \
-p 8080:3000 \
--name front-end-node-challenge \
--network lemoncode-challenge \
-e API_URI=http://topics-api:5000/api/topics \
frontend-node-challenge
```

5. El MongoDB debe almacenar la información que va generando en un volumen, mapeado a la ruta /data/db.
```bash
docker run --name some-mongo \
-e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=lemoncode \
--network lemoncode-challenge \
-v datosmongo:/data/db \
-d mongo:latest
```

6. Este debe de tener una base de datos llamada TopicstoreDb con una colección llamada Topics. La colección Topics debe tener esta estructura:
`
{
  "_id": { "$oid" : "5fa2ca6abe7a379ec4234883" },
  "topicName" : "Contenedores"
}
`
¡Añade varios registros!

### Insertar datos en mongodb a través de mongosh
```bash
docker exec -it some-mongo mongosh --username root --password lemoncode
```

### Crear la colección TopicstoreDb y comprobar que se ha creado correctamente
```bash  
  db.createCollection("TopicstoreDb")
```

### Cambiar a la base de datos creada e insertar los 2 registros necesarios
```bash
use TopicstoreDb
		
		db.Topics.insertMany([  
  {
    topicName: "Docker",
  },
  {
    topicName: "Kubernetes",
  }
])
```

### Verificar que se han insertado los 2 registros
```bash
db.Topics.find()
```

Tip para backend: Antes de intentar contenerizar y llevar a cabo todos los pasos del ejercicio se recomienda intentar ejecutar la aplicación sin hacer cambios en ella. En este caso, lo único que es posible que “no tengamos a mano” es el MongoDB. Por lo que empieza por crear este en Docker, usa un cliente como el que vimos en el primer día de clase (MongoDB Compass) para añadir datos que pueda devolver la API.

Mongo compass

Nota: es más fácil si abres Visual Studio Code desde la carpeta backend para hacer las pruebas y las modificaciones que si te abres desde la raíz del repo. Para ejecutar este código solo debes lanzar dotnet run si usas el stack de .NET, o npm install && npm start si usas el stack de Node.js.

Tip para frontend: Para ejecutar el frontend abre esta carpeta en VS Code y ejecuta primero npm install. Una vez instaladas las dependencias ya puedes ejecutarla con npm start. Debería de abrirse un navegador con lo siguiente:

Topics

Ejercicio 2
Ahora que ya tienes la aplicación del ejercicio 1 dockerizada, utiliza Docker Compose para lanzar todas las piezas a través de este. Debes plasmar todo lo necesario para que esta funcione como se espera: la red que utilizan, el volumen que necesita MongoDB, las variables de entorno, el puerto que expone la web y la API. Además debes indicar qué comandos utilizarías para levantar el entorno, pararlo y eliminarlo.

### Solución
### Crear archivo node-stack\docker-compose.yaml con el siguiente contenido
```bash  
services:
  some-mongo:
    container_name: some-mongo
    image: mongo:latest
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root 
      - MONGO_INITDB_ROOT_PASSWORD=lemoncode
    networks:
      - lemoncode-challenge
    volumes:
      - datosmongo:/data/db

  topics-api:
    build: backend/.
    container_name: topics-api
    image: backend-node
    environment:
      - DATABASE_URL=mongodb://root:lemoncode@some-mongo:27017
      - MONGO_INITDB_ROOT_PASSWORD=lemoncode
    networks:
      - lemoncode-challenge

  frontend-node-challenge:
    build: frontend/.
    container_name: front-end-node-challenge
    networks:
      - lemoncode-challenge
    environment:
      - API_URI=http://topics-api:5000/api/topics
    ports:
      - 8080:3000
      
networks:
  lemoncode-challenge:
    name: lemoncode-challenge
    driver: bridge

volumes:
    datosmongo:
      name: datosmongo  
```

### Levantar contenedores declarados en docker-compose.yaml 
```bash
docker-compose up -d
```

### Parar contenedores y borrarlos
```bash
docker-compose down
```