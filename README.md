# Connected-Vechicle
Akraino Connected Vehicle Blueprint


## Architecture
Three Servers:
- Server A :    TarsFramework + Jenkis Master
- Server B :    TarsNodes + Jenkis Slave
- Server c :    TarsNodes + Jenkis Slave


## Hardware Requirements 
Baremetal is preferred.  Some issues in Virtual Machine environment.

## Setup CI Environment 

### Setup Jenkins Flowchart
Step 1:  Setup Jenkins in Master Node and add the salve nodes in the Jenkis master's configuration.
Step 2:  Setup Jenkins in Slave Node.

### Setup Jenkins in Master Node
Jenkins is a Java application, so the first step is to install Java. Run the following command to install the OpenJDK 8 package:
```
sudo yum install -y java-1.8.0-openjdk-devel
```

The next step is to enable the Jenkins repository. To do that, import the GPG key using the following curl command:
```
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
```

And add the repository to your system with:
```
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
```

Once the repository is enabled, install the latest stable version of Jenkins by typing:
```
sudo yum install -y jenkins
```

After the installation process is completed, start the Jenkins service with:
```
sudo systemctl start jenkins
```

To check whether it started successfully run:
```
systemctl status jenkins
```

You should see something similar to this:
```
# systemctl status jenkins
* jenkins.service - LSB: Jenkins Automation Server
   Loaded: loaded (/etc/rc.d/init.d/jenkins; bad; vendor preset: disabled)
   Active: active (running) since Tue 2019-10-15 11:16:26 CST; 1min 15s ago
     Docs: man:systemd-sysv-generator(8)
  Process: 489 ExecStart=/etc/rc.d/init.d/jenkins start (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/jenkins.service
           `-510 /etc/alternatives/java -Dcom.sun.akuma.Daemon=daemonized -Djava.awt.headless=true -DJENKINS_HOME=/var/lib/jenkins -jar /usr/l...

Oct 15 11:16:25 VM_0_4_centos systemd[1]: Starting LSB: Jenkins Automation Server...
Oct 15 11:16:26 VM_0_4_centos runuser[491]: pam_unix(runuser:session): session opened for user jenkins by (uid=0)
Oct 15 11:16:26 VM_0_4_centos runuser[491]: pam_unix(runuser:session): session closed for user jenkins
Oct 15 11:16:26 VM_0_4_centos jenkins[489]: Starting Jenkins [  OK  ]
Oct 15 11:16:26 VM_0_4_centos systemd[1]: Started LSB: Jenkins Automation Server.
```

Finally enable the Jenkins service to start on system boot.
```
sudo systemctl enable jenkins
```
output
```
# sudo systemctl enable jenkins
jenkins.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig jenkins on
```

Adjust the Firewall
If you are installing Jenkins on a remote CentOS server that is protected by a firewall you need to port 8080.

Use the following commands to open the necessary port:
```
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
```


Setting Up Jenkins
To set up your new Jenkins installation, open your browser and type your domain or IP address followed by port 8080:
```
http://your_ip_or_domain:8080
```




```
git clone "https://gerrit.akraino.org/r/ci-management"
cd ci-management
git submodule update --init --recursive
```




### Setup Jenkins in Slave Node
