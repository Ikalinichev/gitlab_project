FROM maven.e-taxes.gov.az:48082/tools/apps:java8-node12-nginx16-mvn362 as build

WORKDIR /tmp

COPY ./api .
COPY ./docker/backend/settings.xml /opt/maven/conf/settings.xml

RUN for i in `ls -d /tmp/*`; do cd $i; mvn package;cd ../../; done

FROM maven.e-taxes.gov.az:48082/tools/apps:java8-node12-nginx16-mvn362

WORKDIR /tmp

COPY --from=build /tmp/authentication/target/authentication.jar /opt/authentication/authentication.jar
COPY --from=build /tmp/calendar/target/calendar.jar /opt/calendar/calendar.jar
COPY --from=build /tmp/profile/target/profile.jar /opt/profile/profile.jar
COPY --from=build /tmp/admin/target/admin.jar /opt/admin/admin.jar
COPY --from=build /tmp/budget/target/budget.jar /opt/budget/budget.jar
COPY --from=build /tmp/declaration/target/declaration.jar /opt/declaration/declaration.jar
COPY --from=build /tmp/edi/target/EDI.jar /opt/edi/edi.jar
COPY --from=build /tmp/feedback/target/feedback.jar /opt/feedback/feedback.jar
COPY --from=build /tmp/notification/target/notification.jar /opt/notification/notification.jar
COPY --from=build /tmp/push/target/push.jar /opt/push/push.jar
