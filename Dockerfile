FROM frolvlad/alpine-oraclejdk8:slim
LABEL maintainer Jan-Petter Kruger <jan.petter.kruger@evry.com>


RUN apk add --update curl gosu && \
    rm -rf /var/cache/apk/*

