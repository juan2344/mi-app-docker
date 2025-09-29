# Dockerfile simple para servir PHP con Apache
FROM php:8.2-apache
COPY app/ /var/www/html/
EXPOSE 80
