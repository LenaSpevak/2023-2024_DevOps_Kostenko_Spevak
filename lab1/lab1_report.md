#### University: [ITMO University](https://##3itmo.ru/ru/)
#### Faculty: [FICT](https://fict.itmo.ru)
#### Course: Cloud Systems and Services
#### Year: 2023/2024
#### Group: K34212
#### Authors: Kostenko Darina Alekseevna & Spevak Elena Aleksandrovna
#### Lab: Lab1

# **Отчёт по лабораторной работе №1**
# "Изучение плохих паттернов в Dockerfile"

**Цель работы:** изучить bad practices при написании Dockerfile, написать плохой и хороший Dockerfile.

**Ход работы:**

При выполнении работы будут созданы контейнеры для для запуска сервиса nginx с указанной web-страницей (с данным файлом [index.html](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/Dockerfiles/index.html)).


1. Плохой [Dockerfile](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/Dockerfiles/bad_example.dockerfile)

```
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y nginx mysql-server gimp && 
    apt-get clean

COPY index.html /var/www/html/

CMD ["bash", "-c", "service nginx start && service mysql start && tail -f /dev/null"]
```

В этом файле представлены следующие bad pracrices:

- Испоьзование тега "latest" при указании версии дистрибутива Ubuntu:тег latest не гарантирует, что используется самая стабильная версия образа, что может вносить в него нежелательные изменения или уязвимости, а также использование тега latest делает Dockerfile недетерминированным, поскольку он может давать разные результаты в зависимости от того, когда и где он собран
- Установка ненужных для работы nginx пакетов: это может увеличить размер и сложность образа, замедлить время сборки и работы контейнера
- Запуск в одном контейнере двух сервисов одновременно (nginx и mysql): это противоречит принципу контейнеризации, который заключается в изоляции и выполнении одного процесса в одном контейнере, усложняет управление, мониторинг и масштабирование каждого из них по отдельности

Данный образ был собран с помощью команды

```
docker build -t bad_image -f bad_example.dockerfile .
```

На основе образа был запущен контейнер на 8081 порту.

```
docker run --name bad_container -p 8081:80 bad_image
```

В результате на localhost был получен слеующий результат. Nginx работает, выходит web-страница index.html.

![Работа первого контейнера](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/screenshots/result.jpg)


2. Хороший Dockerfile

```
FROM nginx:1.21.1

COPY index.html /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]
```

В хорошем файле bad practices были исправлены:
- Используется образ nginx конкретной версии, не устанавливаются лишние пакеты
- Запускается только один необходимый процесс

Образ был собран и на его основе был запущен контейнер на 8082 порту с помощью команд

```
docker build -t good_image -f good_example.dockerfile .
docker run --name good_container -p 8082:80 good_image
```

Этот контейнер так же работает, реузльта его работы проиллюстрирован ниже.

![Работа второго контейнера](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/screenshots/result2.jpg)

При сравнении образов видно, что плохой имеет существенно больший вес.

![Сравнение контейнеров](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak/blob/main/lab1/screenshots/containers.jpg)

3. Плохие практики по использованию контейнеров:
- Не стоит запускать контейнера с привилегиями root: это может привести к уязвимостям безопасности и возможности получения несанкционированного доступа к хост-системе. С точки зрения безопасности стоит запускать контейнеры с минимальными привилегиями, необходимыми для их работы
- Не стоит изменять файлы (например, index.html) внутри контейнера напрямую: изменения, внесенные в файлы внутри контейнера, не будут сохранены после его остановки. Вместо этого лучше изменять исходные файлы и перестраивать контейнер


**Вывод** 
Были изучены bad practice при написании Dockerfile и созданы два файла: с плохими паттернами и с их исправлением. В результате были запущены два контейнера для поднятия nginx сервера.

