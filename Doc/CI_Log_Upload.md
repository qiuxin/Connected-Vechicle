# CI_Log_Upload
The CI logs are required to been uploaded to NEXUS repo. This article depicts the detail operations step by step.

# Table of Contents
> * [1.Software Reuqirement](#main-chapter-1)
> * [2.Install Nginx](#main-chapter-2)
> * [3.Install Python3.7](#main-chapter-3)
> * [4.Install lftools](#main-chapter-4)
> * [5.Write upload script](#main-chapter-5)
> * [6.Write Account Config Script](#main-chapter-6)
> * [7.Run Jenkins as root](#main-chapter-7)
> * [8.Jenkins Upload Log Script](#main-chapter-8)
> * [9.Run the script and upload log](#main-chapter-9)
> * [10.The script running on the machine](#main-chapter-10)



# Note Well
Offical guidence:  https://wiki.akraino.org/display/AK/How+to%3A+Push+Logs+to+Nexus

More details for lftools:
https://docs.releng.linuxfoundation.org/projects/lftools/en/latest/commands/deploy.html#id1

A NEXUS account is required to upload the logs. Apply the NEXUS account via the following link:
https://jira.linuxfoundation.org/servicedesk/customer/portals


# 1. <a id="main-chapter-1"></a>Software Reuqirement
The software itemized below should be installed prior to upload the log.
- Nginx
- Python 3.7 (Note Well: To make lftools work, Python 3.6+ is a must)
- lftools



# 2. <a id="main-chapter-2"></a> Install Nginx 
For X86 platform
```
sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
sudo yum install -y nginx
sudo systemctl start nginx.service
sudo systemctl enable nginx.service
```


For Arm platform
```
yum -y install pcre-devel
yum -y install openssl-devel
mkdir /data
cd /data/
wget  http://nginx.org/download/nginx-1.16.0.tar.gz
tar -xvzf nginx-1.16.0.tar.gz
cd /data/nginx-1.16.0
./configure --prefix=/usr/local/nginx --with-http_slice_module --with-http_mp4_module --with-http_ssl_module --with-http_sub_module --with-http_gzip_static_module --with-http_stub_status_module
make
make install
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
//Start Nginx
nginx
//Check the version
nginx -V
```

Double check whether nginx works well.
```
# hostname
ip-172-31-11-179.us-west-2.compute.internal
# curl ip-172-31-11-179.us-west-2.compute.internal
```
or
```
//Curl Local IP Address directly
curl 34.216.198.49
```

More info about Nginx install ,refer to https://blog.csdn.net/stefan1240/article/details/92764248


# 3. <a id="main-chapter-3"></a> Install Python3.7

Install Lib
```
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
```

Install pip 
``` 
yum -y install epel-release 
yum -y install python-pip
```

Install wget
``` 
yum -y install wget
``` 

Install Python
``` 
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
tar -zxvf Python-3.7.0.tgz
./configure prefix=/usr/local/python3 
make && make install
ln -s /usr/local/python3/bin/python3.7 /usr/bin/python3.7 
ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip3.7
//check wheather the installation successfully
python -V
``` 

More information, pls refer to the following link：
https://segmentfault.com/a/1190000015628625

# 4. <a id="main-chapter-4"></a> Install lftools
/usr/bin/pip3.7 install lftools


# 5. <a id="main-chapter-5"></a> Write upload script
Find an abritbity path and create a file, the name and content of the file refer to the following link:
https://github.com/qiuxin/Connected-Vechicle/blob/master/TestCompileCode_Single_push_logs.sh

# 6. <a id="main-chapter-6"></a> Write Account Config Script
```
touch ~/.netrc
vim ~/.netrc
```

The content of ~/.netrc 
```
[root@ip-172-31-11-179 robert]# cat ~/.netrc
machine nexus.akraino.org
login connectedVehicle
password <password>  
```


# 7. <a id="main-chapter-7"></a> Run Jenkins as root

Open Jenkins config file.
```
vim /etc/sysconfig/jenkins
```

Modify JENKINS_USER from "jenkins" to "root".
```
#JENKINS_USER="jenkins"
JENKINS_USER="root"
```

Modify the folder access right.
```
chown -R root:root /var/lib/jenkins
chown -R root:root /var/cache/jenkins
chown -R root:root /var/log/jenkins
```

Double check whether the modification takes effects.
```
# reboot Jenkins
service jenkins restart

# check the usr to which Jenkins belong 
ps -ef | grep jenkins

# modification takes effects if the usr is "root" instead of "jenkins"
[root@ip-172-31-4-217 sysconfig]# ps -ef | grep jenkins
root      5332     1  9 01:29 ?        00:01:49 /etc/alternatives/java -Dcom.sun.akuma.Daemon=daemonized -Djava.awt.headless=true -DJENKINS_HOME=/var/lib/jenkins -jar /usr/lib/jenkins/jenkins.war --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war --daemon --httpPort=8080 --debug=5 --handlerCountMax=100 --handlerCountMaxIdle=20
root      5557  5247  0 01:48 pts/0    00:00:00 grep --color=auto jenkins
```


# 8. <a id="main-chapter-8"></a> Jenkins Upload Log Script
To upload the log to NEXUS repo, a script is required to run in Jenkis Job. 

A script I used is shown below for your reference. 
```
# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=35.165.250.56(This is the public IP address of the Jenkins host)
JOB_NAME=TestCompileCode
FOLDER_NAME=connectedVehicle
BUILD_NUMBER=${BUILD_ID}

BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}"
NEXUS_PATH="${SILO}/job/${FOLDER_NAME}/${JOB_NAME}/${BUILD_NUMBER}/"

cd /var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}
rm -rf archives
mkdir archives
cp log console.log
cp console.log archives

cp log console-timestamp.log
cp console-timestamp.log archives

/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Job $JOB_NAME Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"

/usr/local/python3/bin/lftools deploy archives -p '**/*.log' $NEXUS_URL $NEXUS_PATH /var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}
echo "Job $JOB_NAME archives uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
```


# 9. <a id="main-chapter-9"></a> Run the script and upload log
Create a Jenkins freescale job in the Jenkins website. 
![image](https://github.com/qiuxin/Connected-Vechicle/blob/master/picture/Jenkins_FreeStyle%20_Job.png)

Put the scripts in the jenkins jobs and triger the script to run.   
![image](https://github.com/qiuxin/Connected-Vechicle/blob/master/picture/Script_In_Jenkins.png)

Check NEXUS repo, the log will be uploaded there.
https://nexus.akraino.org/content/sites/logs/tencent/job/


# 10. <a id="main-chapter-10"></a> The script running on the machine

If you want to run the upload script on your command line instead of Jenkins.

The following script for your reference
```
# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=35.165.250.56
JOB_NAME=TestCompileCode
FOLDER_NAME=connectedVehicle
BUILD_NUMBER=3

BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}"
NEXUS_PATH="${SILO}/job/${FOLDER_NAME}/${JOB_NAME}/${BUILD_NUMBER}/"

cd /var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}
rm -rf archives
mkdir archives
cp log console.log
cp console.log archives

cp log console-timestamp.log
cp console-timestamp.log archives

/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Job $JOB_NAME Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"

/usr/local/python3/bin/lftools deploy archives -p '**/*.log' $NEXUS_URL $NEXUS_PATH /var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}
echo "Job $JOB_NAME archives uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
[centos@ip-172-31-4-217 robert]$

```