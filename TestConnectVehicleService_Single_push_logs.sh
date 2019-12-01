# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=54.218.53.101
JOB_NAME=TestConnectVehicleService
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/1"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/1/"

cd /var/lib/jenkins/jobs/${JOB_NAME}/builds/1
rm -rf archives
mkdir archives
cp log console.log
cp console.log archives

/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Job $JOB_NAME Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"

/usr/local/python3/bin/lftools deploy archives -p '**/*.log' $NEXUS_URL $NEXUS_PATH /var/lib/jenkins/jobs/TestConnectVehicleService/builds/1
echo "Job $JOB_NAME archives uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
