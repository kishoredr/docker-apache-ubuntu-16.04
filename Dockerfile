FROM  ubuntu:16.04

MAINTAINER Kishore D R Gowda <kishoregowda@outlook.in>

#RUN apt-get -y update
#RUN apt-get install locales 

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 mysql-server php7.1 libapache2-mod-php7.1 php7.1-common php7.1-mbstring php7.1-xmlrpc php7.1-soap php7.1-gd php7.1-xml php7.1-intl php7.1-mysql php7.1-cli php7.1-mcrypt php7.1-zip php7.1-curl
#RUN apt-get install -qq wget unzip build-essential
#RUN apt-get install -qq wget unzip build-essential cmake gcc libcunit1-dev libudev-dev

RUN apt-get update && \
    apt-get -y install software-properties-common \
    xvfb \
    locales && \
    locale-gen en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --allow-unauthenticated install \
    apache2 \
    mysql-server \
    php7.1 \
    php7.1-dev \
    php7.1-curl \
    php7.1-cli \
    php7.1-gd \
    php7.1-bcmath \
    php7.1-json \
    php7.1-ldap \
    php7.1-intl \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-xml \
    php7.1-xsl \
    php7.1-zip \
    php7.1-soap \
    libapache2-mod-php7.1 \
    php-pear \
    curl \
    git \
    wget \
    nano \
    wkhtmltopdf \
    pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.1/apache2/php.ini \
    sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/"

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data \
    APACHE_RUN_GROUP www-data \
    APACHE_LOG_DIR /var/log/apache2 \
    APACHE_LOCK_DIR /var/lock/apache2 \
    APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Copy site into place.
ADD app /var/www/site/app

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND




