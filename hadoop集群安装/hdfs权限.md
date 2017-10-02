# hadoop用户权限
```
hdfs权限：
hdfs dfs -chmod -R 777 /tmp
hdfs dfs -chmod -R 777 /user

注意：其中第一条可以让任何用户有操作hive的权限

centos系统增加用户，增加组，从组中删除用户
增加用户：useradd hue
设置密码：passwd hue
增加组：groupadd hue
从root组中删除hue用户：gpasswd -d hue root
```