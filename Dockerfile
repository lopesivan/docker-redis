FROM ubuntu:12.04
MAINTAINER Cameron Maske "cam@trackmaven.com"
RUN apt-get -y --fix-missing update

# If you update the version, make sure the redis.conf matches the version!
# Different version's default onf files are located -> https://raw.github.com/antirez/redis/2.8/redis.conf
ENV REDIS_VERSION 2.8.8

RUN apt-get -y --force-yes install wget make gcc tcl sudo
RUN wget –quiet http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz -O - | tar -xz
RUN cd /redis-$REDIS_VERSION && make && make test
RUN cp /redis-$REDIS_VERSION/src/redis-server /redis-$REDIS_VERSION/src/redis-cli /redis-$REDIS_VERSION/src/redis-benchmark /usr/local/bin

ADD config/redis.conf /etc/redis/redis.conf

# Update + remove unnecessary packages
RUN apt-get -y update && apt-get -y autoremove

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/data"]

EXPOSE 6379
CMD ["usr/local/bin/run"]