## spark安装(以192.168.52.160为例)
## 1. 安装
* 创建安装目录 

    ```
    mkdir -p /opt/hadoop/  
    cd /opt/hadoop/
    ```

* 下载压缩包
[spark-2.0.0-bin-hadoop2.7.tgz](http://spark.apache.org/downloads.html)

* 解压缩文件

    `tar -zxvf spark-2.0.0-bin-hadoop2.7.tgz -C /opt/hadoop/`

    [root@biqa160 hadoop]# cd /opt/hadoop/
    [root@biqa160 hadoop]# mv spark-2.0.0-bin-hadoop2.7/ spark-2.0.0/ 

    ![解压后](./image/spark1.png)

## 2. 配置

* 配置环境变量

```
vi /etc/profile
//修改如下

export SPARK_HOME=/opt/hadoop/spark-2.0.0

export PATH=$JAVA_HOME/bin:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$HIVE_HOME/bin:$KAFKA_HOME/bin:$FLUME_HOME/bin:$SQOOP_HOME/bin:$SBT_HOME:$SCALA_HOME/bin:$SPARK_HOME/bin:$M2_HOME/bin:$PATH

<!-- 添加后执行： -->
source /etc/profile
```

***
# 单节点配置

* 修改配置文件`spark-env.sh`

```
[root@biqa160 conf]# pwd
/opt/hadoop/spark-2.0.0/conf
[root@biqa160 conf]# cp spark-env.sh.template spark-env.sh
[root@biqa160 conf]# vi spark-env.sh

export JAVA_HOME=/usr/java/jdk1.8.0_45
export SPARK_MASTER_HOST=biqa160
export HADOOP_HOME=/opt/hadoop/hadoop-2.7.2
export HADOOP_CONF_DIR=/opt/hadoop/hadoop-2.7.2/etc/hadoop
export SCALA_HOME=/opt/hadoop/scala-2.11.8
```

*  执行`sbin/start-all.sh`

```
[root@biqa160 sbin]# ./start-all.sh 
starting org.apache.spark.deploy.master.Master, logging to /opt/hadoop/spark-2.0.0/logs/spark-root-org.apache.spark.deploy.master.Master-1-biqa160.out
localhost: starting org.apache.spark.deploy.worker.Worker, logging to /opt/hadoop/spark-2.0.0/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-biqa160.out
[root@biqa160 sbin]# jps
592 Master
1857 NodeManager
1347 DataNode
10888 HRegionServer
730 Worker
14923 ProdServerStart
844 Jps
18623 Kafka
[root@biqa160 sbin]# 
```
【查看存在Master和Worker进程，启动成功】

* 运行spark提供的示例检测：`bin/run-example JavaSparkPi 5 2`

![测试](./image/spark2.png)

<font color=blue>浏览器输入地址`http://biqa160:8080/`</font>  


![测试](./image/spark3.png)

终端输入`spark-shell`

![测试](./image/spark4.png)

***

# 多节点配置

>我们部署的是单节点，多节点只做简要讲述。

在上述单个节点启动成功的基础上，配置多个节点集群环境是比较简单的一件事情。

## 1.  修改文件slaves
 
    修改master上节点的slaves配置文件来配置Worker节点的位置，这里可以将biqa161、biqa162 作为Worker节点的运行机器，在conf/slaves(复制slaves.template)中添加biqa161、biqa162

```
[root@biqa160 conf]# pwd
/opt/hadoop/spark-2.0.0/conf
[root@biqa160 conf]# cp slaves.template slaves

biqa161
biqa162
```

## 2.  将Master节点的spark目录，分发到其他节点相同目录下

```
scp -r /opt/hadoop/spark-2.0.0 biqa161:/opt/hadoop/
scp -r /opt/hadoop/spark-2.0.0 biqa162:/opt/hadoop/
```

## 3. 启动spark集群`sbin/start-all.sh`

    【通过jsp命令查看其他节点Worker进程是否存在】

## 4. 浏览器输入地址`http://biqa160:8080/`

【可以查看集群状态】

## 5. 运行测试

Standalone模式的测试

在shell环境下运行Spark提供的案例程序JavaSparkPi，通过如下命令：
bin/spark-submit –class org.apache.spark.examples.JavaSparkPi –master spark://biqa160:7077 examples/jars/spark-examples_2.11-2.0.0.jar 10 4

可在浏览器查看程序运行情况

## 6. 集群到yarn模式测试

在Master中执行
```
/usr/local/spark/bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --driver-memory 1G --executor-memory 1G --executor-cores 1 /usr/local/spark/examples/jars/spark-examples_2.11-2.2.0.jar 40

17/09/23 23:02:55 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
17/09/23 23:03:02 INFO yarn.Client: Requesting a new application from cluster with 4 NodeManagers
17/09/23 23:03:02 INFO yarn.Client: Verifying our application has not requested more than the maximum memory capability of the cluster (8192 MB per container)
17/09/23 23:03:02 INFO yarn.Client: Will allocate AM container, with 1408 MB memory including 384 MB overhead
17/09/23 23:03:02 INFO yarn.Client: Setting up container launch context for our AM
17/09/23 23:03:02 INFO yarn.Client: Setting up the launch environment for our AM container
17/09/23 23:03:02 INFO yarn.Client: Preparing resources for our AM container
17/09/23 23:03:04 WARN yarn.Client: Neither spark.yarn.jars nor spark.yarn.archive is set, falling back to uploading libraries under SPARK_HOME.
17/09/23 23:03:10 INFO yarn.Client: Uploading resource file:/tmp/spark-97bd44a3-14aa-4a8a-8be6-5a2f46aa56ae/__spark_libs__3729487364604846424.zip -> hdfs://jwlhadoop/user/root/.sparkStaging/application_1506105886034_0010/__spark_libs__3729487364604846424.zip
17/09/23 23:03:19 INFO yarn.Client: Uploading resource file:/usr/local/spark/examples/jars/spark-examples_2.11-2.2.0.jar -> hdfs://jwlhadoop/user/root/.sparkStaging/application_1506105886034_0010/spark-examples_2.11-2.2.0.jar
17/09/23 23:03:20 INFO yarn.Client: Uploading resource file:/tmp/spark-97bd44a3-14aa-4a8a-8be6-5a2f46aa56ae/__spark_conf__6661014463319380674.zip -> hdfs://jwlhadoop/user/root/.sparkStaging/application_1506105886034_0010/__spark_conf__.zip
17/09/23 23:03:20 INFO spark.SecurityManager: Changing view acls to: root
17/09/23 23:03:20 INFO spark.SecurityManager: Changing modify acls to: root
17/09/23 23:03:20 INFO spark.SecurityManager: Changing view acls groups to:
17/09/23 23:03:20 INFO spark.SecurityManager: Changing modify acls groups to:
17/09/23 23:03:20 INFO spark.SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users  with view permissions: Set(root); groups with view permissions: Set(); users  with modify permissions: Set(root); groups with modify permissions: Set()
17/09/23 23:03:20 INFO yarn.Client: Submitting application application_1506105886034_0010 to ResourceManager
17/09/23 23:03:21 INFO impl.YarnClientImpl: Submitted application application_1506105886034_0010
17/09/23 23:03:22 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:22 INFO yarn.Client:
	 client token: N/A
	 diagnostics: N/A
	 ApplicationMaster host: N/A
	 ApplicationMaster RPC port: -1
	 queue: default
	 start time: 1506179001001
	 final status: UNDEFINED
	 tracking URL: http://hadoop1.jwl.com:8088/proxy/application_1506105886034_0010/
	 user: root
17/09/23 23:03:23 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:24 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:25 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:26 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:27 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:28 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:29 INFO yarn.Client: Application report for application_1506105886034_0010 (state: ACCEPTED)
17/09/23 23:03:30 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:30 INFO yarn.Client:
	 client token: N/A
	 diagnostics: N/A
	 ApplicationMaster host: 192.168.0.143
	 ApplicationMaster RPC port: 0
	 queue: default
	 start time: 1506179001001
	 final status: UNDEFINED
	 tracking URL: http://hadoop1.jwl.com:8088/proxy/application_1506105886034_0010/
	 user: root
17/09/23 23:03:31 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:32 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:33 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:34 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:35 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:36 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:37 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:38 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:39 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:40 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:41 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:42 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:43 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:44 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:45 INFO yarn.Client: Application report for application_1506105886034_0010 (state: RUNNING)
17/09/23 23:03:46 INFO yarn.Client: Application report for application_1506105886034_0010 (state: FINISHED)
17/09/23 23:03:46 INFO yarn.Client:
	 client token: N/A
	 diagnostics: N/A
	 ApplicationMaster host: 192.168.0.143
	 ApplicationMaster RPC port: 0
	 queue: default
	 start time: 1506179001001
	 final status: SUCCEEDED
	 tracking URL: http://hadoop1.jwl.com:8088/proxy/application_1506105886034_0010/
	 user: root
17/09/23 23:03:46 INFO util.ShutdownHookManager: Shutdown hook called
17/09/23 23:03:46 INFO util.ShutdownHookManager: Deleting directory /tmp/spark-97bd44a3-14aa-4a8a-8be6-5a2f46aa56ae
[root@hadoop1 local]# /usr/local/spark/bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --driver-memory 1G --executor-memory 1G --executor-cores 1 /usr/local/spark/examples/jars/spark-examples_2.11-2.2.0.jar 40
17/09/23 23:04:59 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
17/09/23 23:05:06 INFO yarn.Client: Requesting a new application from cluster with 4 NodeManagers
17/09/23 23:05:06 INFO yarn.Client: Verifying our application has not requested more than the maximum memory capability of the cluster (8192 MB per container)
17/09/23 23:05:06 INFO yarn.Client: Will allocate AM container, with 1408 MB memory including 384 MB overhead
17/09/23 23:05:06 INFO yarn.Client: Setting up container launch context for our AM
17/09/23 23:05:06 INFO yarn.Client: Setting up the launch environment for our AM container
17/09/23 23:05:06 INFO yarn.Client: Preparing resources for our AM container
17/09/23 23:05:08 WARN yarn.Client: Neither spark.yarn.jars nor spark.yarn.archive is set, falling back to uploading libraries under SPARK_HOME.
17/09/23 23:05:14 INFO yarn.Client: Uploading resource file:/tmp/spark-f8ffab26-df04-46ce-9089-a6e65e0c0f2d/__spark_libs__238880829423534068.zip -> hdfs://jwlhadoop/user/root/.sparkStaging/application_1506105886034_0011/__spark_libs__238880829423534068.zip
17/09/23 23:05:23 INFO yarn.Client: Uploading resource file:/usr/local/spark/examples/jars/spark-examples_2.11-2.2.0.jar -> hdfs://jwlhadoop/user/root/.sparkStaging/application_1506105886034_0011/spark-examples_2.11-2.2.0.jar
17/09/23 23:05:24 INFO yarn.Client: Uploading resource file:/tmp/spark-f8ffab26-df04-46ce-9089-a6e65e0c0f2d/__spark_conf__1180632848137562538.zip -> hdfs://jwlhadoop/user/root/.sparkStaging/application_1506105886034_0011/__spark_conf__.zip
17/09/23 23:05:24 INFO spark.SecurityManager: Changing view acls to: root
17/09/23 23:05:24 INFO spark.SecurityManager: Changing modify acls to: root
17/09/23 23:05:24 INFO spark.SecurityManager: Changing view acls groups to:
17/09/23 23:05:24 INFO spark.SecurityManager: Changing modify acls groups to:
17/09/23 23:05:24 INFO spark.SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users  with view permissions: Set(root); groups with view permissions: Set(); users  with modify permissions: Set(root); groups with modify permissions: Set()
17/09/23 23:05:24 INFO yarn.Client: Submitting application application_1506105886034_0011 to ResourceManager
17/09/23 23:05:25 INFO impl.YarnClientImpl: Submitted application application_1506105886034_0011
17/09/23 23:05:26 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:26 INFO yarn.Client:
	 client token: N/A
	 diagnostics: N/A
	 ApplicationMaster host: N/A
	 ApplicationMaster RPC port: -1
	 queue: default
	 start time: 1506179124862
	 final status: UNDEFINED
	 tracking URL: http://hadoop1.jwl.com:8088/proxy/application_1506105886034_0011/
	 user: root
17/09/23 23:05:27 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:28 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:29 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:30 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:31 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:32 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:33 INFO yarn.Client: Application report for application_1506105886034_0011 (state: ACCEPTED)
17/09/23 23:05:34 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:34 INFO yarn.Client:
	 client token: N/A
	 diagnostics: N/A
	 ApplicationMaster host: 192.168.0.143
	 ApplicationMaster RPC port: 0
	 queue: default
	 start time: 1506179124862
	 final status: UNDEFINED
	 tracking URL: http://hadoop1.jwl.com:8088/proxy/application_1506105886034_0011/
	 user: root
17/09/23 23:05:35 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:36 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:37 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:38 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:39 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:40 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:41 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:42 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:43 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:44 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:45 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:46 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:47 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:48 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:49 INFO yarn.Client: Application report for application_1506105886034_0011 (state: RUNNING)
17/09/23 23:05:50 INFO yarn.Client: Application report for application_1506105886034_0011 (state: FINISHED)
17/09/23 23:05:50 INFO yarn.Client:
	 client token: N/A
	 diagnostics: N/A
	 ApplicationMaster host: 192.168.0.143
	 ApplicationMaster RPC port: 0
	 queue: default
	 start time: 1506179124862
	 final status: SUCCEEDED
	 tracking URL: http://hadoop1.jwl.com:8088/proxy/application_1506105886034_0011/
	 user: root
17/09/23 23:05:50 INFO util.ShutdownHookManager: Shutdown hook called
17/09/23 23:05:50 INFO util.ShutdownHookManager: Deleting directory /tmp/spark-f8ffab26-df04-46ce-9089-a6e65e0c0f2d
```

















