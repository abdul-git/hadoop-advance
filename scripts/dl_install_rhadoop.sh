#!/bin/bash
############################################
##      Writen by Abdul Khan
##      Version 1.0
##
##      Execution: ./dl_install_rhadoop.sh
##      Copyright: Script is property of Abdul Khan
##                 explicit permission must request prior
##                 to modifying content
##      Email : abdulk@gmail.com
############################################

## Script downloads RHadoop packages and install is done on local node.
DL_DIR=/tmp

#Functions
function get_time() {
date
}
function get_packages() {
wget --directory-prefix=$DL_DIR https://github.com/abdul-git/hadoop-advance/raw/master/packages/ravro_1.0.4.tar.gz
wget --directory-prefix=$DL_DIR https://github.com/abdul-git/hadoop-advance/raw/master/packages/plyrmr_0.6.0.tar.gz
wget --directory-prefix=$DL_DIR https://github.com/abdul-git/hadoop-advance/raw/master/packages/rhbase_1.2.1.tar.gz
wget --directory-prefix=$DL_DIR https://github.com/abdul-git/hadoop-advance/raw/master/packages/rhdfs_1.0.8.tar.gz
wget --directory-prefix=$DL_DIR https://github.com/abdul-git/hadoop-advance/raw/master/packages/rmr2_3.3.1.tar.gz
}

function install_packages() {
R CMD INSTALL $DL_DIR/ravro_1.0.4.tar.gz
R CMD INSTALL $DL_DIR/rmr2_3.3.1.tar.gz
R CMD INSTALL $DL_DIR/plyrmr_0.6.0.tar.gz
R CMD INSTALL $DL_DIR/rhdfs_1.0.8.tar.gz
}

#Functions

#Set HDFS variables
#future script will work with CDH or HDP - only compatible with CDH right now.
##

#HDFS Environment variables
export HADOOP_PREFIX=/opt/cloudera/parcels/CDH/lib/hadoop
export HADOOP_CMD=/usr/bin/Hadoop
export HADOOP_STREAMING=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar

## Compile R java
R CMD javareconf

## Download RHadoop packages
get_packages

##Sleep for 30 secs
sleep 30

## Install packages
install_packages


