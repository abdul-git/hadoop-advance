####Set environment for JAVA and HADOOP HOME
. ./set_java

###Check input dir is created
 hadoop fs -ls /

###Delete and create build dir
rm -fr build/
mkdir build

###Compile Java code
javac -cp $HH/lib/hadoop/*:$HH/lib/hadoop/client/*:$HH/lib/hadoop-mapreduce/*  WordCount.java -d build -Xlint
jar -cvf wordcount.jar -C build/ .

###execute map-reduce job 
hadoop jar wordcount.jar org.myorg.WordCount input output

###Check the output of Word count
hadoop fs -ls output
hadoop fs -cat output/part-r-00000|less
