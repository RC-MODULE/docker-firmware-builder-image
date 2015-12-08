FROM debian:jessie
RUN echo "deb https://debian.ncrmnt.org/debian jessie main" >> /etc/apt/sources.list
RUN apt-get update && apt-get -y install multistrap sudo kconfig-frontends

ENV PATH  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/module-nmc/bin-lnx/
ENV HOME  /var/lib/jenkins

RUN chmod 777 /etc/passwd
RUN chmod 777 /etc/group
RUN chmod 777 /root
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers    

ENTRYPOINT ["/bin/bash", "--login"]