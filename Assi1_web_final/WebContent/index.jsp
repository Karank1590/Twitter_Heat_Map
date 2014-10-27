<%-- Cloud Computing - Twitter Heat Map Assignment 1--%>
<%-- Umang Patel - ujp2001 , Karan Kaul- kak2210 --%>
<%-- Columbia University, CS Department--%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.amazonaws.*" %>
<%@ page import="com.amazonaws.auth.*" %>
<%@ page import="com.amazonaws.services.ec2.*" %>
<%@ page import="com.amazonaws.services.ec2.model.*" %>
<%@ page import="com.amazonaws.services.s3.*" %>
<%@ page import="com.amazonaws.services.s3.model.*" %>
<%@ page import="com.amazonaws.services.dynamodbv2.*" %>
<%@ page import="com.amazonaws.services.dynamodbv2.model.*" %>
<%@ page import="com.amazonaws.auth.profile.ProfileCredentialsProvider" %>
<%@ page import="com.amazonaws.regions.Region" %>
<%@ page import="com.amazonaws.regions.Regions" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.amazonaws.auth.PropertiesCredentials" %>



<%!
    private AmazonEC2         ec2;
    private AmazonS3           s3;
    private AmazonDynamoDB dynamo;
 %>

<%

	AmazonDynamoDBClient dynamoDB;
	AWSCredentials credentials = null;
  credentials= new PropertiesCredentials(getClass().getClassLoader().getResourceAsStream("AwsCredentials.properties"));
	dynamoDB = new AmazonDynamoDBClient(credentials);

	Region usWest2 = Region.getRegion(Regions.US_EAST_1);
	dynamoDB.setRegion(usWest2);

  String tableName = request.getParameter("tablename");
    

  if(tableName==null)
  {
    tableName="diwali_table";
  }

  ScanRequest scanRequest = new ScanRequest(tableName);
  ScanResult scanResult = dynamoDB.scan(scanRequest);
  List<Map<String,AttributeValue>> li = scanResult.getItems();
  String lat="",lng="";
  String tweets="";
    
  for (int i = 0; i < li.size(); i++) 
  {
	
    			tweets+=li.get(i).get("text").getS()+"#$#";
    			String[] temp=li.get(i).get("coordinates").getS().split(",");
    			lat+=temp[0]+",";
    			lng+=temp[1]+",";
	
	}

%>


<%
   
    if (request.getMethod().equals("HEAD")) return;
%>


<%
    if (ec2 == null) {
        AWSCredentialsProvider credentialsProvider = new ClasspathPropertiesFileCredentialsProvider();
        ec2    = new AmazonEC2Client(credentialsProvider);
        s3     = new AmazonS3Client(credentialsProvider);
        dynamo = new AmazonDynamoDBClient(credentialsProvider);
    }
%>

<!DOCTYPE html>
<html>
<head>
 <meta charset="utf-8">
    <title>Heatmaps</title>
    <style>
      html, body, #map-canvas {
        height: 95%;
        
        margin: 0px;
        padding: 0px
      }
      #panel {
        position: absolute;
        top: 5px;
        left: 50%;
        margin-left: -180px;
        z-index: 5;
        background-color: #fff;
        padding: 5px;
        border: 1px solid #999;
      }
    </style>  
    
    <script src="https://maps.googleapis.com/maps/api/js?key=GOOGLE_API_KEY&v=3.exp&libraries=visualization"></script> 
    <script>
 
    function dropdown(value)
    {
    	
    	window.location.href = "/index.jsp?tablename=" + document.getElementById("table").value;

    }  
    
   
   
  

    var map, pointarray, heatmap;
    var lat="<%=lat%>";
    var lng="<%=lng%>";
    var tweets="<%=tweets%>";

    var lat1=lat.split(",");
    var lng1=lng.split(",");
    var tweets1=tweets.split("#$#");

    var taxiData=[];
    for (var i=0; i<lat1.length; i++)
    {
      taxiData.push(new google.maps.LatLng(lng1[i],lat1[i]));
    }

    var coords=[];
    for (var i=0; i<lat1.length; i++)
    {
	   coords.push([lng1[i],lat1[i]]);
    }

    var mapopt;
    function variable_set()
    {

	   mapopt=document.getElementById("map_option").value;
	   sessionStorage.setItem("mapopt",mapopt);
	   initialize();
    }

    function initialize() 
    {
      var mapOptions = {
      zoom: 2,
      center: new google.maps.LatLng(30.7050,32.3442),
      mapTypeId: google.maps.MapTypeId.SATELLITE
    };

    map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
  
 
    if(sessionStorage.getItem("mapopt")==null)
	  {
	   mapopt=document.getElementById("map_option").value;
	   sessionStorage.setItem("mapopt",mapopt);
	  }
    else
	  {
	   mapopt=sessionStorage.getItem("mapopt");
	   document.getElementById("map_option").value =mapopt ;
	  }

  
    if(mapopt=="true")
	  {
 		var pointArray = new google.maps.MVCArray(taxiData);
    heatmap = new google.maps.visualization.HeatmapLayer({
   	  data: pointArray
 				});

 			heatmap.setMap(map);
	  }
    else if(mapopt=="false")
	  {
 
 		var infowindow = new google.maps.InfoWindow();
  	for (i = 0; i < coords.length; i++) 
  	{
	    			marker = new google.maps.Marker({
	        	position: new google.maps.LatLng(coords[i][0], coords[i][1]),
	        	map: map,
	        	title: tweets1[i]});

	    			google.maps.event.addListener(marker, 'click', function() {
	    				infowindow.setContent(this.title);
	    	            infowindow.open(map, this);
	    			  });
	    			
	    	
		}

	  }
 
}

google.maps.event.addDomListener(window, 'load', initialize);




    </script>
    
    <script type="text/javascript">
   
    setInterval('window.location.reload()', 30000);
    
    </script> 
    
    
</head>
<body>

  <div id="map-canvas"></div>
  <div>
  <b>KeyWord:</b>
  <select id="table" onchange="dropdown(this.value)">
  <% String req=request.getParameter("tablename"); %>
  <option value="diwali_table" <%if (req != null && req.equals("diwali_table")) { %> selected<%}%>>Diwali</option>
  <option value="obama_table" <%if (req != null && req.equals("obama_table")) { %> selected<%} %>>Obama</option>
  <option value="ebola_table" <%if (req != null && req.equals("ebola_table")) { %> selected<%} %>>Ebola</option>
  <option value="allah_table" <%if (req != null && req.equals("allah_table")) { %> selected<%} %>>Allah</option>
  <option value="facebook_table" <%if (req != null && req.equals("facebook_table")) { %> selected<%} %>>Facebook</option>
  <option value="football_table" <%if (req != null && req.equals("football_table")) { %> selected<%} %>>Football</option>
  <option value="justinbieber_table" <%if (req != null && req.equals("justinbieber_table")) { %> selected<%} %>>Justin Bieber</option>
  <option value="tennis_table" <%if (req != null && req.equals("tennis_table")) { %> selected<%} %>>Tennis</option>
	</select>
  </div>
   	
   	
   	
   <div>
   <b>MapType:</b>
   <select id="map_option" onchange="variable_set()">
   <option value="true" >Heat Map</option>
   <option value="false">Normal Map</option>
   </select>
   </div>
   
   <input type="text" id="tst" size="100">
   <script>
   		document.getElementById("tst").value="Page Loaded !. Records plotted "+(lat1.length-1).toString();
   </script>
</body>
</html>