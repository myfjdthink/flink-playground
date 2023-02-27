#!/bin/bash
#export HADOOP_HOME=/opt/hadoop
#export HADOOP_CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath`


if [ -z $1 ]
then
    echo "必须指定 sql 文件，例如 iceberg_basic.sql"
else
    echo "submit job  $1 with $2"
    echo ${FLINK_HOME}/bin/sql-client.sh embedded -f ${SQL_CLIENT_HOME}job/$1 -pyfs ${SQL_CLIENT_HOME}py_udf/$2
    ${FLINK_HOME}/bin/sql-client.sh embedded -f ${SQL_CLIENT_HOME}job/$1 -pyfs ${SQL_CLIENT_HOME}py_udf/$2
fi