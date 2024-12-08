#!/bin/bash
LOG_FILE="/var/log/jenkins_install.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $LOG_FILE
}

# Updating the system
log "Starting system update..."
sudo yum update -y >> $LOG_FILE 2>&1

# Installing Java 17
log "Installing Java 17..."
sudo amazon-linux-extras enable corretto17 >> $LOG_FILE 2>&1
sudo yum install -y java-17-amazon-corretto >> $LOG_FILE 2>&1

# Verifying Java installation
if java -version >> $LOG_FILE 2>&1; then
    log "Java 17 installed successfully."
else
    log "Error: Java 17 installation failed."
    exit 1
fi

# Adding Jenkins repository
log "Adding Jenkins repository..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo >> $LOG_FILE 2>&1
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key >> $LOG_FILE 2>&1

# Installing Jenkins with --nogpgcheck flag
log "Installing Jenkins with --nogpgcheck..."
sudo yum install -y jenkins --nogpgcheck >> $LOG_FILE 2>&1

# Creating configuration file for Jenkins
log "Configuring Jenkins..."
cat <<EOF | sudo tee /etc/sysconfig/jenkins > /dev/null
JENKINS_PORT=8080
JENKINS_LISTEN_ADDRESS=0.0.0.0
JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
EOF

# Enabling Jenkins to start on boot and starting the service
log "Enabling Jenkins to start on boot and starting the service..."
sudo systemctl daemon-reload >> $LOG_FILE 2>&1
sudo systemctl enable jenkins >> $LOG_FILE 2>&1
sudo systemctl start jenkins >> $LOG_FILE 2>&1

# Verifying Jenkins service is running
if systemctl is-active --quiet jenkins; then
    log "Jenkins is installed and running successfully."
else
    log "Error: Jenkins failed to start. Check logs: /var/log/jenkins/jenkins.log"
    exit 1
fi

# Saving the initial administrator password
log "Retrieving initial administrator password for Jenkins..."
INITIAL_ADMIN_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
if [ -z "$INITIAL_ADMIN_PASSWORD" ]; then
    log "Error: Initial administrator password file not found."
    exit 1
else
    log "Initial administrator password: $INITIAL_ADMIN_PASSWORD"
fi

# Saving the credentials to a file for convenience
CREDENTIALS_FILE="/home/ec2-user/jenkins_credentials.txt"
echo "JENKINS_USER=admin" > $CREDENTIALS_FILE
echo "JENKINS_API_TOKEN=$INITIAL_ADMIN_PASSWORD" >> $CREDENTIALS_FILE
sudo chown ec2-user:ec2-user $CREDENTIALS_FILE
sudo chmod 600 $CREDENTIALS_FILE
log "Credentials saved in $CREDENTIALS_FILE."

# Completion message
log "Deployment completed. Jenkins is accessible on port 8080."
