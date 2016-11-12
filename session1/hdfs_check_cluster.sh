#!/bin/bash
############################################
##      Writen by Abdul Khan
##      Version 1.0
##
##      Execution: ./hdfs_check_cluster.sh
##      Copyright: Script is property of Abdul Khan
##                 explicit permission must request prior
##                 to modifying content
##      Email : abdulk@gmail.com
############################################

VER=1.0





function box_out() {
        input_char=$(echo "$@" | wc -c)
        line=$(for i in `seq 0 $input_char`; do printf "-"; done)
        # tput This should be the best option. what tput does is it will read the terminal info and render the correctly escaped ANSI code for you. code like \033[31m will break the readline library in some of the terminals.
        tput bold
        line="$(tput setaf 3)${line}"
        space=${line//-/ }
        echo " ${line}"
        printf '|' ; echo -n "$space" ; printf "%s\n" '|';
        printf '| ' ;tput setaf 4; echo -n "$@"; tput setaf 3 ; printf "%s\n" ' |';
        printf '|' ; echo -n "$space" ; printf "%s\n" '|';
        echo " ${line}"
        tput sgr 0
}

function get_time() {
date
}

function gen_hive_data() {
        hadoop fs -rm -R /tmp/hive_random
for i in {1..10}; do echo "File ID is $i" | hadoop fs -put - /tmp/hive_random/$i.txt ; done
}

function run_benchmark() {
hadoop fs -rm -r /tmp/teraGen_input
rm /tmp/hadoop-mapreduce-examples.jar
wget -O /tmp/hadoop-mapreduce-examples.jar https://github.com/abdul-git/hadoop-advance/raw/master/jars/hadoop-mapreduce-examples.jar
hadoop jar /tmp/hadoop-mapreduce-examples.jar teragen 1000 /tmp/teraGen_input

hadoop fs -rm -r /tmp/teraGen_output
hadoop jar /tmp/hadoop-mapreduce-examples.jar terasort /tmp/teraGen_input /tmp/teraGen_output
}
box_out "Current version of script is $VER"

box_out "Starting HDFS health check at `get_time`"

box_out "Getting health status for all nodes"
hdfs dfsadmin -report
echo " "
box_out "Getting health status for dead nodes"
hdfs dfsadmin -report |grep -i "Dead datanodes"
hdfs dfsadmin -report |grep -i "Dead datanodes" |wc -l  > /tmp/deadnode.txt
DEAD_NODE=`cat /tmp/deadnode.txt`
if [ ${DEAD_NODE} -gt 0 ] ;
then
echo " "
box_out "Dead nodes count = $DEAD_NODE"

else
echo " "
echo  "No Dead nodes found!"
fi


box_out "Print cluster Topology"

hdfs dfsadmin -printTopology


box_out "Checking if namenode is in safemode"

hdfs dfsadmin -safemode get
echo " "
echo "------------------------------"
echo " "

SAFEMODE_STATUS=`hdfs dfsadmin -safemode get |grep "OFF"|cut -c14-16 `
echo $SAFEMODE_STATUS
if
[[ "${SAFEMODE_STATUS}" == "OFF" ]] ;
then
echo "Continuing -- Starting test jobs"

box_out "Testing MapReduce funtionality"

hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar pi 10 1000

echo "Continuing -- Starting Hive temporary data generation"

box_out "Starting Data generation for Hive Test"

gen_hive_data

box_out "Creating Hive table hive_test"

hive -e "drop table hive_test"
hive -e "create EXTERNAL table hive_test (file_id string) location '/tmp/hive_random/'"

box_out "Display first 5 rows"

hive -e "select * From hive_test limit 5"

box_out "Display table count"
hive -e "select count(*) From hive_test"

box_out "Starting Hadoop cluster benchmark at `get_time`"

run_benchmark

else
echo "HDFS is in SafeMode - Exiting!"
exit 0;
fi
box_out "Ending HDFS health check at `get_time`"


