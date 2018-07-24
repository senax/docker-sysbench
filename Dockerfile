#
# vim: bg=dark
# http://en.community.dell.com/techcenter/extras/w/wiki/dvd-store
#
# export MYSQL_USER=sysbench
# export MYSQL_PASSWORD=secret
# export MYSQL_DATABASE=sysbench

# docker run -d --rm --name mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_ROOT_HOST='%' -e MYSQL_USER -e MYSQL_PASSWORD -e MYSQL_DATABASE -p 3306:3306 mysql/mysql-server:5.7

# docker run --rm -ti --network=host --name sysbench senax/sysbench:latest bash
# docker run --rm -ti --network=host --name sysbench senax/sysbench:latest setup
# docker run --rm -ti --network=host --name sysbench senax/sysbench:latest bench

FROM centos:centos7

MAINTAINER frank@crystalconsulting.eu

#RUN yum -y install epel-release; yum -y install git mariadb make automake libtool pkgconfig libaio-devel mariadb-devel postgresql-devel
RUN yum -y install git mariadb make automake libtool pkgconfig libaio-devel mariadb-devel postgresql-devel

RUN cd /root && git clone https://github.com/akopytov/sysbench.git
# RUN cd /root && git clone https://github.com/senax/sysbench.git
RUN cd /root/sysbench && ./autogen.sh && ./configure --with-pgsql && make -j2 && make install && rm -rf /root/sysbench

ADD scripts/setup /usr/local/bin/setup
ADD scripts/bench /usr/local/bin/bench

RUN chmod +x /usr/local/bin/setup /usr/local/bin/bench

#RUN yum -y remove make automake libtool pkgconfig libaio-devel mariadb-devel git wget unzip && yum clean all && rm -rf /var/cache/yum
RUN yum -y remove make automake libtool libaio-devel mariadb-devel git wget unzip && yum clean all && rm -rf /var/cache/yum

ENV SIZE=100
# SIZE_UNTI in MB or GB
ENV SIZE_UNIT=MB
ENV THREADS=2
ENV TIMELIMIT=30
ENV EVENTS=10000
ENV MYSQL_HOST=127.0.0.1
ENV MYSQL_USER=sysbench
ENV MYSQL_PASSWORD=secret

# CMD ["/usr/local/bin/setup"]
CMD ["/usr/local/bin/bench"]
