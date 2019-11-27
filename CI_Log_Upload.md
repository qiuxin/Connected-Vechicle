# CI_Log_Upload
The CI logs are required to been uploaded to NEXUS repo. This article depicts the detail operations step by step.

# Table of Contents
> * [1.Software Reuqirement](#main-chapter-1)
> * [2.Install Nginx](#main-chapter-2)
> * [3.Install Python3.7](#main-chapter-3)
> * [4.Install lftools](#main-chapter-4)
> * [5.Write upload script](#main-chapter-5)
> * [6.Write Account Config Script](#main-chapter-6)
> * [7.Run the script and upload log](#main-chapter-7)
> * [8.Appendix](#main-chapter-8)

Note Well:
You should apply a NEXUS account prior to upload the logs. Apply the NEXUS account via the following link:
https://jira.linuxfoundation.org/servicedesk/customer/portals

Offical guidence:  https://wiki.akraino.org/display/AK/How+to%3A+Push+Logs+to+Nexus

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
Refer to the following link：
https://www.cnblogs.com/songxingzhu/p/8568432.html


# 4. <a id="main-chapter-4"></a> Install lftools
/usr/bin/pip3.7 install lftools



# 5. <a id="main-chapter-5"></a> Write upload script
```
cd /usr/local/robert/
touch push_logs.sh
vim push_logs.sh
```
The context of push_logs are shown below:
```
[root@ip-172-31-11-179 robert]# cat push_logs.sh
# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=34.216.198.49
JOB_NAME=CompileMysql-TarsNode
BUILD_NUMBER=0

BUILD_URL="${JENKINS_HOSTNAME}/job/${JOB_NAME}/${BUILD_NUMBER}/"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}"

#lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
```

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


# 6. <a id="main-chapter-6"></a> Run the script and upload log
```
cd /usr/local/robert/
./push_logs.sh
```

# 7. <a id="main-chapter-6"></a> Appendix

## 7.1 <a id="main-chapter-7.1"></a> The script for CompileTarsCode job upload.

```
[root@ip-172-31-4-217 robert]# cat push_logs.sh

# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=54.218.53.101
JOB_NAME=CompileTarsCode
BUILD_NUMBER=2
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/log"
/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
```

The script for CompileMysql-TarsNode job upload.
```
[root@ip-172-31-4-217 robert]# cat push_logs.sh

# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=54.218.53.101
JOB_NAME=CompileMysql-TarsNode
BUILD_NUMBER=1
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/log"
/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
[root@ip-172-31-4-217 robert]#
```

## 7.2 <a id="main-chapter-7.2"></a> The script for TestConnectVehicleService job upload
Run one time per 2 hours.
```
[root@ip-172-31-4-217 robert]# cat push_logs.sh

# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=54.218.53.101
JOB_NAME=TestConnectVehicleService
#BUILD_NUMBER=3
#BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log"
#NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/log"
#/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
#echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
for BUILD_NUMBER in {4..200}
do
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/log"
/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
done
```


## 7.3 <a id="main-chapter-7.3"></a> The script for TestCompileCode job upload 

Run one time per 24 hours.
```
[root@ip-172-31-4-217 robert]# cat push_logs.sh

# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=54.218.53.101
JOB_NAME=TestCompileCode
#BUILD_NUMBER=3
#BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log"
#NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/log"
#/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
#echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
for BUILD_NUMBER in {4..28}
do
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/log"
/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
done
```