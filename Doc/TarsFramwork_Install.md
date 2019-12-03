TarsFramework 安装手册 -单机版
RobertQiu(邱鑫)
目录
说明... 4
硬件配置... 4
软件配置... 4
操作系统... 4
数据库版本... 4
Tars代码下载地址... 4
Tars 软件安装... 5
安装基本软件包... 5
安装Mysql 5
更新yum源... 5
安装yum源... 6
修改默认安装yum源... 8
执行安装命令... 10
获取临时密码... 10
登陆mysql 10
Web管理系统开发环境安装... 11
TarsFramework下载与安装... 11
下载... 11
编译... 11
安装... 12
Mysql配置... 13
准备数据库表项目... 13
Mysql用户权限添加... 14
创建数据库表项目... 15
启动Tars框架服务运行... 17
安装框架核心基础服务... 17
启动Tars进程... 19
启动tarsregistry. 19
启动tarsAdminRegist. 20
启动tarsconfig. 21
启动tarsnode. 21
安装TarsWeb.. 22
导入db_tars_web.sql 文件... 23
修改完成之后重新启动... 26
非框架核心服务编译和发布... 27
Tarsnotify发布... 27
tarsstat发布... 28
机器重启后，进程拉起... 30
常用诊断方法... 31
Web诊断... 31
日志... 31
Tars安装出现问题以及解决办法... 32
Mysql不能启动... 32
Mysql  8.0 版本不兼容问题... 32
模板管理无法显示... 33
Mysql无法登陆... 36
SSH配置... 36
内存不够导致发布失败... 36
客户端不能访问Tars Web网页... 37
未来有待进行的工作... 37
1.核心进程无法在Web界面显示。... 37
2.设置守护任何时候服务挂了，都可以恢复。... 38
3.  web需要刷新后，部署的界面才能跳出来。... 38
4. 在初始化的时候，web界面会显示版本和发布时间异常，因为此时数据库的表项有些内容是空的或者全零字段。    38

说明
本文记录安装Tars过程，由于是实验环境，所有服务都安装在同一台机器。 机器可以是本地物理机或者虚拟机，也可以是云主机（注意：如果是云主机的话，安装过程中绑定的IP地址为云主机的小网IP地址，而非公网IP地址）。 

硬件配置
如果是云主机至少2核4G起步。 我尝试过使用1核1G的机器，在发布Tars服务过程中出现了内存耗尽，导致web界面挂死的情况。
软件配置
操作系统
安装服务器中运行CentOS7系统，具体版本如下：
[root@VM_0_13_centos sql]# cat /proc/version
Linux version 3.10.0-514.26.2.el7.x86_64 (builder@kbuilder.dev.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC) ) #1 SMP Tue Jul 4 15:04:05 UTC 2017

数据库版本
[root@VM_0_13_centos sql]# mysql --version
mysqlVer 14.14 Distrib 5.7.26, for Linux (x86_64) usingEditLine wrapper

注：不要使用Mysql最新版本（8.0），目前存在各种版本兼容问题。

Tars代码下载地址
地址： https://github.com/TarsCloud/TarsFramework.git

Tars 软件安装
安装基本软件包
yum install glibc-devel
yum install cmake
yum install ncurses-devel
yum install zlib-devel
yum install perl
安装Mysql
MySQL安装时，选择mysql 5.6或者mysql 5.7.  不要选择mysql 8.0新版本，新版本的mysql存在很多版本兼容问题。

mysql 5.7的yum安装方法：

更新yum源
1)        首先找到oracle的官网，下载yum源
【注意】不要直接yum install mysql ，因为默认yum源安装的maridb, 根本不是mysql。

我找到的官网网址是：
 https://dev.mysql.com/downloads/repo/yum/
 
 其中有yum源，根据自己对应的版本下载：
 
 wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
 
 虽然下载的源文件的名字为mysql80-community-release-el7-3.noarch.rpm， 实际上其中包含了如下安装内容：
 


