FROM centos:centos7 

ARG JAVA_VERSION=java-1.8.0-openjdk
ENV CONFLUENT_VERSION 5.3.0
ENV CONFLUENT_SCALA_VERSION 2.11

# Install Java
RUN yum makecache && \
    yum install --nogpgcheck -y $JAVA_VERSION gcc gcc-c++ \
    yum clean all

# Install Confluent Platform
ADD http://packages.confluent.io/archive/5.3/confluent-community-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz /opt
RUN tar xf /opt/confluent-community-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz -C /opt/ && rm /opt/confluent-community-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz

# Install the Confluent CLI
RUN curl -L https://cnfl.io/cli | sh -s -- -b /usr/local/bin/

# Setup symlink
RUN ln -s /opt/confluent-$CONFLUENT_VERSION /opt/confluent

# Set permissions correctly
RUN chown 1000:1000 /opt/confluent-$CONFLUENT_VERSION/share/java/kafka/connect-*
RUN chmod go+r /opt/confluent-$CONFLUENT_VERSION/share/java/kafka/connect-*

# Add Confluent binaries to path
ENV PATH="/opt/confluent/bin/:${PATH}"

# Install kafkacat
RUN yum groupinstall -y "Development Tools" && \
    yum install -y which wget git librdkafka-devel.x86_64 && \
    git clone https://github.com/edenhill/kafkacat.git /tmp/kafkacat && \
    cd /tmp/kafkacat && \
    ./configure && make && make install && \
    cd / && rm -rf /tmp/kafkacat
