FROM php:8.1.11-cli-alpine3.16 as build

WORKDIR /app/

ARG X_ENV=prod
RUN set -eux ; \
  apk --no-cache add  \
    ${PHPIZE_DEPS}  \
    libev \
  ; \
  pecl install ev; \
  docker-php-ext-enable ev; \
  docker-php-ext-install \
    pcntl \
    sockets \
  ; \
  if [ "$X_ENV" = "dev" ]; then \
    pecl install xdebug-3.1.5; \
    docker-php-ext-enable xdebug; \
    echo "xdebug.mode=debug,coverage,develop" >> "$PHP_INI_DIR/conf.d/xdebug.ini"; \
    echo "xdebug.start_with_request=trigger" >> "$PHP_INI_DIR/conf.d/xdebug.ini"; \
    echo "xdebug.client_host=host.docker.internal" >> "$PHP_INI_DIR/conf.d/xdebug.ini"; \
  fi; \
  apk del ${PHPIZE_DEPS}

ENV COMPOSER_HOME /tmp # TODO CHECKME: needed?
COPY --from=composer:2.4.2 /usr/bin/composer /usr/bin/composer

ENV X_LISTEN 0.0.0.0:8080

USER nobody:nobody
CMD ["/app/bin/x-ctrl"]
