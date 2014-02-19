# BUILD-USING:        docker build -t photoshow .
# RUN-USING:          docker run -d -p 8081:80 -volumes-from DATA -v $PWD:/var/www -v /home/bredin/app/photoshow:/var/app/photoshow -name PHOTOSHOW photoshow

FROM stackbrew/ubuntu:quantal
MAINTAINER Herve Bredin (http://herve.niderb.fr)

RUN apt-get -qy update && locale-gen en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy install software-properties-common
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:nginx/stable
RUN apt-get -qy update

# install nginx and php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy install nginx php5-fpm php5-mysql php5-gd php5-intl php5-imagick php5-mcrypt php5-curl php5-cli php5-xdebug 

# update nginx and php5 config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini

ADD docker/run.sh /run.sh
RUN chmod +x /run.sh

ADD docker/nginx-default-site /etc/nginx/sites-available/default

RUN rm -rf /var/www/*

EXPOSE 80

VOLUME ["/var/app/photoshow"]

ENTRYPOINT ["/run.sh"]

