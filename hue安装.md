# Hue的安装和部署

## 1.在root用户下用yum安装所依赖的系统包（能联网）
```
yum -y install ant asciidoc cyrus-sasl-devel cyrus-sasl-gssapi gcc gcc-c++ krb5-devel libtidy libxml2-devel libxslt-devel openldap-devel python-devel sqlite-devel openssl-devel mysql-devel gmp-devel  
```
安装的时候发现并没有libtidy包，网上查了下所这个libtidy只对于单元测试而言，没安装上倒也不影响安装


## 2.编译hue

## 3.修改数据库到mysql

[参考地址](http://www.cnblogs.com/ivanny/p/hue_mysql_meta_dabatase.html)