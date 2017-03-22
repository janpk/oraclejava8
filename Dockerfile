FROM frolvlad/alpine-oraclejdk8:slim
LABEL maintainer Jan-Petter Kruger <jan.petter.kruger@evry.com>

ENV GOSU_VERSION 1.10
RUN set -x \
    && apk update \
    && apk add ca-certificates wget \
    && update-ca-certificates \
	&& apk add --no-cache --virtual .gosu-deps \
		dpkg \
		gnupg \
		openssl \
		curl \
	&& dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apk del .gosu-deps \
	&& rm -rf /var/cache/apk/*

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]