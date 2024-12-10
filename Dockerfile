FROM serversideup/php:8.2-fpm-nginx-alpine

COPY 99-init-daloradius.sh /etc/entrypoint.d/99-init-daloradius.sh

USER root

RUN docker-php-serversideup-dep-install-alpine git && \ 
    install-php-extensions mysqli && \
    chmod +x /etc/entrypoint.d/99-init-daloradius.sh

RUN pear channel-update pear.php.net \
    && pear install -a -f DB \
    && pear install -a -f Mail \
    && pear install -a -f Mail_Mime

USER www-data

WORKDIR /var/www/html
RUN git clone https://github.com/lirantal/daloradius.git /var/www/html && \
    cp app/common/includes/daloradius.conf.php.sample app/common/includes/daloradius.conf.php
