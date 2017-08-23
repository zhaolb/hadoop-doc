# 大数据集群安装

***

#### 服务器列表
服务器 | ip | 模块
------|------------|---------
bidev191 | 192.168.51.191 | hdfs.namenode主、hbase主、yarn.resourceManager、jenkins、zk
bidev192 | 192.168.51.192 | hdfs.namenode备、hdfs.datanode、hbase备、yarn.nodemanager、zk
bidev193 | 192.168.51.193 | hdfs.datanode、hbase.slave、yarn.nodemanager、zk
bidev197 | 192.168.51.197 | hdfs.datanode、hbase.slave、yarn.nodemanager、hue
biqa160 | 192.168.52.160 | hdfs.datanode、hbase.slave、hive、yarn.nodemanager、flume、spark、scala、sqoop、kafka
biqa161 | 192.168.52.161 | hdfs.datanode、hbase.slave、hive、yarn.nodemanager、flume、kafka
biqa162 | 192.168.52.162 | hdfs.datanode、hbase.slave、hive、yarn.nodemanager  flume、kafka

<!-- 
bidev192 | apache-flume-1.6.0-bin  hadoop-2.7.2       kafka_2.11-0.10.0.0        zookeeper-3.4.6  apache-flume-1.6.0-fixed-bin.tar.gz  hbase-1.2.4    scala-2.11.8
apache-hive-2.1.1-bin impala-2.8.0-cdh5.11.0-src.tar.gz <br/>spark-2.0.0-bin-hadoop2.7 | tt
bidev191 | apache-hive-2.1.1-bin  backup        hbase-1.2.4  kafka_2.11-0.10.0.0    oozie-4.0.0-cdh5.1.0  zkui
apache-maven-3.5.0     hadoop-2.7.2  hue-3.11.0   kafka-manager-1.3.0.8  scala-2.11.8          zookeeper-3.4.6
 -->

 ***

## 一、环境检查

1. 时钟同步（需同步）`vi /etc/ntp.conf`
2. selinux安全是否关闭（需关闭）`vi /etc/selinux/config` 
3. 是否安装jdk（需安装1.8+）
4. 安装sdk（2.11+）
5. [配置免密码登录](http://www.jb51.net/article/95897.htm)
6. 防火墙是否关闭（需关闭）
7. 安装mysql


#### 组件安装顺序及版本号
序号|模块|版本号|角色
----|------------------|------------|------------------------|
1 | zookeeper | 3.4.6 | bidev191、bidev192、bidev193
2 | hadoop | 2.7.2 | bidev191、bidev192、bidev193、bidev197、biqa160、biqa161、biqa162
3 | hive | 2.1.0 | biqa160、biqa161、biqa162 
4 | hbase | 1.2.4 | bidev191、bidev192、bidev193、bidev197、biqa160、biqa161、biqa162 
5 | scala | 2.11.8 | biqa160 
6 | spark | 2.0.0 | biqa160 
7 | flume | 1.6.0 | biqa160 
8 | sqoop | 1.99.7-bin-hadoop200 | biqa160 
*9 | oozie | 4.0.0 | qa191 
*10 | hue | 3.9.0 | qa191 
11 | jenkins | 2.19.1 | biqa161、biqa162
12 | kafka | 2.11-0.10.0.0 | biqa160、biqa161、biqa162 

***

## 二、组件安装
### [一、zookeeper集群安装(以192.168.51.191为例)](./zookeeper安装.md)

### [二、hadoop集群安装(以192.168.51.191为例)](./hadoop安装.md)

### [三、hive集群安装(以192.168.52.160为例)](./hive安装.md)

### [四、hbase集群安装(以192.168.51.191为例)](./hbase安装.md)

### [五、scala安装(以192.168.52.160为例)](./scala安装.md)

### [六、spark安装(以192.168.52.160为例)](./spark安装.md)

### [七、flume安装(以192.168.52.160为例)](./flume安装.md)

### [八、sqoop安装(以192.168.52.160为例)](./sqoop安装.md)

### [*九、oozie安装(以192.168.52.160为例)](./oozie安装.md)

### [*十、hue安装(以192.168.52.160为例)](./hue安装.md)

### [十一、jenkis安装(以192.168.52.160为例)](./jenkis安装.md)

### [十二、kafka安装(以192.168.52.160为例)](./kafka安装.md)




















