#!/bin/bash
export HADOOP_HOME=/opt/hadoop
export HADOOP_CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath`


if [ -z $1 ]
then
    echo "必须指定 sql 文件，例如 iceberg_basic.sql"
else
    echo "job  $1"
    ${FLINK_HOME}/bin/sql-client.sh embedded -l ${SQL_CLIENT_HOME}/lib -f ${SQL_CLIENT_HOME}/job/$1
fi