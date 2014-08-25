@rem ----------
@rem Standard application runner for Adaptors. Do not edit. 
@rem ----------

@echo off

echo Starting ${project.artifactId} Adaptor (version ${project.version}).

set GC_LOG_DIRECTORY="%CD%"\..\logs
mkdir %GC_LOG_DIRECTORY%

set JMX_MANAGEMENT=-Dcom.sun.management.jmxremote
set JMX_MANAGEMENT=%JMX_MANAGEMENT% -Dcom.sun.management.jmxremote.port=${module.jmx.port}
set JMX_MANAGEMENT=%JMX_MANAGEMENT% -Dcom.sun.management.jmxremote.authenticate=false
set JMX_MANAGEMENT=%JMX_MANAGEMENT% -Dcom.sun.management.jmxremote.ssl=false

set DATETIME=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
set VERBOSE=-verbose:gc
set VERBOSE=%VERBOSE% -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps
set VERBOSE=%VERBOSE% -Xloggc:%GC_LOG_DIRECTORY%/GC_%DATETIME: =0%.log

set JAVA_OPTS=-server -Dfile.encoding=UTF-8
set JAVA_OPTS=%JAVA_OPTS% -Xms256M -Xmx512M
@rem set JAVA_OPTS=%JAVA_OPTS% -XX:MaxPermSize=256M -XX:PermSize=128M
set JAVA_OPTS=%JAVA_OPTS% -XX:+AggressiveOpts
set JAVA_OPTS=%JAVA_OPTS% -XX:NewRatio=4 -XX:+UseParallelGC
set JAVA_OPTS=%JAVA_OPTS% -XX:+CMSClassUnloadingEnabled
set JAVA_OPTS=%JAVA_OPTS% -Dsun.rmi.dgc.client.gcInterval=72000000
set JAVA_OPTS=%JAVA_OPTS% -Dsun.rmi.dgc.server.gcInterval=72000000
set JAVA_OPTS=%JAVA_OPTS% -Djava.net.preferIPv4Stack=true
set JAVA_OPTS=%JAVA_OPTS% %JMX_MANAGEMENT%
set JAVA_OPTS=%JAVA_OPTS% %VERBOSE%

set LOGS_FOLDER=../logs
set LOGS_ARCHIVE_FOLDER=../logs/archives
set JAVA_OPTS=%JAVA_OPTS% -DLOGS_FOLDER="%LOGS_FOLDER%"
set JAVA_OPTS=%JAVA_OPTS% -DLOGS_ARCHIVE_FOLDER="%LOGS_ARCHIVE_FOLDER%"

java %JAVA_OPTS% -jar ../lib/jetty-runner.jar --port ${module.port} ../lib/${module.name}.war