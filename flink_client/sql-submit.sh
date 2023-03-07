#!/bin/bash
#export HADOOP_HOME=/opt/hadoop
#export HADOOP_CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath`


cd ${SQL_CLIENT_HOME}

echo "run job "
echo ${FLINK_HOME}/bin/sql-client.sh embedded -f job/$1

${FLINK_HOME}/bin/sql-client.sh embedded -f job/$1