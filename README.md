ucldc_solr
==========

Solr configuration and velocity templates for the UCLDC project

Deploying new configurations
----------------------------

When changes are made to the dc-collection schema.xml or solrconfig.xml, the
running environments must be rebuilt to update the solr instances.

test locally by running following in the repo root dir:

- docker build --tag=ucldc/solr .
- docker run -d -p 8983:8983 --name=solr ucldc/solr

Now point browser to http://localhost:8983 on linux or to <boot2docker ip>:8983

You can go to the files and check the schema or solrconfig then.

Once it runs and looks good, push the code to https://github.com/ucldc/solr_api

### Deploying to harvesting infrastructure

ssh to the majorTom machine for the environment you want to update.


- update the ~/code/solr_api repo

ssh to the solr server:

- sudo docker stop solr
- sudo docker rm solr
- sudo docker rmi ucldc/solr

Then ssh to the majorTom machine.

- . ~/workers_local/bin/activate
- ansible-playbook -i ~/code/ingest_deploy/ansible/hosts ~/code/ingest_deploy/ansible/provision_solr.yml --vault-password-file=~/.vault_pass_ingest


### Deploying to AWS

- update the ~/code/solr_api
- clone an existing solr environment
- from the solr_api directory, run deploy-version.sh. This will prompt you for
  required parameters. Set the new cloned environment to be the one updated and
  give the version an appropriate name.
- ./deploy-version.sh add-start-end-date ucldc-solr-stage-2
