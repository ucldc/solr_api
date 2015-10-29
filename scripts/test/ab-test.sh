echo "auth_token"
read auth_token

ab -c 30 -n 2000 -H "X-Authentication-Token: $auth_token" 'https://ucldc-solr-stage-loadtest.elasticbeanstalk.com/solr/query?q=collection_url:%22https://registry.cdlib.org/api/v1/collection/26094/%22&facet=true&facet.query=true&facet.field=reference_image_md5' &
ab -c 30 -n 2000 -H "X-Authentication-Token: $auth_token" 'https://ucldc-solr-stage-loadtest.elasticbeanstalk.com/solr/dc-collection/select?q=*:*&facet=true&facet.limit=1000&facet.field=title_ss' &
