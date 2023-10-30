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
[bad Dockerfile](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/Dockerfiles/bad_example.dockerfile) для запуска сервиса nginx.

В нём были допущены следющие ошибки:

1. Испоьзование тега "latest" при указании версии дистрибутива Ubuntu;
2. Установка ненужных для работы пакетов, вклюячая графический редактор MySQL;
3. Запуск в одном контейнере двух сервисов одновременно (nginx и mysql).

Данный контейнер был собран с помощью команды

```
docker build -t bad_image -f bad_example.dockerfile .
```

После сборки контейнер был запущен на 8081 порту:

```
docker run --name bad_container -p 8081:80 bad_image
```

Для того, чтобы увидеть работу контейнера, был создан файл [index.html](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/Dockerfiles/index.html). 

В результате на localhost был получен слеующий результат:

[Работа первого контейнера](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/screenshots/result.jpg)


В результате исправлений ошибок был написан [хороший Dockerfile](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/Dockerfiles/good_example.dockerfile).

Контейнер был собран и запущен на 8082 порту с помощью комнад

```
docker build -t good_image -f good_example.dockerfile .
docker run --name good_container -p 8082:80 good_image
```

Этот контейнер тоже работает, реузльта его работы проиллюстрирован ниже.

[Работа второго контейнера](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/screenshots/result2.jpg)

При сравнении контейнеров видно, что первый(плохой) контейнер имеет сущесвтенно больший вес.

[Сравнение контейнеров](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/screenshots/containers.jpg)

**Вывод** 
Были изучены bad practice при написании Dockerfile и созданы два файла: с ошибками и с их справлением. В результате были запущены два контейнера для поднятия nginx сервера.

