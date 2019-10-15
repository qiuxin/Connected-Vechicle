# Connected-Vechicle
Akraino Connected Vehicle Blueprint


## Architecture
Three Servers:
Server A :    TarsFramework + Jenkis Master
Server B :    TarsNodes + Jenkis Slave
Server c :    TarsNodes + Jenkis Slave


## Hardware Requirements 
Baremetal is preferred.  Some issues in Virtual Machine environment.

## Setup CI Environment 

### Setup Jenkins Flowchart
Step 1:  Setup Jenkins in Master Node and add the salve nodes in the Jenkis master's configuration.
Step 2:  Setup Jenkins in Slave Node.

### Setup Jenkins in Master Node
Jenkins is a Java application, so the first step is to install Java. Run the following command to install the OpenJDK 8 package:
```
sudo yum install java-1.8.0-openjdk-devel
```

The next step is to enable the Jenkins repository. To do that, import the GPG key using the following curl command:
```
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
```

And add the repository to your system with:
```
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
```




```
git clone "https://gerrit.akraino.org/r/ci-management"
cd ci-management
git submodule update --init --recursive
```




### Setup Jenkins in Slave Node
