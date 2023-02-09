#!/bin/bash
export HADOOP_HOME=/opt/hadoop
export HADOOP_CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath`


if [ -z $1 ]
then
    echo "basic"
    ${FLINK_HOME}/bin/sql-client.sh embedded -l ${SQL_CLIENT_HOME}/lib
else
    echo "job  $1"
    ${FLINK_HOME}/bin/sql-client.sh embedded -l ${SQL_CLIENT_HOME}/lib -i ${SQL_CLIENT_HOME}/job/$1
fi
#${FLINK_HOME}/bin/sql-client.sh embedded -l ${SQL_CLIENT_HOME}/lib
# ${FLINK_HOME}/bin/sql-client.sh embedded -l ${SQL_CLIENT_HOME}/lib -i ${SQL_CLIENT_HOME}/job/iceberg_basic.sql