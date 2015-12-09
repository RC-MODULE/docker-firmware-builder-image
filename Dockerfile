FROM debian:jessie

#
# FixMe: Install debian.ncrmnt.org and apt.dockerproject.org GPG key here!
#


RUN echo "deb http://mirror.yandex.ru/debian/ stable main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ stable/updates main"             >> /etc/apt/sources.list
RUN echo "deb http://mirror.yandex.ru/debian/ stable-updates main"         >> /etc/apt/sources.list
RUN echo "deb http://mirror.yandex.ru/debian/ stable-backports main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ stable/updates non-free" >> /etc/apt/sources.list

RUN apt-get update 
RUN apt-get upgrade 
RUN apt-get -y install apt-transport-https apt-utils

RUN echo "deb https://debian.ncrmnt.org/debian jessie main"          >> /etc/apt/sources.list
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list

RUN apt-get update 
RUN apt-get -y --force-yes install multistrap sudo kconfig-frontends docker-engine git qemu-user-static build-essential devscripts wget 

ENV PATH  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME  /var/lib/jenkins

RUN chmod 777 /etc/passwd
RUN chmod 777 /etc/group
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers    

ENTRYPOINT ["/bin/bash", "--login"]
