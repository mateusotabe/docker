FROM php:8.2-fpm

# Argumentos para o user
ARG user
ARG uid

RUN apt-get update

# Dependências
RUN apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    npm

# Cache clear
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# PHP Extensions
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# User para composer e artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

WORKDIR /var/www/

# Comando para copiar o projeto para a pasta correta
COPY . /var/www/

USER $user
