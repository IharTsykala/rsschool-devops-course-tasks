pipeline {
    agent any
    environment {
        AWS_REGION = 'eu-central-1'
        ECR_REPOSITORY = ''
    }
    stages {
        stage('Setup ECR Repository') {
            steps {
                script {
                    ECR_REPOSITORY = sh(
                        script: "aws ecr describe-repositories --repository-names my-app --region ${AWS_REGION} --query 'repositories[0].repositoryUri' --output text",
                        returnStdout: true
                    ).trim()
                    echo "ECR Repository: ${ECR_REPOSITORY}"
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                dir('app') {
                    script {
                        sh """
                        docker build -t ${ECR_REPOSITORY}:${BUILD_NUMBER} .
                        docker push ${ECR_REPOSITORY}:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                helm upgrade --install my-app helm-chart --set image.repository=${ECR_REPOSITORY} --set image.tag=${BUILD_NUMBER}
                """
            }
        }
    }
}
