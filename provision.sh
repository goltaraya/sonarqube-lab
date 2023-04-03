#!/bin/bash
useradd sonar
sudo yum -y install yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin wget unzip java-11-openjdk-devel > /dev/null/ 2>&1
sudo systemctl enable docker
sudo systemctl start docker
wget -O /tmp/sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip 
unzip /tmp/sonarqube.zip -d /opt/
sudo rm /tmp/sonarqube.zip
sudo mv /opt/sonarqube-9.9.0.65466 /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube
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
User=sonar
Group=sonar
Restart=always
[Install]
WantedBy=multi-user.target
EOT
service sonar start