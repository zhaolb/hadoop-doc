# Hue的安装和部署

## 1.在root用户下用yum安装所依赖的系统包（能联网）
```
yum -y install ant asciidoc cyrus-sasl-devel cyrus-sasl-gssapi gcc gcc-c++ krb5-devel libtidy libxml2-devel libxslt-devel openldap-devel python-devel sqlite-devel openssl-devel mysql-devel gmp-devel  
```
安装的时候发现并没有libtidy包，网上查了下所这个libtidy只对于单元测试而言，没安装上倒也不影响安装


## 2.编译hue

[参考地址](http://www.cnblogs.com/sanduo1314/p/7420472.html)
```
注意：需要maven工具

git clone https://github.com/cloudera/hue.git
cd hue
make apps

The configuration in development mode is desktop/conf/pseudo-distributed.ini.

如果编译出现问题，需要重新clean，再编译
make clean
make apps
```

## 3.修改数据库到mysql

[参考地址](http://www.cnblogs.com/ivanny/p/hue_mysql_meta_dabatase.html)
```
注意：hue4.0的配置文件是hue目录下，文件名发生了改变；hue/desktop/conf/pseudo-distributed.ini

hue默认使用sqlite作为元数据库，不推荐在生产环境中使用这个数据库
使用mysql做元数据

1， 修改hue.ini文件
[[database]]
engine=mysql
host=
port=
user=<用户名>
password=<密码>
name=<数据库名称，新数据库，专门用于hue,里面现在没有任何表>

完成以上的这个配置，启动Hue,通过浏览器访问，会发生错误，原因是mysql数据没有被初始化
defaulterrorhandler
raise errorclass, errorvalue
DatabaseError: (1146, "Table 'hue.desktop_settings' doesn't exist")

2, 初始化数据库
2.1) bin/hue syncdb
2.2) bin/hue migrate

执行完以后，可以在mysql中看到，hue相应的表已经生成。
```

## 4.修改配置文件
```
注意：hue4.0的配置文件是hue目录下，文件名发生了改变；hue/desktop/conf/pseudo-distributed.ini

```
配置hadoop集群的访问权限
```
由于hue的启动用户是hue，所以需要为hue添加集群的访问权限，在各节点的/usr/local/hadoop/etc/hadoop/core-site.xml，添加如下参数：

<property>
  <name>hadoop.proxyuser.hue.hosts</name>
  <value>*</value>
</property>
<property>
  <name>hadoop.proxyuser.hue.groups</name>
  <value>*</value>
</property>
<property>
  <name>hadoop.proxyuser.root.hosts</name>
  <value>*</value>
</property>
<property>
  <name>hadoop.proxyuser.root.groups</name>
  <value>*</value>
</property>
<property>
  <name>hadoop.proxyuser.jinweile.hosts</name>
  <value>*</value>
</property>
<property>
  <name>hadoop.proxyuser.jinweile.groups</name>
  <value>*</value>
</property>

配置完，记得重启hadoop集群
```