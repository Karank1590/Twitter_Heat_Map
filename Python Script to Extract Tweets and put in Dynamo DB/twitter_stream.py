# Cloud Computing Assigment 1 - Tweet Collection & Dumping to Dynamo DB code
# This code collects tweets with specific key words from Twitter streaming API and puts in Dynamo DB database; this code also creates a "table_name".txt file where each line is tweetid so one can use it to get records from Dynamo DB database if one dosent want to use scan option. 
# Umang Patel = ujp2001, Karan Kaul - kak2210
# Columbia University,CS Department


import oauth2 as oauth
import urllib2 as urllib
import json
import ast
from nltk.stem import PorterStemmer
import re
import boto
from boto.dynamodb2.table import Table
from boto.s3.key import Key

stemmer = PorterStemmer()
table_name='allah_table' # name of table
tt=Table(table_name)
s3 = boto.connect_s3()

api_key = "TWITTER_API_KEY"
api_secret = "TWITTER_API_SECRET"
access_token_key = "TWITTER_ACCESS_TOKEN_KEY"
access_token_secret = "TWITTER_TOKEN_SECRET_KEY"


_debug = 0

oauth_token    = oauth.Token(key=access_token_key, secret=access_token_secret)
oauth_consumer = oauth.Consumer(key=api_key, secret=api_secret)

signature_method_hmac_sha1 = oauth.SignatureMethod_HMAC_SHA1()

http_method = "GET"


http_handler  = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)


def convert(input):
  if isinstance(input, dict):
    return {convert(key): convert(value) for key, value in input.iteritems()}
  elif isinstance(input, list):
    return [convert(element) for element in input]
  elif isinstance(input, unicode):
    return input.encode('utf-8')
  else:
    return input

def twitterreq(url, method, parameters):
  req = oauth.Request.from_consumer_and_token(oauth_consumer,
                                             token=oauth_token,
                                             http_method=http_method,
                                             http_url=url, 
                                             parameters=parameters)

  req.sign_request(signature_method_hmac_sha1, oauth_consumer, oauth_token)

  headers = req.to_header()

  if http_method == "POST":
    encoded_post_data = req.to_postdata()
  else:
    encoded_post_data = None
    url = req.to_url()

  opener = urllib.OpenerDirector()
  opener.add_handler(http_handler)
  opener.add_handler(https_handler)

  response = opener.open(url, encoded_post_data)

  return response

def fetchsamples():

  count=0
  url="https://stream.twitter.com/1.1/statuses/filter.json?track=allah" #tracking url
  parameters = []
  

  #for i in range(2):
  #  print i 
  response = twitterreq(url, "GET", parameters)
  for line in response:
    f = open(table_name+".txt", "a+")
    #print line.strip()
      #f.write(line.strip()+"\n")
      #print line.strip()
      #print "_______________________"
    #print "aaaaa"+line.strip()
    if(line.strip()!=""): 
      j=dict()  
      t=json.loads(line.strip())
      #print t
      if t['coordinates']!=None:
        #j['location']=" "
        #print t
        #print t['coordinates']
        j['coordinates']=str(t['coordinates']['coordinates'][0])+","+str(t['coordinates']['coordinates'][1])
        #print t['coordinates']['coordinates'][1]
        j['tweet_id']=t['id_str']
        text = " ".join([stemmer.stem(re.sub(r'[\W_]',"",kw)) for kw in t['text'].split(" ")])
        j['text']=text
        j['created_at']=str(t['created_at'])
        j['follower_count']=str(t['user']['followers_count'])
        tt.put_item(data=j,overwrite=True)
        f.write(str(t['id_str'])+"\n")
        #tt.put_item(data=j,overwrite=True)
        count+=1
	print count 
        if count==400:
          exit()
        #print count
        print "Tweet Entered __________________________"
        f.close() 
    '''  
      else:
        if t['user']['location']!=" ":
          j['coordinates']=" "
          j['location']=t['user']['location']
          j['tweet_id']=t['id_str'] 
          text = " ".join([stemmer.stem(re.sub(r'[\W_]',"",kw)) for kw in t['text'].split(" ")])
          j['text']=text 
          j['created_at']=str(t['created_at'])
          j['follower_count']=str(t['user']['followers_count'])
          
          count+=1
          print count
          print "__________________________________"
    '''   
       
if __name__ == '__main__':
  fetchsamples()

