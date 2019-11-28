ARG BASE_IMAGE
FROM $BASE_IMAGE
LABEL description="This image is used to start apps ( base-image/Dockerfile ) web server with deployed frontend"

COPY base-image/nginx/ /etc/nginx/
COPY ui/build/ /usr/share/nginx/html/eportal
COPY mock-api-luxoft /opt/mock-api-luxoft
COPY api/authentication/target/authentication.jar /opt/authentication/authentication.jar
COPY api/calendar/target/calendar.jar /opt/calendar/calendar.jar
COPY api/profile/target/profile.jar /opt/profile/profile.jar
COPY api/admin/target/admin.jar /opt/admin/admin.jar
COPY api/budget/target/budget.jar /opt/budget/budget.jar
COPY api/declaration/target/declaration.jar /opt/declaration/declaration.jar
COPY api/edi/target/EDI.jar /opt/edi/edi.jar
COPY api/feedback/target/feedback.jar /opt/feedback/feedback.jar
COPY api/notification/target/notification.jar /opt/notification/notification.jar
COPY api/push/target/push.jar /opt/push/push.jar
COPY mock-api/authentication/target/authentication.jar /opt/mock/authentication/authentication.jar
COPY mock-api/calendar/target/calendar.jar /opt/mock/calendar/calendar.jar
COPY mock-api/profile/target/profile.jar /opt/mock/profile/profile.jar
COPY mock-api/admin/target/admin.jar /opt/mock/admin/admin.jar
COPY mock-api/budget/target/budget.jar /opt/mock/budget/budget.jar
COPY mock-api/declaration/target/declaration.jar /opt/mock/declaration/declaration.jar
COPY mock-api/edi/target/EDI.jar /opt/mock/edi/edi.jar
COPY mock-api/feedback/target/feedback.jar /opt/mock/feedback/feedback.jar
COPY mock-api/notification/target/notification.jar /opt/mock/notification/notification.jar
COPY mock-api/push/target/push.jar /opt/mock/push/push.jar
