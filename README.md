ucldc_solr
==========

Solr configuration and velocity templates for the UCLDC project

Deploying new configurations
----------------------------

When changes are made to the dc-collection schema.xml or solrconfig.xml, the
running environments must be rebuilt to update the solr instances.

- make changes
- test locally by running following in the repo root dir:

> docker build --tag=ucldc/solr .
> docker run -d -p 8983:8983 --name=solr ucldc/solr

Now point browser to http://localhost:8983 on linux or to <boot2docker ip>:8983

You can go to the files and check the schema or solrconfig then.

Once it runs and looks good, push the code to https://github.com/ucldc/solr_api

### Deploying to harvesting infrastructure

ssh to the majorTom machine for the environment you want to update.

From the majorTom machine:

- update the ~/code/solr_api repo
- . ~/workers_local/bin/activate
- 

