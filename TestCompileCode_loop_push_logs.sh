# Deploying logs to LF Nexus log server ##
# BUILD_NUMBER and JOB_NAME should be set by Jenkins

NEXUS_URL=https://nexus.akraino.org
SILO=tencent
JENKINS_HOSTNAME=54.218.53.101
JOB_NAME=TestCompileCode
for BUILD_NUMBER in {4..28}
do
BUILD_URL="${JENKINS_HOSTNAME}/var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}"
NEXUS_PATH="${SILO}/job/${JOB_NAME}/${BUILD_NUMBER}/"

cd /var/lib/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}
rm -rf archives
mkdir archives
cp log console.log
cp console.log archives

/usr/local/python3/bin/lftools deploy logs $NEXUS_URL $NEXUS_PATH $BUILD_URL
echo "Logs uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"

/usr/local/python3/bin/lftools deploy archives -p '**/*.log' $NEXUS_URL $NEXUS_PATH /var/lib/jenkins/jobs/TestCompileCode/builds/${BUILD_NUMBER}
echo "Archives uploaded to $NEXUS_URL/content/sites/logs/$NEXUS_PATH"
done
