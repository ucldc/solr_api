import sys
import json
import argparse
import solr

solr_new = solr.Solr('http://127.0.0.1:8983/solr/dc-collection')

def save_json_to_local_solr(fname):
    docs = json.loads(open(fname).read())
    for doc in docs:
        print "DOC:{}".format(doc['id'])
        solr_new.add(doc)
    solr_new.commit()

if __name__=='__main__':
    parser = argparse.ArgumentParser(description='Harvest a collection')
    parser.add_argument('fname', type=str,
        help='File in which json solr docs are stored')
    args = parser.parse_args(sys.argv[1:])
    save_json_to_local_solr(args.fname)
