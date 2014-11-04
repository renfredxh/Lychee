FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# Install base packages
RUN apt-get update

# Install Apache, PHP, MySQL, and ImageMagick
RUN apt-get -y install apache2 mysql-server libapache2-mod-php5 imagemagick \
  php5-mysql php5-gd php5-curl php5-imagick git

# Modify php.ini to contain the following settings:
#   max_execution_time = 200
#   post_max_size = 100M
#   upload_max_size = 100M
#   upload_max_filesize = 20M
#   memory_limit = 256M
RUN sed -i -e "s/^max_execution_time\s*=.*/max_execution_time = 200/" \
-e "s/^post_max_size\s*=.*/post_max_size = 100M/" \
-e "s/^upload_max_filesize\s*=.*/upload_max_filesize = 20M\nupload_max_size = 100M/" \
-e "s/^memory_limit\s*=.*/memory_limit = 256M/" /etc/php5/apache2/php.ini

# Link /var/www to /app directory
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
WORKDIR /app

# Clone lychee
RUN git clone https://github.com/electerious/Lychee.git .

# Set file permissions
RUN chown -R www-data:www-data /app && \
  chmod -R 777 uploads/ data/

EXPOSE 80
CMD scripts/start
