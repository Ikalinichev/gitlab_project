FROM maven.e-taxes.gov.az:48082/tools/apps:java8-node12-nginx16-mvn362 as build

WORKDIR /opt

COPY ./ui .
COPY ./docker/frontend/default.conf /tmp/default.conf

RUN npm install && \
    npm run build

FROM maven.e-taxes.gov.az:48082/tools/apps:java8-node12-nginx16-mvn362

WORKDIR /usr/share/nginx/html/eportal

COPY --from=build /opt/build/ .
COPY --from=build /tmp/default.conf /etc/nginx/conf.d/default.conf
