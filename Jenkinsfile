pipeline {
    agent any
    environment {
        AWS_REGION = 'eu-central-1'
        ECR_REPOSITORY = ''
    }
    stages {
        stage('Setup Environment') {
            steps {
                script {
                    sh 'aws sts get-caller-identity'
                }
            }
        }
        stage('Install Helm on Cluster') {
            steps {
                script {
                    sh """
                    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
                    chmod 700 get_helm.sh
                    ./get_helm.sh

                    helm version
                    """
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                dir('app') {
                    script {
                        ECR_REPOSITORY = sh(
                            script: "aws ecr describe-repositories --repository-names my-app --region ${AWS_REGION} --query 'repositories[0].repositoryUri' --output text",
                            returnStdout: true
                        ).trim()

                        echo "ECR Repository: ${ECR_REPOSITORY}"

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
                script {
                    sh 'kubectl cluster-info'

                    sh """
                    helm upgrade --install my-app helm-chart \
                        --set image.repository=${ECR_REPOSITORY} \
                        --set image.tag=${BUILD_NUMBER}

                    helm list
                    kubectl get pods
                    """
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                script {
                    sh """
                    echo "Checking pod status..."
                    kubectl wait --for=condition=ready pod -l app=my-app --timeout=120s
                    kubectl get pods
                    """

                    def serviceIp = sh(
                        script: "kubectl get svc my-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}'",
                        returnStdout: true
                    ).trim()
                    echo "Service IP: ${serviceIp}"

                    sh """
                    echo "Testing service availability..."
                    curl -I http://${serviceIp}:3000
                    """
                }
            }
        }
        stage('Run Unit Tests') {
            steps {
                sh 'npm test'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube Server') {
                    sh 'sonar-scanner -Dsonar.projectKey=my-app -Dsonar.sources=./src'
                }
            }
        }
    }
    post {
        success {
            emailext(
                subject: "Pipeline Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                <p>Pipeline <b>${env.JOB_NAME}</b> completed successfully!</p>
                <p>Build Number: ${env.BUILD_NUMBER}</p>
                <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: 'ihartsykala24@gmail.com'
            )
        }
        failure {
            emailext(
                subject: "Pipeline Failure: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                <p>Pipeline <b>${env.JOB_NAME}</b> failed!</p>
                <p>Build Number: ${env.BUILD_NUMBER}</p>
                <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: 'ihartsykala24@gmail.com'
            )
        }
    }

}
