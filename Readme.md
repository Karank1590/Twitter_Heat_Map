Web Application to Display Tweets on a Map
==========================================

Authors
-------
Umang Patel - ujp2001@columbia.edu , Karan Kaul- kak2210@columbia.edu

Description
-----------
This is a web application that allows the user to select one of the following keywords ñ ebola, diwali, obama, allah, facebook, football, justinbeiber, tennis; and displays the heat map of tweets which contain the tweets or pinpoints location of the individual tweets which contain the selected keyword. The web application collects data regarding a keyword from an Amazon DynamoDB instance. The data is displayed on a Google Maps instance within the web browser. 

As the web page is requested, a connection is established with the DynamoDB instance and the latitude and longitude data is collected from the database, serialized as a string and sent to the requesting client. At the client, the web page is loaded and once the map is generated, the longitude and latitude data is deserialized and the map is populated either as heatmap or to point locations of the individual tweets depending on the map type selected.

Information about a different keyword can be displayed by selecting the keyword in the dropdown list called Keyword. Additionally, the data can be displayed either as a heatmap or to pinpoint individual tweets by selecting the option heatmap or normal map respectively from the drop down list called MapType

GitHub URL
----------
https://github.com/17patelumang/CloudComputing_BigData_Assi1

Application URL
---------------
http://ujp2001assi1-cn5ymtyk24.elasticbeanstalk.com/


Screencast URL
--------------
http://www.screencast.com/t/3kVuuR9z8VG

Libraries
---------
1. AWS SDK

Installation
------------
The web application can be deployed on an AWS Elastic Beanstalk through the Eclipse IDE which contains the AWS SDK.
While deploying the application, the server must be defined as AWS Elastic Beanstalk for Tomcat 6.

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

Bonus (Map Update in real time)
-------------------------------
To collect tweets run python code and keep to on. The command to run is “python twitter_stream.py”
The information displayed on the map changes over time as new tweets regarding a keyword are collected into the DynamoDB instance. These new tweets are sent to the client along with the rest of the tweets as the web page refreshes the page over a set interval. Currently the interval is set to 30 seconds.



