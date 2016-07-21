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
RUN echo "Acquire::http::Proxy  \"http://shadowblade:3128/\";" >  /etc/apt/apt.conf.d/proxy
RUN echo "Acquire::https::Proxy \"http://shadowblade:3128/\";" >> /etc/apt/apt.conf.d/proxy

RUN echo "deb http://security.debian.org/ stable/updates non-free" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install apt-transport-https apt-utils

RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y --force-yes install multistrap sudo docker-engine git build-essential devscripts wget mtd-utils gpgv

ENV PATH  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME  /var/lib/jenkins

# Remember to remove /etc/apt/apt.conf.d/docker-gzip-indexes or multistrap will break
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes

# Linaro abe build deps
RUN apt-get install -y --force-yes bison automake autoconf libtool libncurses-dev gawk gcc-multilib g++-multilib zlib1g-dev flex autogen texinfo libpython2.7-dev dejagnu gcc-mingw-w64-i686
ADD git-new-workdir /usr/local/bin

# jessie's version of qemu-user-static has a nasty race condition
RUN echo "deb http://mirror.yandex.ru/debian/ unstable main contrib non-free" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes  qemu-user-static -t unstable

# Create passwd and group if needed, make them world-writable
# Jenkins will need to fill in uid/gid there.
# Failing to do so breaks some apps, like gcc's buildsystem

RUN touch /etc/group
RUN touch /etc/passwd
RUN chmod 777 /etc/passwd
RUN chmod 777 /etc/group

RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENTRYPOINT ["/bin/bash", "--login"]
