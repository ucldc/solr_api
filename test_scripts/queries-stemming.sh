#"https://52.10.100.133/solr/dc-collection/select?q=d%C3%ADa&wt=json"
echo "enter X-Authentication-Token"
read auth_token
echo "enter username:password"
read auth

echo "STEMMING RESULTS"
echo "================================================================================"
echo "================================================================================"
ucldc_num_found_run=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=run&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"run\" found $ucldc_num_found_run"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=run&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"run\" found $new_index_num_found"
echo "================================================================================"
echo "================================================================================"
ucldc_num_found_runs=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=runs&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"runs\" found $ucldc_num_found_runs"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=runs&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"runs\" found $new_index_num_found"
echo "================================================================================"
echo "================================================================================"
ucldc_num_found_running=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=running&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"running\" found $ucldc_num_found_running"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=running&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"running\" found $new_index_num_found"
echo "================================================================================"
echo "================================================================================"
ucldc_total=$(($ucldc_num_found_run + $ucldc_num_found_runs + \
$ucldc_num_found_running))
echo "TOTAL FOUND IN UCLDC: $ucldc_total"
