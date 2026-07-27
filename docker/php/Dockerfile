FROM php:8.3-fpm



WORKDIR /var/www



RUN apt-get update && apt-get install -y \

    git \

    unzip \

    curl \

    libpq-dev \

    libzip-dev \

    zip



RUN docker-php-ext-install \

    pdo \

    pdo_pgsql \

    mbstring \

    zip \

    xml



COPY --from=composer:latest /usr/bin/composer /usr/bin/composer



COPY . /var/www



RUN composer install --no-dev --optimize-autoloader



RUN php artisan storage:link || true



RUN chown -R www-data:www-data /var/www/storage

RUN chown -R www-data:www-data /var/www/bootstrap/cache



EXPOSE 9000



CMD [

"php-fpm"

]
