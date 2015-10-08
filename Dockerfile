FROM ubuntu:14.04
RUN apt-get -y install software-properties-common openssh-server
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get -y install ansible oracle-java7-installer mysql-server libmysql-java
RUN service mysql start && echo "CREATE DATABASE metastore; CREATE USER metastore IDENTIFIED BY 'metastore'; GRANT ALL PRIVILEGES ON metastore.* TO metastore;" | mysql -u root
RUN useradd -d /home/ansible -s /bin/bash ansible
RUN echo 'ansible    ALL=NOPASSWD: ALL' >> /etc/sudoers
WORKDIR /home/ansible
ADD ./provisioning/roles /home/ansible/roles
ADD ./provisioning/setup.yml /home/ansible/
RUN chown ansible:ansible /home/ansible && chmod 700 /home/ansible
USER ansible
RUN ansible-playbook -i '127.0.0.1,' -c local setup.yml
ENV JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre HADOOP_HOME=/opt/hadoop
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre' | sudo tee /etc/profile.d/java_home.sh
RUN echo 'export PATH=${PATH}:/opt/hadoop/bin:/opt/hive/bin:/opt/hbase/bin' | sudo tee /etc/profile.d/hadoop_path.sh
RUN sudo su -l hbase -c 'cat /opt/hbase/.ssh/id_rsa.pub >> /opt/hbase/.ssh/authorized_keys'
RUN sudo service ssh start && sudo su -l hbase -c "ssh -o BatchMode=yes -o StrictHostKeyChecking=no localhost 'exit'"
RUN sudo su -l hdfs -c  'JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre /opt/hadoop/bin/hdfs namenode -format'
RUN sudo service mysql start && /opt/hive/bin/schematool -initSchema -dbType=mysql
ADD ./start-hadoop.sh /home/ansible/
ENTRYPOINT sudo /home/ansible/start-hadoop.sh && bash
