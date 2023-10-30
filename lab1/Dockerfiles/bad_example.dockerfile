FROM ubuntu:latest

RUN apt-get update && \
apt-get install -y nginx mysql-server gimp && \
apt-get clean

COPY index.html /var/www/html/

CMD ["bash", "-c", "service nginx start && service mysql start && tail -f /dev/null"]
