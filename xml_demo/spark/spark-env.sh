#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file is sourced when running various Spark programs.
# Copy it as spark-env.sh and edit that to configure Spark for your site.

# Options read when launching programs locally with
# ./bin/run-example or ./bin/spark-submit
# - HADOOP_CONF_DIR, to point Spark towards Hadoop configuration files
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public dns name of the driver program
# - SPARK_CLASSPATH, default classpath entries to append

# Options read by executors and drivers running inside the cluster
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public DNS name of the driver program
# - SPARK_CLASSPATH, default classpath entries to append
# - SPARK_LOCAL_DIRS, storage directories to use on this node for shuffle and RDD data
# - MESOS_NATIVE_JAVA_LIBRARY, to point to your libmesos.so if you use Mesos

# Options read in YARN client mode
# - HADOOP_CONF_DIR, to point Spark towards Hadoop configuration files
# - SPARK_EXECUTOR_INSTANCES, Number of executors to start (Default: 2)
# - SPARK_EXECUTOR_CORES, Number of cores for the executors (Default: 1).
# - SPARK_EXECUTOR_MEMORY, Memory per Executor (e.g. 1000M, 2G) (Default: 1G)
# - SPARK_DRIVER_MEMORY, Memory for Driver (e.g. 1000M, 2G) (Default: 1G)
# - SPARK_YARN_APP_NAME, The name of your application (Default: Spark)
# - SPARK_YARN_QUEUE, The hadoop queue to use for allocation requests (Default: ‘default’)
# - SPARK_YARN_DIST_FILES, Comma separated list of files to be distributed with the job.
# - SPARK_YARN_DIST_ARCHIVES, Comma separated list of archives to be distributed with the job.

# Options for the daemons used in the standalone deploy mode
# - SPARK_MASTER_IP, to bind the master to a different IP address or hostname
# - SPARK_MASTER_PORT / SPARK_MASTER_WEBUI_PORT, to use non-default ports for the master
# - SPARK_MASTER_OPTS, to set config properties only for the master (e.g. "-Dx=y")
# - SPARK_WORKER_CORES, to set the number of cores to use on this machine
# - SPARK_WORKER_MEMORY, to set how much total memory workers have to give executors (e.g. 1000m, 2g)
# - SPARK_WORKER_PORT / SPARK_WORKER_WEBUI_PORT, to use non-default ports for the worker
# - SPARK_WORKER_INSTANCES, to set the number of worker processes per node
# - SPARK_WORKER_DIR, to set the working directory of worker processes
# - SPARK_WORKER_OPTS, to set config properties only for the worker (e.g. "-Dx=y")
# - SPARK_DAEMON_MEMORY, to allocate to the master, worker and history server themselves (default: 1g).
# - SPARK_HISTORY_OPTS, to set config properties only for the history server (e.g. "-Dx=y")
# - SPARK_SHUFFLE_OPTS, to set config properties only for the external shuffle service (e.g. "-Dx=y")
# - SPARK_DAEMON_JAVA_OPTS, to set config properties for all daemons (e.g. "-Dx=y")
# - SPARK_PUBLIC_DNS, to set the public dns name of the master or workers

# Generic options for the daemons used in the standalone deploy mode
# - SPARK_CONF_DIR      Alternate conf dir. (Default: ${SPARK_HOME}/conf)
# - SPARK_LOG_DIR       Where log files are stored.  (Default: ${SPARK_HOME}/logs)
# - SPARK_PID_DIR       Where the pid file is stored. (Default: /tmp)
# - SPARK_IDENT_STRING  A string representing this instance of spark. (Default: $USER)
# - SPARK_NICENESS      The scheduling priority for daemons. (Default: 0)


#export SPARK_MASTER_IP=db-nn1.inc.mtime.com
export SPARK_WORKER_MEMORY=5G
export SPARK_MEM=${SPARK_MEM:-5g}
JAVA_OPTS="$OUR_JAVA_OPTS"
JAVA_OPTS="$JAVA_OPTS-Xms$SPARK_MEM -Xmx$SPARK_MEM"
JAVA_OPTS="$JAVA_OPTS-Djava.library.path=$SPARK_LIBRARY_PATH"
export SPARK_PID_DIR=$SPARK_HOME/logs/pid

############
#export MAHOUT_HOME=/home/hadoop/apache-hadoop/apache-mahout-distribution-0.10.1
#export MAHOUT_CONF_DIR=$MAHOUT_HOME/conf
export JAVA_HOME=/usr/java/jdk1.8.0_45
export HADOOP_HOME=/home/hadoop/apache-hadoop/hadoop
export HBASE_HOME=/home/hadoop/apache-hadoop/hbase
export HIVE_HOME=/home/hadoop/apache-hadoop/hive
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
export HADOOP_YARN_HOME=${HADOOP_HOME}
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HDFS_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export SPARK_HOME=/home/hadoop/apache-hadoop/spark
export SCALA_HOME=/home/hadoop/apache-hadoop/scala
#export PBS_HOME=/var/torque

#export PATH=$JAVA_HOME/bin:$MAHOUT_HOME/bin:$HBASE_HOME/bin:$HIVE_HOME/bin:$HADOOP_HOME/bin:$SPARK_HOME/bin:$HADOOP_CONF_DIR:$MAHOUT_CONF_DIR:$SCALA_HOME/bin:$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export classpath=$JAVA_HOME/lib/dt.jar:$HBASE_HOME/lib:$MAHOUT_HOME/lib:$PIG_HOME/lib:$HIVE_HOME/lib:$JAVA_HOME/lib/tools.jar:$HADOOP_CONF_DIR:$SPARK_HOME/lib:${HADOOP_HOME}/lib
export HADOOP_CLASSPATH=$JAVA_HOME/lib/dt.jar:$HBASE_HOME/lib/*:$MAHOUT_HOME/lib/*:$PIG_HOME/lib:$HIVE_HOME/lib/*:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/*:$HADOOP_CONF_DIR:$SPARK_HOME/lib/*:${HADOOP_HOME}/lib/*:$HADOOP_CLASSPATH:
export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/$OS_ARCH/server:${HADOOP_HOME}/c++/Linux-$OS_ARCH-$OS_BIT/lib:/usr/local/lib:/usr/lib:${PBS_HOME}/lib:/usr/lib64


