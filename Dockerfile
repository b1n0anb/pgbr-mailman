#
#
#
FROM debian:jessie

MAINTAINER Fernando Ike fike@midstorm.org

ENV DEBIAN_FRONTEND noninteractive

#RUN echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections &&\
#    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections

#ENV LC_ALL en_US.UTF-8

COPY preseed.cfg preseed.cfg

ADD etc /etc

ADD start /start

RUN apt-get update -qq && \ 
      apt-get install locales -y && \
      apt-get -o Dpkg::Options::="--force-confold" \
        --assume-yes --no-install-recommends install \ 
        postfix \ 
        apache2 \
        rsyslog \ 
        mailman \
        opendkim \
        opendkim-tools 
      
RUN debconf-set-selections preseed.cfg && \ 
      a2enmod rewrite ssl cgid && \ 
      a2dissite 000-default && \
      adduser www-data list && \
      mkdir -p /var/spool/postfix/opendkim && \
      chown -R opendkim: /etc/opendkim /var/spool/postfix/opendkim && \
      mkdir -p /srv/listas.postgresql.org.br/log/apache2/ && \
      mkdir /srv/listas.postgresql.org.br/www && \
      adduser postfix opendkim 

RUN chmod +x /start  
      
RUN rm preseed.cfg && \
      apt-get clean && \ 
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 25 8084 

ENV APACHE_PID_FILE /var/run/apache2.pid

ENV APACHE_LOCK_DIR /var/lock/apache2

ENV APACHE_RUN_DIR /var/run/apache2

ENV APACHE_RUN_USER www-data

ENV APACHE_RUN_GROUP www-data

ENV APACHE_LOG_DIR /var/log/apache2

CMD ["/start"]