安装yum源
rpm -ivh mysql80-community-release-el7-3.noarch.rpm

安装完成之后，会在 /etc/yum.repos.d/ 目录下新增 mysql-community.repo 、mysql-community-source.repo 两个 yum 源文件。
[root@VM_0_13_centos ~]# cd /etc/yum.repos.d/
[root@VM_0_13_centos yum.repos.d]# ls
CentOS-Base.repo  CentOS-Epel.repo  mysql-community.repo  mysql-community-source.repo


执行如上命令安装完成之后，就可以使用 yum repolist all | grep mysql 查询到新的yum安装包，各种版本的都在其中。 
[root@VM_0_13_centos ~]# yum repolist all | grep mysql
mysql-cluster-7.5-community/x86_64 MySQL Cluster 7.5 Community   disabled
mysql-cluster-7.5-community-source MySQL Cluster 7.5 Community - disabled
mysql-cluster-7.6-community/x86_64 MySQL Cluster 7.6 Community   disabled
mysql-cluster-7.6-community-source MySQL Cluster 7.6 Community - disabled
mysql-cluster-8.0-community/x86_64 MySQL Cluster 8.0 Community   disabled
mysql-cluster-8.0-community-source MySQL Cluster 8.0 Community - disabled
mysql-connectors-community/x86_64  MySQL Connectors Community    enabled:    108
mysql-connectors-community-source  MySQL Connectors Community -  disabled
mysql-tools-community/x86_64       MySQL Tools Community         enabled:     90
mysql-tools-community-source       MySQL Tools Community - Sourc disabled
mysql-tools-preview/x86_64         MySQL Tools Preview           disabled
mysql-tools-preview-source         MySQL Tools Preview - Source  disabled
mysql55-community/x86_64           MySQL 5.5 Community Server    disabled
mysql55-community-source           MySQL 5.5 Community Server -  disabled
mysql56-community/x86_64           MySQL 5.6 Community Server    disabled
mysql56-community-source           MySQL 5.6 Community Server -  disabled
mysql57-community/x86_64           MySQL 5.7 Community Server    disabled
mysql57-community-source           MySQL 5.7 Community Server -  disabled
mysql80-community/x86_64           MySQL 8.0 Community Server    enabled:    113
mysql80-community-source           MySQL 8.0 Community Server -  disabled

修改默认安装yum源
如上可以看出来，默认的安装源为mysql80-community版本，我现在希望安装的版本是mysql57-community。 使用yum-config-manager --disable mysql80-community来取消mysql80-community的默认安装，然后使用yum-config-manager --enable mysql57-community来使能mysql57-community成为yum默认安装版本。

之后使用yum repolist all | grep mysql来查看：
[root@VM_0_13_centos ~]# yum repolist all | grep mysql
mysql-cluster-7.5-community/x86_64 MySQL Cluster 7.5 Community   disabled
mysql-cluster-7.5-community-source MySQL Cluster 7.5 Community - disabled
mysql-cluster-7.6-community/x86_64 MySQL Cluster 7.6 Community   disabled
mysql-cluster-7.6-community-source MySQL Cluster 7.6 Community - disabled
mysql-cluster-8.0-community/x86_64 MySQL Cluster 8.0 Community   disabled
mysql-cluster-8.0-community-source MySQL Cluster 8.0 Community - disabled
mysql-connectors-community/x86_64  MySQL Connectors Community    enabled:    108
mysql-connectors-community-source  MySQL Connectors Community -  disabled
mysql-tools-community/x86_64       MySQL Tools Community         enabled:     90
mysql-tools-community-source       MySQL Tools Community - Sourc disabled
mysql-tools-preview/x86_64         MySQL Tools Preview           disabled
mysql-tools-preview-source         MySQL Tools Preview - Source  disabled
mysql55-community/x86_64           MySQL 5.5 Community Server    disabled
mysql55-community-source           MySQL 5.5 Community Server -  disabled
mysql56-community/x86_64           MySQL 5.6 Community Server    disabled
mysql56-community-source           MySQL 5.6 Community Server -  disabled
mysql57-community/x86_64           MySQL 5.7 Community Server    enabled:    347
mysql57-community-source           MySQL 5.7 Community Server -  disabled
mysql80-community/x86_64           MySQL 8.0 Community Server    disabled
mysql80-community-source           MySQL 8.0 Community Server -  disabled


