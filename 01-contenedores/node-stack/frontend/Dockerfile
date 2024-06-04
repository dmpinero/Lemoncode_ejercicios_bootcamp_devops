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