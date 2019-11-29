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
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}"
#BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}"
#NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/log"
/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
done
