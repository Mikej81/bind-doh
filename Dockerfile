FROM ubuntu:focal
LABEL org.opencontainers.image.authors="michael@f5.com"

ENV \
    USER=bind \
    GROUP=bind

###
### Install
### 
RUN apt-get update \
    && sudo add-apt-repository ppa:isc/bind-dev \
    && apt-get update \
    && apt-get install software-properties-common gnupg apt-transport-https lsb-release ca-certificates openssl curl \
    && apt-get install libuv1 bind9 \
    && apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

###
### Bootstrap Scipts
###
COPY ./entrypoint.sh /

###
### Ports
###
EXPOSE 53
EXPOSE 53/udp

EXPOSE 80
EXPOSE 443

####
#### Entrypoint
####
#ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]