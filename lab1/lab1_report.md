#### University: [ITMO University](https://##3itmo.ru/ru/)
#### Faculty: [FICT](https://fict.itmo.ru)
#### Course: [Cloud Systems and Services]
#### Year: 2023/2024
#### Group: K34212
#### Authors: Kostenko Darina Alekseevn & Spevak Elena Aleksandrovna
#### Lab: Lab1

# **Отчёт по лабораторной работе №1**
# "Начало работы с Dockerfile"

**Цель работы:** изучить bad practices при написании Dockerfile, написать плохой и хороший Dockerfile.


```
FROM ubuntu:latest

RUN apt-get update && \
apt-get install -y nginx mysql-server gimp && \
apt-get clean

COPY index.html /var/www/html/

CMD ["bash", "-c", "service nginx start && service mysql start && tail -f /dev/null"]
```
