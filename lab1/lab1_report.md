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

В ходе выполнения работы юыли изучены  bad practice и создан следующий плохой образ 
[bad Dockerfile](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/Dockerfiles/bad_image.dockerfile) для запуска сервиса nginx.

В нём были допущены следющие ошибки:

1. Испоьзование тега "latest" при указании версии дистрибутива Ubuntu;
2. Установка ненужных для работы пакетов, вклюячая графический редактор MySQL;
3. Запуск в одном контейнере двух сервисов одновременно (nginx и mysql).

Данный контейнер был собран с помощбю комнады 

```
docker build -t bad_image -f bad_example.dockerfile .
```

