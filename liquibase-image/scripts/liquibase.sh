#!/bin/bash
case "$1" in
    "diff" )
        echo "Generating diff ..."
        ;;
    "update" )
        echo "Applying changelogs ..."
        liquibase --classpath=${POSTGRES_DRIVER} --driver=org.postgresql.Driver --changeLogFile=${CHANGELOG_FILE} --url="jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}" --username=${POSTGRES_USER} --password=${POSTGRES_PASSWORD} update
        ;;
    "generate" )
        echo "Generating changelog ..."
        ;;
esac
