FROM jwilder/nginx-proxy
RUN rm -f /etc/nginx/conf.d/*
RUN rm -f /etc/nginx/vhost.d/*
COPY vhost.d/default /etc/nginx/vhost.d/default
COPY custom.conf /etc/nginx/conf.d/custom.conf
#COPY default.conf /etc/nginx/conf.d/
