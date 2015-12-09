FROM debian:jessie

#
# FixMe: Install debian.ncrmnt.org and apt.dockerproject.org GPG key here!
#

RUN apt-get update && apt-get -y install apt-transport-https
RUN echo "deb https://debian.ncrmnt.org/debian jessie main"          >> /etc/apt/sources.list
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list

RUN apt-get update && apt-get -y --force-yes install multistrap sudo kconfig-frontends docker-engine git qemu-user-static

ENV PATH  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/module-nmc/bin-lnx/
ENV HOME  /var/lib/jenkins

RUN chmod 777 /etc/passwd
RUN chmod 777 /etc/group
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers    

ENTRYPOINT ["/bin/bash", "--login"]