执行安装命令
[root@VM_0_13_centos ~]# yum install mysql-community-server
[root@VM_0_13_centos tarscpp]# yum -y install  mysql-devel
如上命令完成安装。


启动mysql服务
然后使用如下命令查看状态并启动服务
[root@VM_0_13_centos ~]# systemctl status mysqld.service
[root@VM_0_13_centos ~]# systemctl start mysqld.service
systemctl enable mysqld.service //设置重启自启动


获取临时密码
临时密码存在/var/log/mysqld.log中，使用如下命令查看：
grep "temporary password" /var/log/mysqld.log

登陆mysql
[root@VM_0_13_centos ~]# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.


Web管理系统开发环境安装
以linux环境为例：
以官网提供的nvm脚本安装
执行以下命令：


wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.bashrc
node和带有负载功能的node应用的进程管理器pm2安装

nvm install v8.11.3
npm install -g pm2 --registry=https://registry.npm.taobao.org


TarsFramework下载与安装
下载

yum install git

在/usr/local/ 下，执行：
git clone https://github.com/TarsCloud/TarsFramework.git
cd TarsFramework/
git submodule update --init --recursive

编译
安装如下编译使用的基础软件包：
yum install -y gcc
yum install -y gcc-c++
yum install -y flex
yum install -y bison
yum install -y make


因为此前mysql的安装使用的是yum的安装方式，需要修改配置2个配置文件才可以保证编译通过。两个修改的文件为:
/usr/local/TarsFramework/tarscpp下的CMakeLists.txt
/usr/local/TarsFramework 的CMakeLists.txt
中的：
set(MYSQL_DIR_INC "/usr/local/mysql/include")
set(MYSQL_DIR_LIB "/usr/local/mysql/lib")
修改成为：
set(MYSQL_DIR_INC "/usr/include/mysql")
set(MYSQL_DIR_LIB "/usr/lib64/mysql")
之所以修成成如上路径，原因是：编译不过的时候，发现需要的文件在这2个路径下：
[root@localhost TarsFramework]# find / -name libmysqlclient.a
/usr/lib64/mysql/libmysqlclient.a

[root@localhost TarsFramework]# find / -name mysql.h
/usr/include/mysql/mysql.h


/usr/lib64/mysql

到/usr/local/TarsFramework/build下进行编译：

./build.sh all
需要重新编译：

./build.sh cleanall
./build.sh all

安装
必须（重要！）使用如下默认路径安装
cd /usr/local/
mkdir tars
chown root:root ./tars/
cd /usr/local/TarsFramework/build/
./build.sh install

