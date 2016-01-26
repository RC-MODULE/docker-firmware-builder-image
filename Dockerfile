FROM debian:jessie

#
# FixMe: Install debian.ncrmnt.org and apt.dockerproject.org GPG key here!
#


RUN echo "deb http://mirror.yandex.ru/debian/ stable main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ stable/updates main"             >> /etc/apt/sources.list
RUN echo "deb http://mirror.yandex.ru/debian/ stable-updates main"         >> /etc/apt/sources.list
RUN echo "deb http://mirror.yandex.ru/debian/ stable-backports main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ stable/updates non-free" >> /etc/apt/sources.list

#Comment out this if you don't need APT proxy
RUN echo "Acquire::http::Proxy  \"http://shadowblade:3128/\";" > /etc/apt/apt.conf.d/proxy
RUN echo "Acquire::https::Proxy \"http://shadowblade:3128/\";" >> /etc/apt/apt.conf.d/proxy

RUN echo "deb http://security.debian.org/ stable/updates non-free" >> /etc/apt/sources.list

RUN apt-get update 
RUN apt-get -y upgrade 
RUN apt-get -y install apt-transport-https apt-utils

RUN echo "deb http://repo.ncrmnt.org/debian jessie main"          >> /etc/apt/sources.list
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list

RUN apt-get update 
RUN apt-get -y --force-yes install multistrap sudo kconfig-frontends docker-engine git qemu-user-static build-essential devscripts wget mtd-utils gpgv

ENV PATH  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME  /var/lib/jenkins

RUN chmod 777 /etc/passwd
RUN chmod 777 /etc/group
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers    

# Remember to do 
# rm -f /etc/apt/apt.conf.d/docker-gzip-indexes
# If you are going to run multistrap
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes

# jessie's version of qemu-user-static has a nasty race condition
RUN wget http://ftp.us.debian.org/debian/pool/main/q/qemu/qemu-user-static_2.5+dfsg-1_amd64.deb
RUN dpkg -i qemu-user-static_2.5+dfsg-1_amd64.deb

ENTRYPOINT ["/bin/bash", "--login"]
