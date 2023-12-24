#### University: [ITMO University](https://##3itmo.ru/ru/)
#### Faculty: [FICT](https://fict.itmo.ru)
#### Course: Cloud Systems and Services
#### Year: 2023/2024
#### Group: K34212
#### Authors: Kostenko Darina Alekseevna & Spevak Elena Aleksandrovna & Guseynov Guseyn
#### Lab: Lab4

# **Отчёт по лабораторной работе №4**
# "Мониторинг сервиса в Kubernetes"

**Задача**: сделать мониторинг сервиса, поднятого в Kubernetes, используя Prometheus и Grafana.

**Ход работы**:

Во-первых, установим Prometheus.

Добавляем репозиторий prometheus-community:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/helm-repo-prometheus.png)

Просмотрим пакеты Helm, доступные в репозитории prometheus-community:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/list-repo-prometheus.png)

Из репозитория устанавливаем Prometheus:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/installing_prometheus.png)

Создаем новый сервис Kubernetes типа NodePort для доступа к службе Prometheus:

```
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
```

Откроем службу Prometheus через браузер:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/minikube-service-prometheus.png)

В браузере откроется web-интерфейс Prometheus, а именно Status-Targets:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/prometheus-target.png)git add

Во-вторых, устанавливаем Grafana:

Клонируем репозиторий grafana и устанавливаем из репозитория Grafana:

```
git clone https://github.com/bibinwilson/kubernetes-grafana.git
```

Создаем файл конфигурации grafana-datasource-config.yaml, в качестве источника данных указываем сервис Prometheus:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasources
data:
  prometheus.yaml: |-
    {
        "apiVersion": 1,
        "datasources": [
            {
               "access":"proxy",
                "editable": true,
                "name": "prometheus",
                "orgId": 1,
                "type": "prometheus",
                "url": "http://prometheus-service.monitoring.svc:8080",
                "version": 1
            }
        ]
    }
```

Создаем configmap:

```
kubectl create -f grafana-datasource-config.yaml
```

Далее создаем файл deployment.yaml:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      name: grafana
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - name: grafana
          containerPort: 3000
        resources:
          limits:
            memory: "1Gi"
            cpu: "1000m"
          requests: 
            memory: 500M
            cpu: "500m"
        volumeMounts:
          - mountPath: /var/lib/grafana
            name: grafana-storage
          - mountPath: /etc/grafana/provisioning/datasources
            name: grafana-datasources
            readOnly: false
      volumes:
        - name: grafana-storage
          emptyDir: {}
        - name: grafana-datasources
          configMap:
              defaultMode: 420
              name: grafana-datasources
```

Создаем deployment:

```
kubectl create -f deployment.yaml
```

Создаем файл service.yaml:

```
apiVersion: v1
kind: Service
metadata:
  name: grafana
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port:   '3000'
spec:
  selector: 
    app: grafana
  type: NodePort  
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000
```

Создаем сервис:

```
kubectl create -f service.yaml
```

Настраиваем проброс портов:

```
kubectl port-forward grafana 3000 &
```
![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/port-forward%20grafana.png)

Теперь можно открыть страницу Grafana по адресу http://localhost:3000:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/log_in-grafana.png)

Вводим логин/пароль - admin/admin и попадает на главную страничку:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/grafana-main-page.png)

Для создания Dashboard и отображения графиков с метриками используем готовый шаблон:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/import-dashboard.png)

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/graph3.png)


**Вывод**: был настроен мониторинг сервиса, поднятого в Kubernetes, с использованием Prometheus и Grafana. Были показаны графики, которые будут отражать состояние системы. 