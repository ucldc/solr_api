import random
import json
import argparse
import ConfigParser
import datetime
import solr

def get_collection_urls(SOLR, api_key):
    q_collections=SOLR(q="*:*", rows=0, facet_field="collection_url",
     facet="true", facet_limit=-1)
    facets = q_collections.facet_counts
    f_fields = facets['facet_fields']
    return f_fields['collection_url']

def get_random_docs(SOLR, collection_urls):
    docs = []
    for u in collection_urls:
        recs_in_coll = SOLR(q="collection_url:{}".format(u))
        num = recs_in_coll.numFound
        sample_size = num / 100 if num / 100 else 1
        print "CID:{} NUMBER:{} SAMPLE:{}".format(
                u.rsplit('/', 2)[1], num, sample_size)
        for i in range(sample_size):
            rand_index = random.randrange(num)
            q_rec = SOLR(q="collection_url:{}".format(u), rows=1, start=rand_index)
            #save locally
            doc_new = {}
            for key, val in q_rec.results[0].items():
                if '_ss' in key:
                    continue
                if key in ['score', '_version_', 'timestamp',]:
                    continue
                doc_new[key] = val
            docs.append(doc_new)
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


def save_to_local_solr(SOLR, docs):
#put into new index: start a docker index with mapped volume for data and
#upload docs to it
    for doc in docs:
        print "DOC:{}".format(doc['id'])
        solr_new.add(doc)
    solr_new.commit()

def create_new_random_test_index(outfile, source_solr, dest_solr,
        source_api_key=None, dest_api_key=None):
    SOURCE_SOLR=solr.SearchHandler(solr.Solr(source_solr,
        post_headers = { 'X-Authentication-Token':  source_api_key}),
        "/query")
    collection_urls = get_collection_urls(SOURCE_SOLR, source_api_key)
    docs_selected = get_random_docs(SOURCE_SOLR, collection_urls)
    save_docs_to_file(docs_selected, fname=outfile)
    DEST_SOLR=solr.SearchHandler(solr.Solr(dest_solr,
        post_headers = { 'X-Authentication-Token':  dest_api_key}),
        "/query")
    save_to_local_solr(DEST_SOLR, docs_selected)

if __name__=="__main__":
    print 'Generate new test data set'
    parser = argparse.ArgumentParser()
    parser.add_argument('--outfile', type=str)
    args = parser.parse_args()
    outfile = 'random_solr_docs-{}.json'.format(
            datetime.datetime.now().strftime('%Y%m%d-%H%M'))
    outfile = args.outfile if args.outfile else  outfile

    #READ solr sources and keys from gen_random.ini
    config = ConfigParser.SafeConfigParser()
    config.read('gen_random.ini')
    source_solr = config.get('source-solr', 'solrUrl')
    source_api_key = config.get('source-solr', 'solrAuth')
    dest_solr = config.get('dest-solr', 'solrUrl')
    dest_api_key = config.get('dest-solr', 'solrAuth')

    create_new_random_test_index(outfile, source_solr=source_solr,
            dest_solr=dest_solr, source_api_key=source_api_key,
            dest_api_key=dest_api_key)
