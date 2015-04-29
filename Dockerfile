FROM    java:8
# from https://github.com/makuk66/docker-solr
MAINTAINER  Mark Redar "mredar@gmail.com"

ENV SOLR_VERSION 5.1.0
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_USER solr

COPY $SOLR.tgz /opt/
WORKDIR /opt/

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install zip &&\
#THIS TAKES TOO LONG  wget -nv --output-document=/usr/local/src/$SOLR.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
  tar -xvf $SOLR.tgz && \
  groupadd -r $SOLR_USER && \
  useradd -r -g $SOLR_USER $SOLR_USER && \
  mkdir -p /opt && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr && \
  mkdir -p /opt/solr/server/solr/dc-collection/ && \
  cp -rp /opt/solr/server/solr/configsets/basic_configs/conf /opt/solr/server/solr/dc-collection/ && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr /opt/$SOLR 

# NOW COPY SCHEMA AND SUCH TO directory
USER $SOLR_USER
COPY ./dc-collection/core.properties /opt/solr/server/solr/dc-collection/
COPY ./dc-collection/conf/schema.xml /opt/solr/server/solr/dc-collection/conf/
COPY ./dc-collection/conf/solrconfig.xml /opt/solr/server/solr/dc-collection/conf/

EXPOSE 8983
WORKDIR /opt/solr

CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -f"]
