import solr
import random
import json
import datetime

SOLR_NEW = solr.Solr('http://127.0.0.1:8983/solr/dc-collection')
SOLR=solr.SearchHandler(solr.Solr('https://registry.cdlib.org/solr',
post_headers = { 'X-Authentication-Token':'xxxyyyzzz'}), "/query")

def get_collection_urls():
    q_collections=SOLR(q="*:*", rows=0, facet_field="collection_url", 
     facet="true", facet_limit=20000)
    facets = q_collections.facet_counts
    f_fields = facets['facet_fields']
    return f_fields['collection_url']

def get_random_docs(collection_urls):
    docs = []
    for u in collection_urls:
        recs_in_coll = SOLR(q="collection_url:{}".format(u))
        num = recs_in_coll.numFound
        sample_size = num / 100 if num / 100 else 1
        print "NUMBER:{} SAMPLE:{}".format(num, sample_size)
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
        return obj.strftime("%Y%m%d-%H:%M:%S")
    return obj

def save_docs_to_file(docs, fname=None):
    if not fname:
        fname = 'random_docs-{}.json'.format(
                datetime.datetime.now().strftime('%Y%m%d-%H%M'))
    with open(fname, 'w') as foo:
        foo.write(json.dumps(docs, default=serialize_datetime))


def save_to_local_solr(docs):
#put into new index: start a docker index with mapped volume for data and 
#upload docs to it
    for doc in docs:
        print "DOC:{}".format(doc['id'])
        solr_new.add(doc)
    solr_new.commit()

def create_new_random_test_index():
    collection_urls = get_collection_urls()
    docs_selected = get_random_docs(collection_urls)
    save_docs_to_file(docs_selected)
    save_to_local_solr(docs_selected)

if __name__=="__main__":
    print 'Generate new test data set'

