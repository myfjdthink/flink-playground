#!/bin/bash
#export HADOOP_HOME=/opt/hadoop
#export HADOOP_CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath`


if [ -z $1 ]
then
    echo "必须指定 udf 文件，例如 basic/python_basic_udf.py"
else
    echo "submit job  $1"
    echo ${FLINK_HOME}/bin/sql-client.sh -pyfs ${SQL_CLIENT_HOME}py_udf/$1
    ${FLINK_HOME}/bin/sql-client.sh -pyfs ${SQL_CLIENT_HOME}py_udf/$1
fi