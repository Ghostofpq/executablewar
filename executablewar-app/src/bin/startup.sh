#!/bin/bash
# ----------
# Standard application runner for Adaptors. Do not edit. 
# ----------

echo "Starting ${module.name} Adaptor (version ${project.version})."
echo

LOG_DIR="../logs"
if [ ! -d $LOG_DIR ];
then	  
  mkdir -p $LOG_DIR		
fi

JMX_MANAGEMENT=""
JMX_MANAGEMENT=$JMX_MANAGEMENT" -Dcom.sun.management.jmxremote "
JMX_MANAGEMENT=$JMX_MANAGEMENT" -Dcom.sun.management.jmxremote.port=${module.jmx.port}"
JMX_MANAGEMENT=$JMX_MANAGEMENT" -Dcom.sun.management.jmxremote.authenticate=false"
JMX_MANAGEMENT=$JMX_MANAGEMENT" -Dcom.sun.management.jmxremote.ssl=false"

VERBOSE=""
VERBOSE=$VERBOSE" -verbose:gc"
VERBOSE=$VERBOSE" -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
VERBOSE=$VERBOSE" -Xloggc:$LOG_DIR/GC_`date '+%y%m%d_%H%M%S'`.log"

JAVA_OPTS=""
JAVA_OPTS=$JAVA_OPTS" -server -Dfile.encoding=UTF-8"
JAVA_OPTS=$JAVA_OPTS" -Xms256M -Xmx1024M"
JAVA_OPTS=$JAVA_OPTS" -XX:MaxPermSize=256M -XX:PermSize=128M"
JAVA_OPTS=$JAVA_OPTS" -XX:+AggressiveOpts"
JAVA_OPTS=$JAVA_OPTS" -XX:NewRatio=4 -XX:+UseParallelGC"
JAVA_OPTS=$JAVA_OPTS" -XX:+CMSClassUnloadingEnabled"
JAVA_OPTS=$JAVA_OPTS" -Dsun.rmi.dgc.client.gcInterval=72000000"
JAVA_OPTS=$JAVA_OPTS" -Dsun.rmi.dgc.server.gcInterval=72000000"
JAVA_OPTS=$JAVA_OPTS" -Djava.net.preferIPv4Stack=true"
JAVA_OPTS=$JAVA_OPTS" $JMX_MANAGEMENT"
JAVA_OPTS=$JAVA_OPTS" $VERBOSE"

LOGS_FOLDER=../logs
LOGS_ARCHIVE_FOLDER=../logs/archives
JAVA_OPTS=$JAVA_OPTS" -DLOGS_FOLDER=$LOGS_FOLDER"
JAVA_OPTS=$JAVA_OPTS" -DLOGS_ARCHIVE_FOLDER=$LOGS_ARCHIVE_FOLDER"

env | sed "s/=/\n/" | sed "s/\//\\\\\//g" | xargs -n 2 -d "\n" ./replace.sh ../conf/application.properties
env | sed "s/=/\n/" | sed "s/\//\\\\\//g" | xargs -n 2 -d "\n" ./replace.sh ../conf/META-INF/spring/module-context.xml

java $JAVA_OPTS% -jar ../lib/jetty-runner.jar --port ${module.http.port} ../lib/${module.name}.war --classes ../conf
