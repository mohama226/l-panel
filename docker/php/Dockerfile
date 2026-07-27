FROM php:8.2-fpm



RUN apt-get update && apt-get install -y \


    git \

    unzip \

    curl \

    libzip-dev \

    libpng-dev \

    libxml2-dev \



&& docker-php-ext-install \


    pdo \

    pdo_mysql \

    zip \

    gd \

    xml



COPY --from=composer:latest /usr/bin/composer /usr/bin/composer



WORKDIR /var/www/html



RUN chown -R www-data:www-data /var/www/html



EXPOSE 9000
