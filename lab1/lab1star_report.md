#### University: [ITMO University](https://##3itmo.ru/ru/)
#### Faculty: [FICT](https://fict.itmo.ru)
#### Course: Cloud Systems and Services
#### Year: 2023/2024
#### Group: K34212
#### Authors: Kostenko Darina Alekseevna & Spevak Elena Aleksandrovna & Guseynov Guseyn
#### Lab: Lab1*

# **Отчёт по лабораторной работе №1***
# "Работа с Dockerfile"

**Задача**: приложение в запущенном контейнере должно записывать изменения в базу данных. Что именно записать – передаётся в команде запуска контейнера. При остановке контейнера информация не должна исчезать. Файл должен иметь название, отличное от Dockerfile

**Ход работы**:

Напишем докерфайл для сборки образа для контейнера с базой данных MySQL. Зададим имя докерфайла DB_Dockerfile:

```
FROM mysql:8.2.0

ENV MYSQL_ROOT_PASSWORD=Pa$$w0rd
ENV MYSQL_DATABASE=test_database
ENV MYSQL_USER=test_user
ENV MYSQL_PASSWORD=test_user_pass

COPY init.sql /docker-entrypoint-initdb.d/

VOLUME /var/lib/mysql
```

Здесь используется базовый образ mysql:8.2.0, задаются переменные окружения (учетные данные пользователя и базы данных), копируется файл init.sql, который содержит SQL-скрипт (предаставлен ниже) для создания таблицы TEST_INFO, куда далее будет записываться информация.
Также здесь определяется том (volume) для хранения данных MySQL, чтобы можно было получить доступ к данным даже после остановки контейнера.

Файл init.sql:

```
CREATE TABLE IF NOT EXISTS test_database.TEST_INFO (
    id INT AUTO_INCREMENT PRIMARY KEY,
    info VARCHAR(255)
);
```

Далее было написано приложение на python, которое позволяет подключиться к базе данных MySQL на хосте mysql_db (будущем контейнере с базой данных) и внести запись в таблицу TEST_INFO. Информация для записи будет передаваться при запуске контейнера в переменной DATA.

```
import mysql.connector
import sys
import os

data = os.getenv("DATA")

mydb = mysql.connector.connect(
  host="mysql_db",
  user="test_user",
  password="test_user_pass",
  database="test_database"
)

mycursor = mydb.cursor()

sql = "INSERT INTO TEST_INFO (info) VALUES (%s)"
val = (data,)

mycursor.execute(sql, val)
mydb.commit()
mydb.close()
```

Был написан докерфайл для сборки образа для контейнера с приложением, имя файла - APP_Dockerfile:

```
FROM python:3.9

RUN pip install mysql-connector-python

COPY app /app

CMD ["python", "/app/app.py"]
```

Здесь используется базовый образ python:3.9, устанавливается библиотека mysql-connector-python для взаимодействия с базой данных MySQL, копируется директория с приложением и устанавливается инструкция для запуска приложения при запуске контейнера.


Собираем образы, используя написанные докерфайлы:
```
docker build -t mysql_image -f DB_Dockerfile .
docker build -t app_image -f APP_Dockerfile .
```

Создадим отдельную сеть для контейнеров, чтобы они могли общаться друг с другом по имени (в нашем случае для того, чтобы приложение в контейнере app могло подключаться к базе данных на хосте mysql_db):

```
docker network create lab1_star
```

Далее запускаем контейнер с базой данных - пробрасываем порты, подключаем контейнер к сети lab1_star:

```
docker run -d -p 3306:3306 --name mysql_db --network lab1_star mysql_image
```

После запускаем контейнер с приложением - подключаем контейнер к сети lab1_star, определяем значение переменной DATA:

```
docker run -d --name app --network lab1_star -e DATA="TEST DATA" app_image
```

После работы приложения строка "TEST DATA" была занесена в таблицу TEST_INFO базы данных test_database в контейнере mysql_db. Для повторного внесения информации необходимо удалить контейнер app и запустить его заново с необходимым значением переменной DATA:

```
docker rm app & docker run -d --name app --network lab1_star -e DATA="SECOND TEST DATA" app_image
```

Просмотрим содержимое таблицы в контейнере mysql_db - в таблицу были занесены 2 строки данных:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab1/screenshots_star/mysql_db.png)

Доступ к информации сохранится даже после остановки контейнера благодаря созданию тома. В приложении Docker во вкладке Volumes можно увидеть созданный том, в нем - файл TEST_INFO.ibd, который содержит данные таблицы TEST_INFO.

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab1/screenshots_star/volume.png)

Для просмотра данных таблицы можно воспользоваться [этой инструкцией](https://stackoverflow.com/questions/61727167/import-ibd-files-into-mysql-server):

- на локальной машине создаем базу данных MySQL - check_db, в ней создаем таблицу TEST_INFO с аналогичной структурой
- ```ALTER TABLE table_name DISCARD TABLESPACE;```
- в директории, в которой MySQL хранит свои данные (в нашем случае C:\ProgramData\MySQL\MySQL Server 8.0\Data\), в папку check_db копируем файл TEST_INFO.ibd (он был скачан из тома)
- ```ALTER TABLE table_name IMPORT TABLESPACE;```

Теперь мы можем просмотреть содержимое таблицы:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab1/screenshots_star/check_db.png)
