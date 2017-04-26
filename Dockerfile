FROM    java:8
# from https://github.com/makuk66/docker-solr
MAINTAINER  Mark Redar "mredar@gmail.com"

ENV SOLR_VERSION 5.1.0
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_USER solr

#COPY $SOLR.tgz /opt/ #if downloaded, may want to do before hand, takes long
#time to download
WORKDIR /opt/

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install bzip2 awscli &&\
  wget -nv --output-document=/opt/$SOLR.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \ 
  tar -xvf $SOLR.tgz && \
  groupadd -r $SOLR_USER && \
  useradd -r -g $SOLR_USER $SOLR_USER && \
  mkdir -p /opt && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr && \
  mkdir -p /opt/solr/server/solr/dc-collection/data && \
  mkdir -p /opt/solr/server/solr/dc-collection/data/tlog && \
  cp -rp /opt/solr/server/solr/configsets/basic_configs/conf /opt/solr/server/solr/dc-collection/ && \
  touch /opt/solr/server/solr/dc-collection/conf/admin-extra.html && \
  touch /opt/solr/server/solr/dc-collection/conf/admin-extra.menu-top.html && \
  touch /opt/solr/server/solr/dc-collection/conf/admin-extra.menu-bottom.html && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr /opt/$SOLR 


# NOW COPY SCHEMA AND SUCH TO directory
USER $SOLR_USER
COPY ./dc-collection/core.properties /opt/solr/server/solr/dc-collection/
COPY ./dc-collection/conf/schema.xml /opt/solr/server/solr/dc-collection/conf/
COPY ./dc-collection/conf/solrconfig.xml /opt/solr/server/solr/dc-collection/conf/

EXPOSE 8983
WORKDIR /opt/solr
VOLUME /opt/solr/server/solr/dc-collection/data

CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -Xms1g -Xmx3g -f"]
