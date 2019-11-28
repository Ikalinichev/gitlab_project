FROM maven.e-taxes.gov.az:48082/openjdk:8-jdk-alpine

ARG IMAGE_VERSION
ENV LIQUIBASE_VERSION 3.8.0
ENV PG_VERSION 42.2.6
ENV POSTGRES_DRIVER /opt/liquibase/postgresql-${PG_VERSION}.jar
ENV CHANGELOG_FILE /opt/update/changelog.xml
ENV POSTGRES_HOST postgres
ENV POSTGRES_PORT 5432

WORKDIR /opt/liquibase
COPY scripts /opt/scripts

RUN apk add --no-cache bash && \
wget https://jdbc.postgresql.org/download/postgresql-${PG_VERSION}.jar && \
cp postgresql-${PG_VERSION}.jar /usr/local/bin/ && \
wget https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}-bin.tar.gz && \
tar -xf liquibase-${LIQUIBASE_VERSION}-bin.tar.gz && ln -s /opt/liquibase/liquibase /usr/bin/liquibase && \
rm -rf ./liquibase-$LIQUIBASE_VERSION-bin.tar.gz && chmod -R +x /opt/scripts
