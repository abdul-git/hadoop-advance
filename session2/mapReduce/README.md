###Execute hadoop WC command
##create directory in HDFS
hadoop fs -mkdir input

##copy some text file

hadoop fs -put sample.txt input 

## execute MR job
hadoop jar hadoop-examples-2.6.0-mr1-cdh5.6.0.jar wordcount  input output
