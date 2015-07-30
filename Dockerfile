#
#
#
FROM debian:wheezy

MAINTAINER Fernando Ike fike@midstorm.org

ENV DEBIAN_FRONTEND noninteractive

RUN echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections &&\
    echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections


ENV LC_ALL en_US.UTF-8

RUN apt-get update -qq && apt-get install locales apache2 rsyslog -y

COPY preseed.cfg preseed.cfg

RUN debconf-set-selections preseed.cfg

RUN a2enmod rewrite

ADD etc /etc

ADD mailman /var/lib/mailman

ADD start /start

RUN chown -R list: /var/lib/mailman/* && chmod +x /start

RUN sed -i 's/exit\ 101/\#exit\ 101/g' /usr/sbin/policy-rc.d

RUN apt-get install postfix apache2 mailman -y

RUN sed -i 's/\#exit\ 101/\exit\ 101/g' /usr/sbin/policy-rc.d

RUN rm preseed.cfg

EXPOSE 8084 25 

ENV APACHE_RUN_USER www-data

ENV APACHE_RUN_GROUP www-data

ENV APACHE_LOG_DIR /var/log/apache2

CMD ["/start"]
