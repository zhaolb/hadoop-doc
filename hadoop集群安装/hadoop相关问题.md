## hadoop���������ܣ�
### 1. yarnͨ��cgroup������Դ��cpu��

* ��Դhadoop������cgroup����е����⣬���ܻ��������ܱ�����

* [�ο���ַ](http://www.jianshu.com/p/e283ab7e2530)  

```
yarnĬ��ֻ�����ڴ���Դ,��ȻҲ��������cpu��Դ,������û��cpu��Դ����������Ч��������̫��.�ڼ�Ⱥ��ģ��,�����ʱ��Դ������������Ϊ����.
����yarn�ṩ��LinuxContainerExecutor����ͨ��cgroup������cpu��Դ

cgroup

cgroup��ϵͳ�ṩ����Դ���빦��,���Ը���ϵͳ�Ķ������͵���Դ,yarnֻ��������cpu��Դ

��װcgroup

Ĭ��ϵͳ�Ѿ���װ��cgroup��,���û�а�װ����ͨ�����װ
CentOS 6

yum install -y libcgroup
CentOS 7

yum install -y libcgroup-tools
Ȼ��ͨ����������
CentOS 6

/etc/init.d/cgconfig start
CentOS 7

systemctl start cgconfig.service
�鿴/cgroupĿ¼,���Կ��������Ѿ�������һЩĿ¼,��ЩĿ¼���ǿ��Ը������Դ

drwxr-xr-x 2 root root 0 3��  19 20:56 blkio
drwxr-xr-x 3 root root 0 3��  19 20:56 cpu
drwxr-xr-x 2 root root 0 3��  19 20:56 cpuacct
drwxr-xr-x 2 root root 0 3��  19 20:56 cpuset
drwxr-xr-x 2 root root 0 3��  19 20:56 devices
drwxr-xr-x 2 root root 0 3��  19 20:56 freezer
drwxr-xr-x 2 root root 0 3��  19 20:56 memory
drwxr-xr-x 2 root root 0 3��  19 20:56 net_cls
���Ŀ¼û�д�������ִ��

cd /
mkdir cgroup
mount -t tmpfs cgroup_root ./cgroup
mkdir cgroup/cpuset
mount -t cgroup -ocpuset cpuset ./cgroup/cpuset/
mkdir cgroup/cpu
mount -t cgroup -ocpu cpu ./cgroup/cpu/
mkdir cgroup/memory
mount -t cgroup -omemory memory ./cgroup/memory/
ͨ��cgroup����cpu��Դ�Ĳ���Ϊ

��cpuĿ¼��������
cgroup����Ϊ��λ������Դ,ͬһ�������ʹ�õ���Դ��ͬ
һ������cgroup��������Ϊһ���ļ���,��������ֱ��ʹ��mkdir�����.
�����滹���Դ����¼���.���տ����γ�һ�����νṹ����ɸ��ӵ���Դ���뷽��.
ÿ��������һ����,ϵͳ���Զ���Ŀ¼��������һЩ�ļ�,��Դ������Ҫ����ͨ��������Щ�ļ������
--w--w--w- 1 root root 0 3��  19 21:09 cgroup.event_control
-rw-r--r-- 1 root root 0 3��  19 21:09 cgroup.procs
-rw-r--r-- 1 root root 0 3��  19 21:09 cpu.cfs_period_us
-rw-r--r-- 1 root root 0 3��  19 21:09 cpu.cfs_quota_us
-rw-r--r-- 1 root root 0 3��  19 21:09 cpu.rt_period_us
-rw-r--r-- 1 root root 0 3��  19 21:09 cpu.rt_runtime_us
-rw-r--r-- 1 root root 0 3��  19 21:09 cpu.shares
-r--r--r-- 1 root root 0 3��  19 21:09 cpu.stat
-rw-r--r-- 1 root root 0 3��  19 21:09 notify_on_release
-rw-r--r-- 1 root root 0 3��  19 21:09 tasks
yarnĬ��ʹ��hadoop-yarn����Ϊ���ϲ�,��������ʱyarn��Ϊÿ��container��hadoop-yarn���洴��һ����
yarn��Ҫʹ��cpu.cfs_quota_us cpu.cfs_period_us cpu.shares3���ļ�
yarnʹ��cgroup�����ַ�ʽ������cpu��Դ����
�ϸ񰴺���������Դ
��ʹ�ú��� = cpu.cfs_quota_us/cpu.cfs_period_us
��yarn��cpu.cfs_quota_us��ֱ������Ϊ1000000(��������������õ����ֵ)
Ȼ��������������core�������cpu.cfs_period_us
������������Դ
��ÿ����������cpu.shares�ı���������cpu
����A B C��������,cpu.shares�ֱ�����Ϊ1024 1024 2048,��ô���ǿ���ʹ�õ�cpu����Ϊ1:1:2
������id��ӵ�ָ�����tasks�ļ�
����������ֻ��Ҫ��Ҫ���ƵĽ��̵�idд��tasks�ļ�����,�����Ҫ�������,��tasks�ļ�ɾ������
yarn����

����cgroup��Ҫ���ü��������ļ�

etc/hadoop/yarn-site.xml����

���Բο�http://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/NodeManagerCgroups.html ����
��Щ���ô󲿷ֶ��ǹ̶�����

<property>
    <name>yarn.nodemanager.container-executor.class</name>
  <value>org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor</value>
</property>
<property>
    <name>yarn.nodemanager.linux-container-executor.resources-handler.class</name>
    <value>org.apache.hadoop.yarn.server.nodemanager.util.CgroupsLCEResourcesHandler</value>
</property>
<property>
    <description>yarnʹ�õ�cgroup��,Ĭ��Ϊ/hadoop-yarn</description>
    <name>yarn.nodemanager.linux-container-executor.cgroups.hierarchy</name>
    <value>/hadoop-yarn</value>
</property>
<property>
    <description>�Ƿ��Զ�����cgroup</description>
    <name>yarn.nodemanager.linux-container-executor.cgroups.mount</name>
    <value>true</value>
</property>
<property>
    <description>cgroup����Ŀ¼, /sys/fs/cgroup ������ /cgroup,Ŀ¼��ϵͳ�й�</description>
    <name>yarn.nodemanager.linux-container-executor.cgroups.mount-path</name>
    <value>/cgroup</value>
</property>
<property>
    <name>yarn.nodemanager.linux-container-executor.group</name>
    <value>hadoop</value>
</property>
<property>
    <description>����nodemanagerʹ�ö�������cpu��Դ,����24�˷���������90�Ļ�,���ʹ��21.6��</description>
    <name>yarn.nodemanager.resource.percentage-physical-cpu-limit</name>
    <value>90</value>
</property>
<property>
    <description>�ǿ����Ƿ��ϸ�����cpu,�������������core����,���Ƿ��ϸ�����,����core�ı�������</description>
    <name>yarn.nodemanager.linux-container-executor.cgroups.strict-resource-usage</name>
    <value>true</value>
</property>
<property>
    <description>�ǰ�ȫģʽ�������������õ��û�����container,��������hadoop�û�����hadoop����container</description>
    <name>yarn.nodemanager.linux-container-executor.nonsecure-mode.local-user</name>
    <value>hadoop</value>
</property>
etc/hadoop/container-executor.cfg����

��������ļ�ÿ���Ҫ��,Ҫ��Ȼ�ᱨ��

yarn.nodemanager.linux-container-executor.group=hadoop
banned.users=root
min.user.id=1000
allowed.system.users=hadoop
Ȩ������

���������ļ���Ȩ��������Ҫ��

chown root:hadoop bin/container-executor
chmod 6050 bin/container-executor
ϵͳ��Ҫ��etc/hadoop/container-executor.cfg �����и�Ŀ¼(һֱ��/ Ŀ¼) owner ��Ϊ root
���·����Ĭ��${HADOOP_HOME}/etc/hadoop/container-executor.cfg,����������޸����и���Ŀ¼ΪrootȨ��,�������±�����뵽����Ŀ¼,����/etc/hadoop/Ŀ¼

mvn clean package -Dcontainer-executor.conf.dir=/etc/hadoop/ -DskipTests -Pnative
���ú��Ժ����Ƿ����óɹ�

./bin/container-executor --checksetup
���û���κ������ʾ���óɹ�
���һ��˳���Ϳ���������Ⱥ��

����cgroup

�������в��Խű�����ϵͳ

./bin/spark-submit   \
--class org.apache.spark.examples.SparkPi   \
--master yarn-cluster   \
--deploy-mode cluster   \
--num-executors 5 \
--executor-cores 3 \
--executor-memory 4G \
--driver-memory 4G \
--driver-cores 2 \
lib/spark-examples-1.6.0-hadoop2.6.0.jar   10000
�鿴ϵͳ�Ƿ���Чֻ�ܵ�¼���������鿴
ͨ��top�鿴��Ϣ



�鿴�Ƿ񴴽���cgroup����,ll /cgroup/hadoop-yarn/

--w--w--w- 1 root root 0 3��  17 15:44 cgroup.event_control
-rw-r--r-- 1 root root 0 3��  17 15:44 cgroup.procs
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000011
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000026
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000051
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000076
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000101
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000123
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000136
drwxr-xr-x 2 root root 0 3��  17 16:06 container_1489736876249_0003_01_000155
drwxr-xr-x 2 root root 0 3��  17 16:30 container_1489736876249_0004_01_000008
-rw-r--r-- 1 root root 0 3��  17 15:47 cpu.cfs_period_us
-rw-r--r-- 1 root root 0 3��  17 15:47 cpu.cfs_quota_us
-rw-r--r-- 1 root root 0 3��  17 15:44 cpu.rt_period_us
-rw-r--r-- 1 root root 0 3��  17 15:44 cpu.rt_runtime_us
-rw-r--r-- 1 root root 0 3��  17 15:44 cpu.shares
-r--r--r-- 1 root root 0 3��  17 15:44 cpu.stat
-rw-r--r-- 1 root root 0 3��  17 15:44 notify_on_release
-rw-r--r-- 1 root root 0 3��  17 15:44 tasks
�鿴container_*Ŀ¼�� cpu.cfs_period_us,����cpu.cfs_quota_us/cpu.cfs_period_us����֪������ĺ���

[root@- ~]# cat /cgroup/cpu/hadoop-yarn/container*/cpu.cfs_period_us
462962
462962
462962
462962
462962
462962
462962
462962
308641
���⴦��

���õĹ������ⲻ�˻�����һЩ����,������������������

spark����������core,node manager���䲻��ȷ,���Ƿ���1����

���������Ŀǰʹ�õ�capacity scheduler����Դ���㷽ʽֻ�������ڴ�,û�п���CPU
���ַ�ʽ�ᵼ����Դʹ�����ͳ�Ʋ�׼ȷ,����һ��saprk��������������Դ��������

--num-executors 1 --executor-cores 3 --executor-memory 4G --driver-memory 4G --driver-cores 1
DefaultResourceCalculator ͳ��ռ2��
DominantResourceCalculator ͳ��ռ4��
�޸������ļ����ɽ��

  <property>
    <name>yarn.scheduler.capacity.resource-calculator</name>
    <value>org.apache.hadoop.yarn.util.resource.DominantResourceCalculator</value>
    <description>
      The ResourceCalculator implementation to be used to compare
      Resources in the scheduler.
      The default i.e. DefaultResourceCalculator only uses Memory while
      DominantResourceCalculator uses dominant-resource to compare
      multi-dimensional resources such as Memory, CPU etc.
    </description>
  </property>
container-executor����ʱ��ȱ��GLIBC_2.14��

container-executor: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by bin/container-executor)
�����ϵͳ�汾�й�,ֻ��ͨ�����±���container-executor�����

mvn clean package -Dcontainer-executor.conf.dir=/etc/hadoop/ -DskipTests -Pnative
centos 7ϵͳcontainer��������,����д��/cgroup/cpu

�����yarn��centos 7�µ�һ��bug,hadoop 2.8�Ժ�İ汾�Ż���
���bug��Ҫ����Ϊcentos 7��cgroup��Ŀ¼��centos 6��һ�µ���,centos 7 cpuĿ¼�ϲ���cpu,cpuacct, ���,���µĴ���,��Ҫ�򲹶������ https://issues.apache.org/jira/browse/YARN-2194

 private String findControllerInMtab(String controller,
                                      Map<String, List<String>> entries) {
    for (Entry<String, List<String>> e : entries.entrySet()) {
//      if (e.getValue().contains(controller))
//        return e.getKey();

      if (e.getValue().contains(controller)) {
        String controllerKey = e.getKey();
        // In Redhat7, the controller is called "/sys/fs/cgroup/cpu,cpuacct"
        controllerKey = controllerKey.replace("cpu,cpuacct", "cpu");
        if (new File(controllerKey).exists()) {
          return controllerKey;
        }
      }
    }

    return null;
  }
�����ķ���

���ڸı�����Դ�ĸ��뷽ʽ,���������м��������Ӱ��

������Դ��������

����cgroup�󵥸����������ǰ��Դ���䲻������ܻ���ּ�����ʱ���,������Դ����ʱ��Ҫ����������Դ
�ڼ�Ⱥ��ģС��ʱ�����û����Դ���Ե���,��ô�����޸�Ϊ���ϸ�ģʽ,���ϸ�ģʽ���ܰ�����������Դ,ֻ�ܱ�֤��Դ������������ȫ��ռ��

<property>
    <name>yarn.nodemanager.linux-container-executor.cgroups.strict-resource-usage</name>
    <value>false</value>
</property
spark driver��Դ����

spark�����driver�ڼ�Ⱥģʽdeploy-mode clusterʱ,���û������driver-cores�Ļ�Ĭ�Ϸ���1��,1���������ģ��ʱ�п�����Դ�����.����deploy-mode clientģʽ�Ĳ���cgroup����

���ߣ�����ĸ�
���ӣ�http://www.jianshu.com/p/e283ab7e2530
��Դ������
����Ȩ���������С���ҵת������ϵ���߻����Ȩ������ҵת����ע��������
```
