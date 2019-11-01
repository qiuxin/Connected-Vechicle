pipeline {
    agent any
    stages {
        stage('MountVolume'){
            steps{
                sh 'echo mount to /dev/nvme1n1 to /usr/local/robert'
                sh 'mount -t xfs /dev/nvme1n1 /usr/local/robert'
                
                sh 'echo mount to /dev/nvme2n1 to /usr/local/mysql-5.6.26'
                sh 'mount -t xfs /dev/nvme2n1 /usr/local/mysql-5.6.26'
                
                sh 'echo mount to /dev/nvme3n1 to /usr/local/tars'
                sh 'mount -t xfs /dev/nvme3n1 /usr/local/tars'
                
                sh 'echo mount to /dev/nvme4n1 to /usr/local/app'
                sh 'mount -t xfs /dev/nvme4n1 /usr/local/app'
            }
        }
    }
}