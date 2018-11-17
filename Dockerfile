FROM centos:centos7 

ARG JAVA_VERSION=java-1.8.0-openjdk

RUN yum makecache && \
    yum install --nogpgcheck -y $JAVA_VERSION gcc gcc-c++ \
    yum clean all

ENV CONFLUENT_VERSION 5.0.1
ENV CONFLUENT_SCALA_VERSION 2.11

ADD http://packages.confluent.io/archive/5.0/confluent-oss-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz /opt
RUN tar xf /opt/confluent-oss-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz -C /opt/ && rm /opt/confluent-oss-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz

ENV PATH="/opt/confluent-$CONFLUENT_VERSION/bin/:${PATH}"

# Confluent requires curl, and it can't verify that curl is installed without which
RUN yum -y install which

# Set permissions correctly
RUN chown 1000:1000 /opt/confluent-$CONFLUENT_VERSION/share/java/kafka/connect-*
RUN chmod go+r /opt/confluent-$CONFLUENT_VERSION/share/java/kafka/connect-*