Mysql配置
准备数据库表项目
查看本地的IP地址：
[root@localhost sql]# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.211.55.7  netmask 255.255.255.0  broadcast 10.211.55.255
        inet6 fdb2:2c26:f4e4:0:d5a2:332c:f355:9ca0  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::d41a:a6de:73c6:70fd  prefixlen 64  scopeid 0x20<link>
        ether 00:1c:42:44:25:99  txqueuelen 1000  (Ethernet)
        RX packets 316693  bytes 429661065 (409.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 155321  bytes 9182998 (8.7 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        
如果是云主机，存在大网和小网的问题，选择配置的IP地址是小网的IP地址。


进入/usr/local/TarsFramework/sql，执行：
sed -i "s/192.168.2.131/10.211.55.7/g" `grep 192.168.2.131 -rl ./*`
sed -i "s/db.tars.com/10.211.55.7/g" `grep db.tars.com -rl ./*`
sed -i "s/10.120.129.226/10.211.55.7/g" `grep 10.120.129.226 -rl ./*`


Mysql用户权限添加
如果您使用的mysql版本是早期的，可以使用tars2015做为密码，建议使用默认的mysql密码tars2015，这样可以避免很多修改脚本的工作量。 

如果使用的新版本的mysql8.0， tars2015过于简单，无法做为你的密码。


因为tars2015 密码过于简单， 需要降低mysql 5.6，5.7的密码检测强度才可以。mysql执行命令：


mysql> set global validate_password_policy=0;
mysql> set global validate_password_length=1;

如果你希望更改自己喜欢的密码也可以，但是后续需要对应进程的启动脚本，需要额外的工作量，我使用了Tars@2019做为密码。


查询mysql安装时候的默认密码：
[root@VM_0_13_centos build]# grep password /var/log/mysqld.log
2019-07-20T15:04:06.683419Z 1 [Note] A temporary password is generated for root@localhost: ***********
2019-07-20T15:29:39.057527Z 3 [Note] Access denied for user 'root'@'localhost' (using password: YES)


请先确定mysql的服务被启动。
systemctl start mysqld.service

使用临时密码登入数据库：
[root@localhost build]# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 5.7.26 MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

修改默认密码：
mysql> set password="Tars@2019";

创建tars用户并授权
mysql> grant all on *.* to 'tars'@'%' identified by 'Tars@2019' with grant option;
Query OK, 0 rows affected, 1 warning (0.00 sec)


mysql> grant all on *.* to 'tars'@'localhost' identified by 'Tars@2019' with grant option;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> flush privileges;


针对 mysql  Ver 8.0.16 for Linux on x86_64 (MySQL Community Server - GPL)版本需要使用如下命令配置：

mysql> set password="Tars@2019";
Query OK, 0 rows affected (0.02 sec)

mysql> create user 'tars'@'%' identified by 'Tars@2019';
Query OK, 0 rows affected (0.02 sec)

mysql> grant all on *.* to 'tars'@'%' with grant option;
Query OK, 0 rows affected (0.00 sec)


同时对代码中的脚本进行替换，在FrameWork目录下执行：
[root@VM_0_13_centos TarsFramework]# sed -i "s/tars2015/Tars@2019/g" `grep tars2015 -rl ./`


创建数据库表项目

进入mysql创建数据库表项目：

[root@localhost sql]# mysql -u root -p

mysql> create database db_tars;
Query OK, 1 row affected (0.01 sec)

mysql> create database tars_stat;
Query OK, 1 row affected (0.00 sec)

mysql> create database tars_property;
Query OK, 1 row affected (0.00 sec)

mysql> create database db_tars_web;
Query OK, 1 row affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| db_tars            |
| db_tars_web        |
| mysql              |
| performance_schema |
| sys                |
| tars_property      |
| tars_stat          |
+--------------------+
8 rows in set (0.00 sec)

mysql> use db_tars；
Database changed

mysql> source db_tars.sql

执行后，会创建3个数据库，分别是db_tars、tars_stat、tars_property、db_tars_web。
其中db_tars是框架运行依赖的核心数据库，里面包括了服务部署信息、服务模版信息、服务配置信息等等；
tars_stat是服务监控数据存储的数据库；
tars_property是服务属性监控数据存储的数据库；

启动Tars框架服务运行
【说明】 如果是云环境部署，如下操作中绑定的IP地址应为小网IP地址， 因为在云主机上大网的IP地址是不可见的。


框架服务的安装分两种：
一种是核心基础服务(必须的)，必须手工部署的。tarsAdminRegistry, tarsregistry, tarsnode, tarsconfig, tarspatch.
一种是普通基础服务(可选的)，可以通过管理平台发布的(和普通服务一样, 这部分详见“发布Tars服务章节”)。tarsstat, tarsproperty,tarsnotify, tarslog，tarsquerystat，tarsqueryproperty


首先准备第一种服务的安装包，在TarsFramework/build目录下输入：
make framework-tar


[root@localhost build]# ls
deploy                QueryStatServer             StatServer
framework.tgz         README.md                   tarscpp

会在当前目录生成framework.tgz 包 这个包包含了 tarsAdminRegistry, tarsregistry, tarsnode, tarsconfig, tarspatch 部署相关的文件




安装框架核心基础服务

cd /usr/local/
mkdir app
cd /usr/local/app/
mkdir tars
chown root:root ./tars/
cd tars/
cp /usr/local/qiuxin/TarsFramework/build/framework.tgz /usr/local/app/tars/



 
 [root@localhost tars]# ls
framework.tgz

[root@localhost tars]#yum install -y tar
[root@localhost tars]# tar -zxvf framework.tgz
 
 修改IP地址：
 [root@localhost tars]# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.211.55.7  netmask 255.255.255.0  broadcast 10.211.55.255
        inet6 fdb2:2c26:f4e4:0:d5a2:332c:f355:9ca0  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::d41a:a6de:73c6:70fd  prefixlen 64  scopeid 0x20<link>
        ether 00:1c:42:44:25:99  txqueuelen 1000  (Ethernet)
        RX packets 317104  bytes 429732843 (409.8 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 155761  bytes 9229552 (8.8 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

在/usr/local/app/tars目录下：
[root@localhost tars]# sed -i "s/192.168.2.131/10.211.55.7/g" `grep 192.168.2.131 -rl ./*`
[root@localhost tars]# sed -i "s/db.tars.com/10.211.55.7/g" `grep db.tars.com -rl ./*`
[root@localhost tars]# sed -i "s/registry.tars.com/10.211.55.7/g" `grep registry.tars.com -rl ./*`
[root@localhost tars]# sed -i "s/web.tars.com/10.211.55.7/g" `grep web.tars.com -rl ./*`
 
 
启动Tars进程
 如果没有修改myql的密码，还是保持tars2015， 则直接执行如下命令，启动tars服务框架：
 在/usr/local/app/tars/目录下，执行脚本，如果执行完，后续所有进程都已经启动。
chmod u+x tars_install.sh
./tars_install.sh

如果此前修改了mysql密码， 则不需要执行tars_install.sh,后续一个修改配置文件，一个一个并拉起服务，是因为修改了mysql的登入密码（见如下，我就是这样操作的，因为我将默认mysql2015修改成了Tars@2019）。

注意：
1）如果几个服务不是部署在同一台服务器上，需要自己手工copy以及处理tars_install.sh脚本


启动tarsregistry
我在此前操作的时候，没有使用mysql2015做为数据库密码，所以需要修改脚本才能保证进程可以连接mysql，从而正常启动。修改数据库的密码，修改语句：dbpass  = Tars@2019
修改方式如下：
进入/usr/local/app/tars/tarsregistry/conf目录，然后执行：

<db>
dbhost= 172.26.0.13
dbname= db_tars
dbuser= tars
dbpass= Tars@2019
dbport= 3306
charset = utf8
dbflag = CLIENT_MULTI_STATEMENTS
</db>


修改成之后，退回到/usr/local/app/tars， 执行：

tarsregistry/util/start.sh


此时可以通过ps命令看到：tarsregistry已经成功连接数据库，并已经启动


同样操作，需修改tarsAdminRegist，tarsconfig两个进程对应的DB密码：
启动tarsAdminRegist
/usr/local/app/tars/tarsAdminRegistry/conf路径下，修改tars.tarsAdminRegistry.config.conf中的数据库密码为新密码 dbpass=Tars@2019。

[root@localhost conf]# vi tars.tarsAdminRegistry.config.conf 
<db>
        dbhost=172.26.0.13
        dbname=db_tars
        dbuser=tars
        dbpass=Tars@2019
        dbport=3306
        charset=utf8
        dbflag=CLIENT_MULTI_STATEMENTS
 </db>

然后：
[root@localhost tars]# pwd
/usr/local/app/tars
执行：
tarsAdminRegistry/util/start.sh
这样tarsAdminRegistry被拉起：


 
启动tarsconfig
进入目录/usr/local/app/tars/tarsconfig/conf， 修改数据库密码：
[root@localhost conf]# vi tars.tarsconfig.config.conf 
<db>
        charset=utf8
        dbhost=172.26.0.13
        dbname=db_tars
        dbpass=Tars@2019
        dbport=3306
        dbuser=tars
    </db>

启动：
[root@localhost tarsconfig]# cd ..
[root@localhost tars]# pwd
/usr/local/app/tars

执行：tarsconfig/util/start.sh
 




启动tarsnode

/usr/local/app/tars/tarsnode/util目录下，直接执行start.sh 



执行完如上所有命令后，可以看到，基础核心进程都已经启动：
[root@VM_0_13_centos util]# ps -ef |grep tars
root     29625     1  0 11:54 pts/0    00:00:01 /usr/local/app/tars/tarsregistry/bin/tarsregistry --config=/usr/local/app/tars/tarsregistry/conf/tars.tarsregistry.config.conf
root     30264     1  0 11:59 pts/0    00:00:00 /usr/local/app/tars/tarsAdminRegistry/bin/tarsAdminRegistry --config=/usr/local/app/tars/tarsAdminRegistry/conf/tars.tarsAdminRegistry.config.conf
root     30710     1  0 12:03 pts/0    00:00:00 /usr/local/app/tars/tarsconfig/bin/tarsconfig --config=/usr/local/app/tars/tarsconfig/conf/tars.tarsconfig.config.conf
root     30966     1  0 12:05 ?        00:00:00 /usr/local/app/tars/tarsnode/bin/tarsnode --locator=tars.tarsregistry.QueryObj@tcp -h 172.26.0.13 -p 17890 --config=/usr/local/app/tars/tarsnode/conf/tars.tarsnode.config.conf
root     30996  2774  0 12:05 pts/0    00:00:00 grep --color=auto tars


安装TarsWeb
地址：https://github.com/TarsCloud/TarsWeb/tree/ca398aaeb60521c380eafa96679892b6996ebaf3

命令： 
[root@localhost qiuxin]# git clone https://github.com/TarsCloud/TarsWeb.git
Cloning into 'TarsWeb'...
remote: Enumerating objects: 5614, done.
remote: Total 5614 (delta 0), reused 0 (delta 0), pack-reused 5614
Receiving objects: 100% (5614/5614), 10.03 MiB | 534.00 KiB/s, done.
Resolving deltas: 100% (3298/3298), done.


下载到/usr/local/qiuxin/路径，TarsWeb：

[root@localhost TarsWeb]# pwd
/usr/local/qiuxin/TarsWeb


/usr/local/qiuxin/TarsWeb路径下，更换本机IP地址：
[root@localhost TarsWeb]# sed -i 's/db.tars.com/172.26.0.13/g' config/webConf.js
[root@localhost TarsWeb]# sed -i 's/registry.tars.com/172.26.0.13/g' config/tars.conf


/usr/local/qiuxin/TarsWeb/config下修改webConf.js中的mysql密码：
dbConf: {
                        host: '172.26.0.13',       // 数据库地址
                        port: '3306',            // 数据库端口
                        user: 'tars',            // 用户名
                        password: 'Tars@2019',       // 密码
                        charset: 'utf8_bin',     // 数据库编码
                        pool: {
                                    max: 10,             // 连接池中最大连接数量
                                    min: 0,              // 连接池中最小连接数量
                                    idle: 10000          // 如果一个线程 10 秒钟内没有被使用过的话，那么就释放线程
                        }
            },


安装软件：

npm install --registry=https://registry.npm.taobao.org
npm run prd


创建日志目录

mkdir -p /data/log/tars




导入db_tars_web.sql 文件

将/usr/local/qiuxin/TarsWeb/sql中的db_tars_web.sql导入mysql

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| db_tars            |
| db_tars_web        |
| mysql              |
| performance_schema |
| sys                |
| tars_property      |
| tars_stat          |
+--------------------+
8 rows in set (0.00 sec)

mysql> use db_tars_web;
Database changed
mysql>
mysql>
mysql>
mysql> source /usr/local/qiuxin/TarsWeb/sql/db_tars_web.sql
Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

mysql>
mysql>
mysql>
mysql> show tables;
+-----------------------+
| Tables_in_db_tars_web |
+-----------------------+
| t_kafka_queue         |
| t_patch_task          |
| t_tars_files          |
+-----------------------+
3 rows in set (0.00 sec)

mysql>
修改完成之后重新启动
 pm2 start 0


然后使用本机的浏览器访问：IP地址 +  3000端口号





非框架核心服务编译和发布
除核心之外的服务，可以通过如下方式编译和发布：
/usr/local/qiuxin/TarsFramework/build路径下：
make tarsstat-tar
make tarsnotify-tar
make tarsproperty-tar
make tarslog-tar
make tarsquerystat-tar
make tarsqueryproperty-tar

生成发布包：tarsstat.tgz ，tarsnotify.tgz，tarsproperty.tgz，tarslog.tgz，tarsquerystat.tgz，tarsqueryproperty.tgz

将如上生成的发布包，传到本地的电脑上，然后使用tarsweb界面（浏览器）进行发布。
Tarsnotify发布
以发布tarsnotify为例，在“服务管理”界面下属的“发布管理”界面进行发布：
 

上传发布包tarsnotify.tgz, 并且选择发布。



tarsstat发布

先使用运维管理中的部署，来进行部署。


其中Obj名字，在TarsFramework/StatServer路径下的StatServer.cpp中查阅,见如下代码：
//增加对象
        addServant<StatImp>( ServerConfig::Application + "." + ServerConfig::ServerName +".StatObj" );

如上页面执行完成之后，会在tarsstat中左侧的界面出现：


然后在发布管理界面，选中发布节点，上传发布文件（.tgz文件）



然后即可发布，正常启动。

按照同样的方式进行发布，即可以看到Tars的所有工作正常工作。







机器重启后，进程拉起
机器重启后，原先的拉起的Tars进程全部消失，可以自己写一个脚本，拉起所有的基础服务：
cd /usr/local/app/tars
//拉起tarsregistry
tarsregistry/util/start.sh
//拉起tarsAdminRegistry
tarsAdminRegistry/util/start.sh
//拉起tarsconfig
tarsconfig/util/start.sh
//拉起tarsnode
tarsnode/util/start.sh
//拉起web
cd /usr/local/qiuxin/TarsWeb/config
npm run prd
pm2 start 0

执行完成之后，使用浏览器，执行： IP Address ：3000






常用诊断方法
Web诊断
pm2 logs 0
pm2 restart 0
pm2 start 0
pm2 stop 0


日志
存在/usr/local/app/tars/app_log/tars/文件夹下











Tars安装出现问题以及解决办法
Mysql不能启动
/var/log/mysql/mysqld.log 中查看不能启动mysql，出现The innodb_system data file 'ibdata1' must be writable 故障，不能启动mysql时候，解决方案：


find / -name ibdata1
 
找到对应目录更改权限~


5.7版本以前是 



chmod -R 777 /usr/local/mysql/data/
 
5.7版本以后是 



chmod -R 777 /var/lib/mysql/

Mysql 8.0 版本不兼容问题
【说明】如果使用mysql 8.0以上版本，会提示出现如下错误。
0|tars-nod | error: 103.7.29.6|admin|TreeController.js:30|[listTree] SequelizeConnectionError: Client does not support authentication protocol requested by server; consider upgrading MySQL client



解决办法：
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '你的密码';
SELECT plugin FROM mysql.user WHERE User = 'root';


模板管理无法显示
“运维管理“-》“模板管理”界面，不能显示， 弹出系统错误对话框。
解决办法：
1）查看/usr/local/qiuxin/TarsFramework/sql路径下的，db_tars.sql文件中的
t_profile_template表项是否配置正确。主要的检查点是：数据库的用户名和密码，我的环境出现这个问题是因为密码没有正确修改，还是此前的tars2015.
（t_profile_template表特别长，可以copy出来采用编辑器查看，也可以使用数据库查看。）
修改完成之后，登入mysql， 然后重新导入db_tars.sql。


2）修改/TarsWeb/app/dao路径下的TemplateDao.js文件，修改后的文件如下：
[root@VM_0_13_centos dao]# cat TemplateDao.js
/**
Tencent is pleased to support the open source community by making Tars available.
*
Copyright (C) 2016THL A29 Limited, a Tencent company. All rights reserved.
*
Licensed under the BSD 3-Clause License (the "License"); you may not use this file except
in compliance with the License. You may obtain a copy of the License at
*
https://opensource.org/licenses/BSD-3-Clause
*
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
*/

const {tProfileTemplate} = require('./db').db_tars;
const Sequelize = require('sequelize');

const TemplateDao = {};

TemplateDao.addTemplate = async (params) => {
return await tProfileTemplate.create({
template_name: params.templateName,
parents_name: params.parentsName,
profile: params.profile,
posttime: params.posttime,
lastuser: params.lastUser
});
};

TemplateDao.deleteTemplate = async (id) => {
return await tProfileTemplate.destroy({
where: {
id: id
}
});
};

TemplateDao.updateTemplate = async (params) => {
return await tProfileTemplate.update({
template_name: params.template_name,
parents_name: params.parents_name,
profile: params.profile,
posttime: params.posttime,
}, {
where: {
id: params.id
}
});
};

TemplateDao.getTemplateById = async (id) => {
return await tProfileTemplate.findOne({
where: {
id
}
});
};

TemplateDao.getTemplateByName = async (templateName) => {
return await tProfileTemplate.findOne({
where: {
template_name: templateName
}
});
};

TemplateDao.getTemplateList = async (templateName, parentsName) => {
const Op=Sequelize.Op;
return await tProfileTemplate.findAll({
where: {
template_name: {
//$like: '%' + templateName + '%'
[Op.like]: `%${templateName}%`
},
parents_name: {
//$like: '%' + parentsName + '%'
[Op.like]: `%${parentsName}%`
}
}
});
};

module.exports = TemplateDao;
[root@VM_0_13_centos dao]#

Mysql无法登陆
当mysql无法登陆时候，请先确定mysql的服务被启动。
systemctl start mysqld.service

SSH配置
如果使用Parallel虚拟机，因为Parallel虚拟机默认不是root用户，需要使用如下方式才可以创建root用户，并配置密码。
[parallels@localhost ~]$ sudo password
[sudo] password for parallels: 
Changing password for user root.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.

配置好root和密码之后，才可以使用ssh root@IP Address来登录

内存不够导致发布失败
内存不够，使用1核1G机器，出现如下问题。
升级云主机到2核4G之后，该故障解决。

客户端不能访问Tars Web网页
问题原因：centOS中的防火墙引起的，关闭防火墙之后问题解决
[root@localhost]# systemctl stop firewalld
[root@localhost]# systemctl mask firewalld
Created symlink from /etc/systemd/system/firewalld.service to /dev/null.


未来有待进行的工作

1.核心进程无法在Web界面显示。
TarsRegistry， TarsAdminRegistry，TarsNode三个进程无法在Web界面中显示。在多机安装的情况下，无法识别有几个TarsRegistry， TarsAdminRegistry， TarsNode, 分别安装在哪几个机器上。

2.设置守护任何时候服务挂了，都可以恢复。


3. web需要刷新后，部署的界面才能跳出来。


4. 在初始化的时候，web界面会显示版本和发布时间异常，因为此时数据库的表项有些内容是空的或者全零字段。




