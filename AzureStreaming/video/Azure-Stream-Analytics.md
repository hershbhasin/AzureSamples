### Bio

Hello, my name is Hersh Bhasin and welcome to my course, "Processing Real-Time Data Streams with Azure Stream Analytics". I work as a Cloud Architect with J.P. Morgan Chase and have done quite a bit of work in helping transition workflows to a  stream-based architecture. 

### Objective

While streaming of data and stream processing is a vast topic and there is a whole world view that goes with it, this course is an introduction to the area.  I want to look at topics like:

1. Why streaming? What are the problems that streaming is trying to solve. Why do we need a new thing?
2. How does data streams differ from OLTP databases, key value stores
3. How can we capture and transform data using Azure Stream Analytics



###  Why Streaming

* Data Locked Up in Schemas 

* Leads to pipeline sprawl



*Data Locked Up in Schemas* 

Most of our typical web or mobile applications are build on a HTTP request/response paradigm. A web application makes a rest call to an api, that api gets the data from a database and returns it back to the application which then displays it in the UI.  Because the data that the application needs is stored away in well know table schemas in a database, a consuming application can efficiently query it with well know syntax . This works great when a known application talks to a known data store. However this also means that data gets locked away in tables and schemas



*Leads to pipeline sprawl*

Having a "well-known" data stores means that that data gets locked away in tables and  schemas, and this becomes a drawback when data has to be extracted from multiple stores, say by a offline batch process which needs to extract data from many databases and aggregate it for analytics. This  batch process would need to understand the specific schema of each of these databases,  unlock and open the door of each table as it were, and then perform transformation on the data. You can end up building hundreds of pipelines to extract data locked away and interwoven in these databases, caches and search indexes. This is inherently complicated and hard to manage.

### Data Streams

Data Streams is a different way of looking at data. Instead of thinking of data as islands of data locked up in table schemas

![analytics_structured](C:\_hbGit\AzureSamples\AzureStreaming\video\analytics_structured.PNG)

 We think of data as a ever flowing river of events. 

![analytics_river](C:\_hbGit\AzureSamples\AzureStreaming\video\analytics_river.PNG)

Our data flows as a river of events and our applications and batch processes can subscribe to and listen on these events, and some events can trigger other events. This emancipation of data is very powerful indeed.![analytics_unstructured](C:\_hbGit\AzureSamples\AzureStreaming\video\analytics_unstructured.PNG) 



###  Azure Stream Analytics

"Words are flowing out like endless rain into a paper cup..." goes the famous Beatles song.  If our data is the  rain of flowing words, then our Stream Analytics job is the cup that we will use to collect some of the rain drops.

Lets stretch the analogy of the Beatles song to its breaking point. We have events that fall like raindrops.  We can define an event as a fact about the world. Something happened in the world and the event is a record of it. It is a message with some information, maybe in the Jason format. 

Applications cause events. Maybe it is a sensor reporting the health of a device after every second.

The raindrops collect and the collected raindrops become a river. And that river could be an Event Hub, an IOT Hub or an Azure Blob Location.

Now to this river, we take our paper cup to fill it with a subset of the data we are interested in. This cup could be a database or it could be an Azure blob store location, or an Azure data location, or it could be a real time Power BI dashboard.

And the tool that we use to extract data from the river and fill our paper cup is an Azure Stream Analytics job. It bridges the input, maybe an  event hub, to the output, maybe a sql server database, with a sql query. Then as the data come in real time into the river, the query is going to run against the unbounded stream of data as it arrives, and write it out to the output. That is what an Azure Analytics job basically does.

### Demo