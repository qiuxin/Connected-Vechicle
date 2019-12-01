# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=54.218.53.101
JOB_NAME=TestCompileCode
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/27"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/27/"

cd /var/lib/jenkins/jobs/${JOB_NAME}/builds/27
rm -rf archives
mkdir archives
cp log console.log
cp console.log archives

/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
/usr/local/python3/bin/lftools deploy archives -p '**/*.log' $NEXUS_URL $NEXUS_PATH /var/lib/jenkins/jobs/TestCompileCode/builds/27

echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"

