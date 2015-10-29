#"https://52.10.100.133/solr/dc-collection/select?q=d%C3%ADa&wt=json"
echo "enter X-Authentication-Token"
read auth_token
echo "enter username:password"
read auth

echo "DIACRITIC FIX"
echo "================================================================================"
echo "================================================================================"
ucldc_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=dia&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"dia\" found $ucldc_num_found"
ucldc_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=d%C3%ADa&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"día\" found $ucldc_num_found"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=dia&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"dia\" found $new_index_num_found"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=d%C3%ADa&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"día\" found $new_index_num_found"
echo "================================================================================"
echo "================================================================================"

ucldc_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=el+d%C3%ADa+de+los+muertos&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"el día de los muertos\" found $ucldc_num_found"
ucldc_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=el+dia+de+los+muertos&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"el dia de los muertos\" found $ucldc_num_found"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=el+d%C3%ADa+de+los+muertos&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"el día de los muertos\" found $new_index_num_found"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=el+dia+de+los+muertos&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"el dia de los muertos\" found $new_index_num_found"
echo "================================================================================"
echo "================================================================================"
echo "================================================================================"

ucldc_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=El+D%C3%ADa+de+los+Muertos+1983&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"El Día de los Muertos 1983\" found $ucldc_num_found"
ucldc_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    "https://ucldc-solr-stage.elasticbeanstalk.com/solr/select?q=El+Dia+de+los+Muertos+1983&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "UCLDC beanstalk  select \"El Dia de los Muertos 1983\" found $ucldc_num_found"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=El+D%C3%ADa+de+los+Muertos+1983&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"El Día de los Muertos 1983\" found $new_index_num_found"
new_index_num_found=`curl -s -k -H "X-Authentication-Token: $auth_token" \
    --digest --user $auth \
   "https://52.10.100.133/solr/dc-collection/select?q=El+Dia+de+los+Muertos+1983&rows=0&wt=json" | \
   jq '.response.numFound'`
echo "NEW Index select \"El Dia de los Muertos 1983\" found $new_index_num_found"
echo "================================================================================"
echo "================================================================================"
