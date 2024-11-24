resource "aws_instance" "jenkins_instance" {
  ami             = var.jenkins_ami
  instance_type   = "t3.small"
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.jenkins_security_group.id]

  user_data = <<-EOF
      #!/bin/bash
      sudo yum update -y
      sudo yum install -y java-11-openjdk wget git
      wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
      rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
      sudo yum install -y jenkins
      sudo systemctl start jenkins
      sudo systemctl enable jenkins

      wget http://localhost:8080/jnlpJars/jenkins-cli.jar -P /usr/lib/jenkins/

      sleep 30

      ADMIN_PASSWORD=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
      JENKINS_CLI="http://localhost:8080"
      echo "jenkins.model.Jenkins.instance.securityRealm.createAccount('admin', 'admin')" | \
        java -jar /usr/lib/jenkins/jenkins-cli.jar -auth admin:$ADMIN_PASSWORD -s $JENKINS_CLI groovy =

      TOKEN_OUTPUT=$(java -jar /usr/lib/jenkins/jenkins-cli.jar -auth admin:admin -s $JENKINS_CLI create-api-token --username admin --token-name "github-token")
      TOKEN=$(echo $TOKEN_OUTPUT | grep -oP '(?<=token":")[^"]+')

      cat <<EOL > pipeline.xml
<flow-definition plugin="workflow-job@2.40">
  <actions/>
  <description>Pipeline for task-6</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.90">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.11.3">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/rsschool-devops-course-tasks.git</url>
          <credentialsId>github-credentials</credentialsId>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/task-6/application-deployment-via-jenkins-pipeline</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOL
      java -jar /usr/lib/jenkins/jenkins-cli.jar -auth admin:admin -s $JENKINS_CLI create-job task-6-pipeline < pipeline.xml

      echo "JENKINS_USER=admin" > /home/ec2-user/jenkins_credentials.txt
      echo "JENKINS_API_TOKEN=$TOKEN" >> /home/ec2-user/jenkins_credentials.txt
  EOF

  tags = {
    Name = "Jenkins Server"
  }
}
