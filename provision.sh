#!/bin/bash
useradd sonar
sudo yum install -y wget unzip curl

# Installing Java OpenJDK 17
wget https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
tar xvf openjdk-17.0.2_linux-x64_bin.tar.gz
sudo mv jdk-17.0.2/ /opt/jdk-17/
cat << EOT >> ~/.bashrc
JAVA_HOME=/opt/jdk-17/
PATH=$PATH:$JAVA_HOME/bin
EOT
source ~/.bashrc

# Installing PostgreSQL
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum -y update > /dev/null 2>&1
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install postgresql15-server
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
sudo systemctl enable --now postgresql-15

# Installing SonarQube
wget -O /tmp/sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip 
unzip /tmp/sonarqube.zip -d /opt/
sudo rm /tmp/sonarqube.zip
sudo mv /opt/sonarqube-9.9.0.65466 /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube

# Creating Sonar service
touch /etc/systemd/system/sonar.service
echo > /etc/systemd/system/sonar.service
cat << EOT >> /etc/systemd/system/sonar.service
[Unit]
Description=Sonarqube Service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-86x-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-86x-64/sonar.sh stop
User=root
Group=root
Restart=always
[Install]
WantedBy=multi-user.target
EOT

# Starting Sonar Service
sudo systemctl daemon-reload
sudo systemctl start sonar
sudo systemctl enable sonar
