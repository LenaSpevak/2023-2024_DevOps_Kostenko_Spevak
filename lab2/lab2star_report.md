#### University: [ITMO University](https://##3itmo.ru/ru/)
#### Faculty: [FICT](https://fict.itmo.ru)
#### Course: Cloud Systems and Services
#### Year: 2023/2024
#### Group: K34212
#### Authors: Kostenko Darina Alekseevna & Spevak Elena Aleksandrovna & Guseynov Guseyn
#### Lab: Lab2

# **Отчёт по лабораторной работе №2 со звездочкой**

# Работа с Kubernetes (со зведочкой)

**Цель работы:** настроить подключение к сервису в minikube через https, используя самоподписанный сертификат.

**Ход работы**  

1. Самоподписанный сертификат 

Он выпускается, если нет возможноси выпустить сертификат от доверенного центра сертификации.

Для создания самоподписанного сертификата использовалась утилита openssl. Для хранения сертификата и ключа была создана отдельная директория - cloud_lab2/certificate. После перехода в неё были созданы privateKey и certificate с помощью следующей команды:

```
sudo openssl req -x509 -nodes -newkey rsa:2048 -keyout privateKey.key -out certificate.crt
```

Ключ ```-x509``` отвечает за то, что создается именно самоподписанный сертификат;
    ```-newkey``` — автоматическое создание ключа сертификата;
    ```-days``` — срок действия сертификата в днях;
    ```-keyout``` — имя файла ключа;
    ```-out``` —  имя файла сертификата.

После этого были введены код страны, город, название компании. Процесс создания сертификата с ключа и результат представлен на скриншотах ниже.

![Создание сертификата](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/creating%20certificate.png)

![Созданные файлы](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/creating%20certificate%20result.png)

2. Создание секрета
   
Для того, чтобы передать данные сертификата и ключа в сервис, был создан секрет, в который были перенесены сертификат и закрытый ключ.

```
kubectl create secret tls secret-tls --cert certificate.crt --key privateKey.key
```

![Создание секрета](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/creating%20secret2.png)

Файл [service.yml]() был немного изменен - в него были внесены данные об использования секрета.

3. Ingress расширения

Данное расширение разрешает внешний доступ к сервисам в кластере.

Для установки Ingress была использована команда

```
minikube addons enable ingress
```
![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/ingress%20enable.png)

После установки Ingress была проверена его работа:

![Проверка подов контроллера](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/get%20pods%20ingress.png)

После проверки работы подов контроллера Ingress, был создан [файл](), который разрешит доступ к сервису по доменному имени, в нашем случае hello-world.lab2. 

После создания файл был добавлен с помощью комнады

```
kubectl apply -f ingress.yml
```

После этого была произведена проверка установки Ip-адреса:

![Полученный Ingress Ip](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/ingress%20ip.png)

4. Добавление записи в файл hosts

> Ingress в Windows не позволяет октрывать сервис в браузере по полученному Ingress Ip, поэтому в файл hosts был прописан домен на адрес localhost - 127.0.0.1

![Файл hosts](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/hosts%20file.png)

Для корректной работы необходимо было включить туннелирование в новом терминале 

```
minikube tunnel
```

![Туннелирование](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/tunneling.png)

В результате при вводе в поисковую строку доенного имени сервиса  https://hello-world.lab открывается предупреждающее окно

![Вывод результат](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/https%20resolve.png)

После обхода предупреждения в браузере был получен доступ к сервису minikube по доменному имени

![Результат работы сервиса](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/result%20https.png)

Сертификат из браузера:

![Сертификат](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab2/%20screenshots%20star/certificate.png)



