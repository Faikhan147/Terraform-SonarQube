#!/bin/bash

set -euo pipefail

# ======= Configuration Variables =======
SONARQUBE_VERSION="10.4.1.88267"
SONARQUBE_HOME="/opt/sonarqube"
SONAR_USER="sonar"
SONAR_GROUP="sonar"
SONAR_PORT=9000

# ======= Installing Java =======
echo "Updating packages and installing OpenJDK 17..."
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk wget unzip

echo "Java version installed:"
java -version

# ======= Remove any existing SonarQube install =======
echo "Removing old SonarQube files if any..."
sudo rm -rf $SONARQUBE_HOME
sudo rm -f /etc/systemd/system/sonarqube.service
sudo systemctl daemon-reload

# ======= Create sonar user and group if they don't exist =======
if ! id -u $SONAR_USER >/dev/null 2>&1; then
    echo "Creating user and group: $SONAR_USER"
    sudo groupadd $SONAR_GROUP
    sudo useradd -m -d $SONARQUBE_HOME -s /bin/bash -g $SONAR_GROUP $SONAR_USER
fi

# Setup sudoers for sonar user (optional, only if needed)
if [ ! -f /etc/sudoers.d/sonar ]; then
    echo "$SONAR_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sonar
    sudo chmod 440 /etc/sudoers.d/sonar
fi

echo "Removing old SonarQube directory if exists..."
sudo rm -rf $SONARQUBE_HOME

# ======= Download & install SonarQube =======
echo "Downloading SonarQube version $SONARQUBE_VERSION..."
cd /opt
sudo wget -q https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip

echo "Unzipping SonarQube..."
sudo unzip -q sonarqube-${SONARQUBE_VERSION}.zip
sudo mv sonarqube-${SONARQUBE_VERSION} sonarqube
sudo rm sonarqube-${SONARQUBE_VERSION}.zip

# Set ownership
sudo chown -R $SONAR_USER:$SONAR_GROUP $SONARQUBE_HOME

# ======= Create systemd service file =======
echo "Creating systemd service file..."
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=forking
User=$SONAR_USER
Group=$SONAR_GROUP
PermissionsStartOnly=true
ExecStart=$SONARQUBE_HOME/bin/linux-x86-64/sonar.sh start
ExecStop=$SONARQUBE_HOME/bin/linux-x86-64/sonar.sh stop
Restart=on-failure
LimitNOFILE=65536
LimitNPROC=4096
Environment=SONAR_JAVA_OPTS="-Xms1g -Xmx2g -XX:+HeapDumpOnOutOfMemoryError"

[Install]
WantedBy=multi-user.target
EOF

# ======= Reload systemd, enable and start SonarQube =======
echo "Reloading systemd and starting SonarQube service..."
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

echo "Waiting 10 seconds to check status..."
sleep 10
sudo systemctl status sonarqube --no-pager

# SSM agent installtion 
sudo apt-get install snapd -y
sudo snap install amazon-ssm-agent --classic
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service
