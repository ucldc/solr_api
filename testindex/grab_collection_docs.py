import random
import json
import argparse
import ConfigParser
import datetime
import solr

def get_collection_docs(SOLR, collection_url):
    docs = []
    recs_batch = SOLR(q="collection_url:{}".format(collection_url))
    num = recs_batch.numFound
    print "CID:{} NUMBER:{}".format(
                collection_url.rsplit('/', 2)[1], num)
    while len(recs_batch.results):
        for rec in recs_batch:
            doc_new = {}
            print rec['id']
            for key, val in rec.items():
                if '_ss' in key:
                    continue
                if key in ['score', '_version_', 'timestamp',]:
                    continue
                doc_new[key] = val
            docs.append(doc_new)
        recs_batch = recs_batch.next_batch()
    return docs

def serialize_datetime(obj):
    if isinstance(obj, datetime.datetime):
        isodate = obj.isoformat()
        return isodate[0:isodate.index('+')] + 'Z'
    return obj

def save_docs_to_file(docs, fname=None):
    if not fname:
        fname = 'random_solr_docs-{}.json'.format(
                datetime.datetime.now().strftime('%Y%m%d-%H%M'))
    with open(fname, 'w') as foo:
        foo.write(json.dumps(docs, default=serialize_datetime))


def save_to_local_solr(new_solr, docs):
#put into new index: start a docker index with mapped volume for data and
#upload docs to it
    for doc in docs:
        print "DOC:{}".format(doc['id'])
        new_solr.add(doc)
    new_solr.commit()

def create_new_random_test_index(outfile, source_solr, dest_solr,
        source_api_key=None, dest_api_key=None):
    SOURCE_SOLR=solr.SearchHandler(solr.Solr(source_solr,
        post_headers = { 'X-Authentication-Token':  source_api_key}),
        "/query")
    collection_urls = get_collection_urls(SOURCE_SOLR, source_api_key)
    docs_selected = get_random_docs(SOURCE_SOLR, collection_urls)
    save_docs_to_file(docs_selected, fname=outfile)
    DEST_SOLR=solr.Solr(dest_solr, post_headers = { 'X-Authentication-Token':  dest_api_key})
    save_to_local_solr(DEST_SOLR, docs_selected)

def copy_collection_docs(outfile, source_solr, dest_solr, collection_url,
        source_api_key=None, dest_api_key=None):
    SOURCE_SOLR=solr.SearchHandler(solr.Solr(source_solr,
        post_headers = { 'X-Authentication-Token':  source_api_key}),
        "/query")
    docs_selected = get_collection_docs(SOURCE_SOLR, collection_url)
    save_docs_to_file(docs_selected, fname=outfile)
    DEST_SOLR=solr.Solr(dest_solr, post_headers = { 'X-Authentication-Token':  dest_api_key})
    save_to_local_solr(DEST_SOLR, docs_selected)

if __name__=="__main__":
    print 'Grab a collection to dest solr'
    parser = argparse.ArgumentParser()
    parser.add_argument('--outfile', type=str)
    parser.add_argument('collection_key', type=str)
    args = parser.parse_args()
    c_key = args.collection_key
    collection_url = 'https://registry.cdlib.org/api/v1/collection/{}/'.format(
            c_key)
    outfile = '{}-{}.json'.format(
            c_key,
            datetime.datetime.now().strftime('%Y%m%d-%H%M'))
    outfile = args.outfile if args.outfile else  outfile
    #READ solr sources and keys from gen_random.ini
    config = ConfigParser.SafeConfigParser()
    config.read('gen_random.ini')
    source_solr = config.get('source-solr', 'solrUrl')
    source_api_key = config.get('source-solr', 'solrAuth')
    dest_solr = config.get('dest-solr', 'solrUrl')
    dest_api_key = config.get('dest-solr', 'solrAuth')

    copy_collection_docs(outfile, source_solr=source_solr,
            collection_url=collection_url,
            dest_solr=dest_solr, source_api_key=source_api_key,
            dest_api_key=dest_api_key)
