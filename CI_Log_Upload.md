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
Refer to the following link：
https://www.cnblogs.com/songxingzhu/p/8568432.html


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


# 6. <a id="main-chapter-6"></a> Run the script and upload log
Run the script.

# 7. <a id="main-chapter-6"></a> Appendix

## 7.1 <a id="main-chapter-7.1"></a> The script for CompileTarsCode job upload.
https://github.com/qiuxin/Connected-Vechicle/blob/master/TestCompileCode_Single_push_logs.sh

https://github.com/qiuxin/Connected-Vechicle/blob/master/TestCompileCode_loop_push_logs.sh


## 7.2 <a id="main-chapter-7.3"></a> The script for TestConnectVehicleService job upload 
https://github.com/qiuxin/Connected-Vechicle/blob/master/TestConnectVehicleService_Single_push_logs.sh

https://github.com/qiuxin/Connected-Vechicle/blob/master/TestConnectVehicleService_loop_push_logs.sh

