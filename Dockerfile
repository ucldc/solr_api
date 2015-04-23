FROM    java:8
# from https://github.com/makuk66/docker-solr
MAINTAINER  Mark Redar "mredar@gmail.com"

ENV SOLR_VERSION 5.1.0
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_USER solr

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install zip
#THIS TAKES TOO LONG  wget -nv --output-document=/usr/local/src/$SOLR.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
COPY $SOLR.tgz /usr/local/src/
WORKDIR /usr/local/src
RUN  tar -xvf $SOLR.tgz $SOLR/bin/install_solr_service.sh --strip-components=2 && \
  bash /usr/local/src/install_solr_service.sh /usr/local/src/$SOLR.tgz

EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_USER

# NOW COPY SCHEMA AND SUCH TO directory
CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -f"]
