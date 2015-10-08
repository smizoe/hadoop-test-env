#!/bin/bash
service mysql start
service ssh start
su -l hdfs -c  'JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre /opt/hadoop/sbin/hadoop-daemon.sh start namenode'
su -l hdfs -c  'JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre /opt/hadoop/sbin/hadoop-daemon.sh start datanode'
su -l yarn -c  'JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre /opt/hadoop/sbin/yarn-daemon.sh start resourcemanager'
su -l yarn -c  'JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre /opt/hadoop/sbin/yarn-daemon.sh start nodemanager'
su -l hbase -c 'JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre /opt/hbase/bin/start-hbase.sh'
