#!/bin/env bash
if [[ -n "$DEBUG" ]]; then
  set -x
fi

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

aws --region=us-west-2 s3 cp s3://solr.ucldc/eb-files/index.html /var/app/
mv /var/app/index.html /usr/share/nginx/html/
aws --region=us-west-2 s3 cp s3://solr.ucldc/eb-files/Solr_Logo_on_white-sm.png /var/app/
mv /var/app/Solr_Logo_on_white-sm.png /usr/share/nginx/html/

