FROM hypriot/rpi-java:1.8.0

MAINTAINER Geert Van Bastelaere <geert.van.bastelaere@gmail.com>

RUN \
  groupadd -g 999 elasticsearch && \
  useradd -g elasticsearch -s /bin/bash -u 999 elasticsearch

RUN \
  apt-get update && \
  apt-get install unzip && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/share

RUN \
  wget --no-check-certificate https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.2.0/elasticsearch-2.2.0.zip && \
  unzip elasticsearch-2.2.0.zip && \
  mv elasticsearch-2.2.0 elasticsearch && \
  chown -R elasticsearch:elasticsearch elasticsearch && \
  rm -rf elastichsearch-2.2.0.zip


ENV ELASTICSEARCH_MAJOR 2.2
ENV ELASTICSEARCH_VERSION 2.2.0

ENV PATH /usr/share/elasticsearch/bin:$PATH

RUN set -ex \
	&& for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
		/usr/share/elasticsearch/config \
		/usr/share/elasticsearch/config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
	done

COPY config /usr/share/elasticsearch/config

VOLUME /usr/share/elasticsearch/data

EXPOSE 9200 9300

USER elasticsearch
WORKDIR /usr/share/elasticsearch

CMD ["elasticsearch"]
