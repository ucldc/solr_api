'''
Generate a UUID to use as an api_key & remind where to put it
'''
import uuid
new_key=uuid.uuid4()

print("NEW API KEY:{0}".format(new_key))

print("Place in the S3 token_auth file wrapped as so:")
print("")
print("#<COMMENT WITH USER ID -- so know who's using the key>")
print("if ($http_X_Authentication_Token = '{0}') {{".format(new_key))
print("    set $not_authed 0;")
print("}")
print("\n\n")
print("Then rebuild the solr index beanstalk to pickup the new key from S3")
