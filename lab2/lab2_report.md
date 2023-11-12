#### University: [ITMO University](https://##3itmo.ru/ru/)
#### Faculty: [FICT](https://fict.itmo.ru)
#### Course: Cloud Systems and Services
#### Year: 2023/2024
#### Group: K34212
#### Authors: Kostenko Darina Alekseevna & Spevak Elena Aleksandrovna & Guseynov Guseyn
#### Lab: Lab2

# **Отчёт по лабораторной работе №2**
# Работа с Kubernetes

**Цель работы:** поднять локально kubernetes кластер, развернуть в нем сервис с использованием 2-3 ресурсов kubernetes.

**Ход работы**

Для выполнения работы были установлены инструмент командной строки Kubernetes kubectl  и инструмент для запуска  Kubernetes Minikube. Так же был использован Docker.

- **kubectl**
  Инструмент позволяет запускать команды для кластеров Kubernetes. 

  Для установки был загружен [файл](https://dl.k8s.io/release/v1.28.3/bin/windows/amd64/kubectl.exe) с последней версией иснтумента (1.28.3). 

- **Docker**
 В качестве гипервизора для виртуализации был использован движок Docker. В его настройках была настроена поддержка Kubernetes.

![docker](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/screenshots/docker.png)

- **Minikube**
  Это инструмент для запуска одноузлового кластера Kubernetes на виртуальной машине.

  Данный инстурмент был так же установлен из [пакета](https://github.com/kubernetes/minikube/releases/latest/download/minikube-installer.exe).

После установки всего необходимого был запущен локальный класетр minikube с помощью команды:

```
minikube start --vm-driver=docker
```

Для проверки его состояния был выведен статус.

![status](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/screenshots/minikube%20status.png)

Для разоварачивания серсвиса необходимо поднять под. Для этого был создан Деплоймент([Deployment](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/files/deployment.yml)). Этот объект отвечает за контейнер пода, проверяет его здоровье и пегружает его. С его помощью поды легко масштабировать. Для создания deployment была использована следующая команда: 

```
kubectl apply -f deployment.yml
```
, которая загружает с локального компьюетра файл deployment.yml следующего содержания 

```
kind: Deployment
apiVersion: apps/v1
metadata:
  name: lab2
spec:
  replicas: 3
  selector:
    matchLabels:
      app: lab2
  template:
    metadata:
      labels:
        app: lab2
    spec:
      containers:
      - name: hello-world
        image: strm/helloworld-http
```

В нем есть описание характеристик *spec*, в котором replicas - это количество используемых ресурсов(подов). *metadata* - имя, под котором будут созданы поды. В поле *templete* указываются харакетристики создаваемых контейнеров - их имя и образ. В нешем случае был использован образ strm/helloworld-http.  

![creating](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/screenshots/deployment%20creating.png)

После загрузки deployment были созданы поды:

![pods](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/screenshots/pods.png)

После этого был создан сервис с помощью файла [service.yml](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/files/service.yml). 

```
apiVersion: v1
kind: Service
metadata:
  name: lab2
  labels:
    app: lab2
spec:
  type: LoadBalancer
  ports:
    - port: 80
  selector:
    app: lab2
```

Для того, чтобы сервис lab2  был доступным вне вирутальной сети Kubernetes, сервис имеет тип LoadBalancer. В этом файле также указан порт, по которому этот сервис доступен.

![creating](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/screenshots/service%20creating.png)

![info](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/screenshots/service%20info.png)

Для того, чтобы проверить работу сервиса была выполнена команда 

```
minikube service lab2
```

Было открыто окно браузера, в котором выводится ответ сервиса.

![result](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/screenshots/result.png)

**Вывод**
В результате работы мы ознакомились с работой в Kubernetes, создали свой кластер и подняли на нём сервис hello-world  на 3 ресурсах-подах. 


