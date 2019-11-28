FROM centos:centos7

ARG IMAGE_VERSION

LABEL description="This is a base image to build and run apps"
LABEL version=${IMAGE_VERSION}

COPY nginx/nginx.repo /etc/yum.repos.d/nginx.repo
COPY ssl/* /etc/pki/ca-trust/source/anchors/

ENV JAVA_HOME=/usr
ENV LANG=en_US.UTF-8

RUN VERSION=12.0.2 && \
    BUILD=10 && \
    NODE=12.x && \
    NGINX=1.16.1 && \
    MAVEN=3.6.2 && \
    curl -sL https://rpm.nodesource.com/setup_"${NODE}" | bash - && \
    yum -y update && \
    yum install -y gcc-c++ make java-1.8.0-openjdk java-1.8.0-openjdk-devel wget nodejs nginx-"${NGINX}" ca-certificates && \
    yum clean all && \
    rm -rf /tmp/* /var/cache/yum/* /var/tmp/* && \
    update-ca-trust enable && \
    update-ca-trust extract && \
    keytool -import -trustcacerts -alias taxes-root-ca -file /etc/pki/ca-trust/source/anchors/TAXES-ROOT-CA.crt -keystore "/etc/pki/ca-trust/extracted/java/cacerts"  -storepass changeit --noprompt && \
    wget http://mirrors.hostingromania.ro/apache.org/maven/maven-3/3.6.2/binaries/apache-maven-"${MAVEN}"-bin.tar.gz -O /opt/apache-maven-"${MAVEN}"-bin.tar.gz && \
    tar -xf /opt/apache-maven-"${MAVEN}"-bin.tar.gz -C /opt && \
    rm -f /opt/apache-maven-"${MAVEN}"-bin.tar.gz && \
    ln -s /opt/apache-maven-3.6.2 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn
