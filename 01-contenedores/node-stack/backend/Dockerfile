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