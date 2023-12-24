#### University: [ITMO University](https://##3itmo.ru/ru/)
#### Faculty: [FICT](https://fict.itmo.ru)
#### Course: Cloud Systems and Services
#### Year: 2023/2024
#### Group: K34212
#### Authors: Kostenko Darina Alekseevna & Spevak Elena Aleksandrovna & Guseynov Guseyn
#### Lab: Lab4

# **Отчёт по лабораторной работе №4***
# "Мониторинг сервиса в Kubernetes"

**Цель работы:** настроить алерт кодом оповещения о состоянии сервиса при помощи Alertmanager.

**Ход работы**

Для того, чтобы настроить Alertmanager, был скопирован репозиторий:

```
git clone https://github.com/bibinwilson/kubernetes-alert-manager.git
```

Были добавлены следующие файлы:
- [AlertManagerConfigmap.yaml](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/files/kubernetes-alert-manager/AlertManagerConfigmap.yaml)

В данном файле указана информация, которая перенаправляется в конфигурационный файл, а именно: способ получения уведомления и его детали. В нашем случае был выбран такой канал связи как телеграм бот.

Для этого был создан бот при помощи бота @BotFather. При его создании был получен токен, необходимый для указания в настройках конфигурации. Также был получен chat_id переписки с ботом. Для этого в чат было отпралвено сообщение и отслежены обновления чата через API при помощи ссылки: ```https://api.telegram.org/bot<bot_token>/getUpdates```

- [AlertTemplateConfigMap.yaml](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/files/kubernetes-alert-manager/AlertTemplateConfigMap.yaml)

В данном файле описываются правила вида уведомлений. Никаких изменений в файл из репозитория не было внесено.

- [Deployment.yaml](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/files/kubernetes-alert-manager/Deployment.yaml)

В этом файле собираются воедино добавленные ранее ConfigMap.

- [Service.yaml](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/files/kubernetes-alert-manager/Service.yaml)

В данном файле настраивается доступ для подключения к веб-интерфейсу.

![Добавление всех файлов](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/applying%20alertmanager%20files.png)

После всего была введен команда для переадресации локальных портов в под:

```
kubectl port-forward -n monitoring <name_of_alertmanager_pod> 9090:9093
```

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/port-forward%20alertmanager.png)

При переходе на ```http://localhost:9090``` был октрыт слелующий интерфейс:

![](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/alertmanager-ui.png)

Для настройки алерт-уведомлений прописываются правила, при которых система будет срабатывать. Данные правила описываются в конфигурационном файле prometheus:

```
rule_files:
      - /etc/prometheus/prometheus.rules
___________________________________________

  prometheus.rules: |-
    groups:
    - name: devopscube demo alert
      rules:
      - alert: High Pod Memory
        expr: sum(container_memory_usage_bytes) > 1
        for: 1m
        labels:
          severity: slack
        annotations:
          summary: High Memory Usage
```

В данном случае создано правило, при котором уведомление будет приходить при использовании сервисом больше 1 байта памяти.

При срабатывания правила в телеграм бот приходит уведомление следующего вида:

![Уведомление](https://github.com/LenaSpevak/2023-2024_DevOps_Kostenko_Spevak_Guseynov/blob/main/lab4/screenshots/alert%20in%20tg.png)

**Вывод**: был изучен и установлен AlertManager, а также настроено получение уведомлений в Telegram. 
