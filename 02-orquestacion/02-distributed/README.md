# Ingress

## Enunciado

Construir los distintos recursos de Kubernetes para generar un clúster, como el de la siguiente imagen:

![distributed](./distributed.png)

### Para ello seguir los siguientes pasos:

### Paso 0. Crear imágenes y comprobar solución con Docker.

### Solución

#### X. Crear imagen todo-api
```bash
docker build -f todo-api/Dockerfile -t dmpinero/todo-api-distributed:v1 todo-api/
```
![contenedor-todo-api](./images/contenedor-todo-api.png)

#### X. Subir imagen todo-api a repositorio github
```bash
docker push dmpinero/todo-api-distributed:v1
```
![subir-imagen-todo-api-dockerhub](./images/subir-imagen-todo-api-dockerhub.png)

#### X. Arrancar contenedor en base a la imagen creada
```bash
docker run -d -p 3000:3000 \
-e NODE_ENV=production \
-e PORT=3000 \
--name todo-api-distributed \
dmpinero/todo-api-distributed:v1
```

#### X. Crear archivo .env dentro de la carpeta 02-distributed\todo-front\src
![env.production todo-front](./images/archivo-todo-front.env.png)

##### El contenido del archivo todo-front.env.production es
![env.production todo-front contenido](./images/archivo-todo-front.env-contenido.png)

#### X. Crear archivo .env dentro de la carpeta 02-distributed\todo-front\src
![env.production todo-front](./images/archivo-todo-front.env.png)

##### El contenido del archivo todo-front.env.production es
![env.production todo-front contenido](./images/archivo-todo-front.env-contenido.png)

#### X. Crear imagen todo-front
```bash
docker build -f todo-front/Dockerfile -t dmpinero/todo-front-distributed:v1 todo-front/
```
![contenedor-todo-front](./images/contenedor-todo-front.png)

#### X. Subir imagen todo-api a repositorio github
```bash
docker push dmpinero/todo-front-distributed:v1
```
![subir-imagen-todo-front-dockerhub](./images/subir-imagen-todo-front-dockerhub.png)

#### X. Arrancar contenedor en base a la imagen creada
```bash
docker build --build-arg="API_HOST=http://localhost:3000" -f todo-front/Dockerfile -t dmpinero/todo-front-distributed:v1 todo-front/
```

#### X. Comprobar que las imágenes están creadas
```bash
docker image ls | grep "[^c]distributed"
```
![comprobar-imagenes-todo-api-todo-front](./images/comprobar-imagenes-todo-api-todo-front.png)

#### Acceder a http://localhost:8081 en un navegador y añadir algunas tareas
![todo-app-front-web-browser](./images/todo-app-front-web-browser.png)

#### Acceder a http://localhost:3000 en un navegador y recuerar vía API las tareas creadas
![todo-app-api-browser](./images/todo-app-api-web-browser.png)

### Paso 1. Crear todo-front.

Crear un `Deployment` para `todo-front`, usar el `Dockerfile` de este directorio **02-distributed/todo-front**, para generar la imagen necesaria. Notar que existe `ARG API_HOST` dentro del fichero `Dockerfile`, lo podemos omitir en este caso, sólo está ahí para poder probar el contenedor de Docker en local.

Al ejecutar un contenedor a partir de la imagen anterior, el puerto expuesto para http es el 80. 

Crear un `Cluster IP Service` que exponga `todo-front` dentro del clúster.

### Solución

#### Crear carpeta manifests para incluir los archivos .yaml
```bash
mkdir manifests
cd manifests
```

#### Para conectar Frontend y Backend construir la imagen dmpinero/todo-front-distributed:v2 image con la ejecución del siguiente comando
```bash
$ cd todo-front
$ docker build --build-arg="API_HOST=http://lc.todo.info" -t dmpinero/todo-front-distributed:v2 .
Subir al repositorio de Docker Hub la imagen creada: $ docker push dmpinero/todo-front-distributed:v2
```
![subir-imagen-todo-front-v2-dockerhub](./images/subir-imagen-todo-front-v2-dockerhub.png)

#### Arrancar cluster minikube y habilitar NGINX Ingress controller
```bash
$ minikube start
$ minikube addons enable ingress
$ minikube addons enable minikube addons enable ingress-dns
```
![verificar-ingress](./images/verificar-ingress.png)

#### X. Crear namespace
![namespace](./images/todo-namespace.yaml.png)

#### X. Crear deployment para todo-front
![front deployment](./images/front/todo-app-front-deployment.yaml.png)

#### X. Crear service para todo-front
![front service](./images/front/todo-app-front-service.yaml.png)


### Paso 2. Crear todo-api.

Crear un `Deployment` para `todo-api`, usar el `Dockerfile` de este directorio **02-distributed/todo-api**, para generar la imagen necesaria.

Al ejecutar un contenedor a partir de la imagen anaterior, el puerto por defecto es el 3000, pero se lo podemos alimentar a partir de  variables de entorono, las variables de entorno serían las siguientes

* **NODE_ENV** : El entorno en que se está ejecutando el contenedor, nos vale cualquier valor que no sea `test`
* **PORT** : El puerto por el que va a escuchar el contenedor

(_Opcional_) Crear un `ConfigMap` que exponga las variables de entorno anteriores. 

Crear un `Cluster IP Service` que exponga `todo-api` dentro del clúster.

### Solución

#### X. Crear configmap para todo-api
![api configmap](./images/api/todo-app-api-configmap.yaml.png) 

#### X. Crear deployment para todo-api
![api deploymnent](./images/api/todo-app-api-deployment.yaml.png) 

#### X. Crear service para todo-api
![api service](./images/api/todo-app-api-service.yaml.png)

### Paso 3. Crear un Ingress para acceder a los servicios del clúster
Crear un `Ingress` para exponer los servicios anteriormente creados. Como referencia para crear este controlardor con `minikube` tomar como referencia el siguiente ejemplo [Set up Ingress on Minikube with the NGINX Ingress Controller](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)

### Solución
![ingress](./images/todo-ingress.yaml.png)

#### X. Desplegar
  kubectl apply -f .
![todo-app-probe](./images/todo-app-kubectl-probe.png)

#### X. Verificar despliegue
```bash
kubectl get -f .
```
![todo-app-probe2](./images/todo-app-kubectl-probe2.png)

#### X. Verificar pods
```bash
kubectl get pods
```
![todo-app-probe2](./images/todo-app-kubectl-probe-pods.png)

#### X. Verificar que el servicio todo-app-api-service está creado y disponible en el node port
```bash
kubectl get service todo-app-api-service
```
![todo-app-api-service-probe](./images/todo-app-api-service-probe.png)

#### Acceder al servicio todo-app-api-service vía NodePort
```bash
minikube service todo-app-api-service
```
![todo-app-api-service-probe-Nodeport](./images/todo-app-api-service-probe-Nodeport.png)