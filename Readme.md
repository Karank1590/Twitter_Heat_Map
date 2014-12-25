Web Application to Display Heat Map of Tweets
=============================================

Authors
-------
Umang Patel - ujp2001@columbia.edu , Karan Kaul- kak2210@columbia.edu

Description
-----------
This is a web application that allows the user to select one of the following keywords – ebola, diwali, obama, allah, facebook, football, justinbeiber, tennis; and displays the heat map of tweets which contain the tweets or pinpoints location of the individual tweets which contain the selected keyword. The web application collects data regarding a keyword from an Amazon DynamoDB instance. The data is displayed on a Google Maps instance within the web browser. 

As the web page is requested, a connection is established with the DynamoDB instance and the latitude and longitude data is collected from the database, serialized as a string and sent to the requesting client. At the client, the web page is loaded and once the map is generated, the longitude and latitude data is deserialized and the map is populated either as heatmap or to point locations of the individual tweets depending on the map type selected.

Information about a different keyword can be displayed by selecting the keyword in the dropdown list called Keyword. Additionally, the data can be displayed either as a heatmap or to pinpoint individual tweets by selecting the option heatmap or normal map respectively from the drop down list called MapType

GitHub URL
----------
https://github.com/Karank1590/Twitter_Heat_Map

Screencast URL
--------------
http://www.screencast.com/t/3kVuuR9z8VG

Libraries
---------
1. AWS SDK
2. Python Libraries

Installation
------------
The web application can be deployed on an AWS Elastic Beanstalk through the Eclipse IDE which contains the AWS SDK.
While deploying the application, the server must be defined as AWS Elastic Beanstalk for Tomcat 6.

Install python libraries below.

Python Libraries
----------------
Python==2.7.6

oauth2==1.5.211

httplib2==0.8

nltk==3.0.0

boto==2.20.1

urllib2== Default package comes with python

json== Default package comes with python

ast== Default package comes with python

re== Default package comes with python

Steps to run code
-----------------
__Python Script (to collect tweets and insert into DynamoDB database)__:

(1) Create DynamoDB instance with table having columns as "coordinates", "tweet_id", "text", "created_at", "followers_count";"tweet_id" is primary Hash key and put that table name in variable "table_name" in "twitter_stream.py".

(2) Put AWS credentials in ".boto" file.

(3) Put the keyword to track from streaming Twitter API by specifying "track=" in url variable.

(4) run "python twitter_stream.py".

__Java Project__:

(1) Import project in eclipse or other IDE.

(2) Put in AWS credentials in "AwsCredentials.properties".

(3) Put Google Map API in "index.jsp".

(4) Run index.jsp on server.

The way we created this project is each keyword has its own table. "index.jsp" performs scan operation on DynamoDB database by passing table name as request and fetches the data which is plotted on Google Map. To normalise the tweet , we are using NLTK library's Porter Stemmer before inserting data into database. Only those tweets having "geo" hashtags coordinates are put in database. Also this project has real time map update feature as described below. The jsp page also shows the number of tweets plotted in text box below. One can see in the screencast video that the number of tweets collected changes with time as python script to collect tweet is running.

This application is deployed using __Amazon AWS EBS(Amazon Elastic Beanstalk)__.


Bonus (Map Update in real time)
-------------------------------
To collect tweets run python code and keep it running. The command to run python script is "python twitter_stream.py".

The information displayed on the map changes over time as new tweets regarding a keyword are collected into the DynamoDB instance. These new tweets are sent to the client along with the rest of the tweets as the web page refreshes the page over a set interval. Currently the interval is set to 30 seconds.


