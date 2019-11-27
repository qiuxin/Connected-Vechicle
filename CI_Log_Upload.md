# CI_Log_Upload
The CI logs are required to been uploaded to NEXUS repo. This article depicts the detail operations step by step.

# Table of Contents
> * [1.Software Reuqirement](#main-chapter-1)
> * [2.Install Nginx](#main-chapter-2)
> * [3.Setup CI Environment](#main-chapter-3)
>   * [3.1 Setup Jenkins Flowchart](#main-chapter-3.1)
>   * [3.2 Install Jenkins on Master](#main-chapter-3.2)
>   * [3.3 Clone Akraino CI Repo on Master](#main-chapter-3.3)
>   * [3.4 Install Plugins](#main-chapter-3.4)
>   * [3.5 Creat folder and Yaml file](#main-chapter-3.5)
> * [4.Go环境安装](#main-chapter-4)
> * [5.TAR GO安装](#main-chapter-5)
> * [6.后端服务代码下载和编译](#main-chapter-6)
> * [7.后端服务通过Tars部署](#main-chapter-7)


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
curl -
```