pipeline {
    agent any
    environment {
        AWS_REGION = 'eu-central-1'
        ECR_REPOSITORY = ''
        KUBECONFIG_FILE = './kubeconfig'
    }
    stages {
        stage('Setup Environment') {
            steps {
                script {
                    echo 'Setting up AWS environment...'
                    sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Verify Kubernetes Access') {
                    steps {
                        script {
                            sh 'kubectl cluster-info'
                            sh 'kubectl get pods -A'
                        }
                    }
        }

        stage('Install Helm on Kubernetes Cluster') {
            steps {
                script {
                    echo 'Installing Helm...'
                    sh """
                    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
                    chmod +x get_helm.sh
                    ./get_helm.sh

                    helm version
                    """
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                dir('app') {
                    script {
                        echo 'Building Docker image...'
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

        stage('Deploy to Kubernetes Cluster') {
            steps {
                script {
                    echo 'Deploying to Kubernetes using Helm...'

                    // Use kubeconfig for Kubernetes connection
                    writeFile file: KUBECONFIG_FILE, text: readFileFromWorkspace('kubeconfig')
                    withEnv(["KUBECONFIG=${KUBECONFIG_FILE}"]) {
                        sh 'kubectl cluster-info'

                        sh """
                        helm upgrade --install my-app helm-chart \
                            --set image.repository=${ECR_REPOSITORY} \
                            --set image.tag=${BUILD_NUMBER} \
                            --set replicaCount=2

                        helm list
                        kubectl get pods
                        """
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo 'Verifying application deployment...'

                    // Check pod readiness
                    sh """
                    echo "Checking pod status..."
                    kubectl wait --for=condition=ready pod -l app=my-app --timeout=120s
                    kubectl get pods
                    """

                    // Fetch LoadBalancer IP
                    def serviceIp = sh(
                        script: "kubectl get svc my-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}'",
                        returnStdout: true
                    ).trim()
                    echo "Service IP: ${serviceIp}"

                    // Test service availability
                    sh """
                    echo "Testing service availability..."
                    curl -I http://${serviceIp}:3000
                    """
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    echo 'Running unit tests...'
                    sh 'npm test'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube Server') {
                    echo 'Running SonarQube analysis...'
                    sh 'sonar-scanner -Dsonar.projectKey=my-app -Dsonar.sources=./src'
                }
            }
        }
    }
    post {
        success {
            script {
                echo 'Pipeline succeeded. Sending notification...'
            }
            emailext(
                subject: "Pipeline Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                <p>Pipeline <b>${env.JOB_NAME}</b> completed successfully!</p>
                <p>Build Number: ${env.BUILD_NUMBER}</p>
                <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: 'your_email@example.com'
            )
        }
        failure {
            script {
                echo 'Pipeline failed. Sending failure notification...'
            }
            emailext(
                subject: "Pipeline Failure: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                <p>Pipeline <b>${env.JOB_NAME}</b> failed!</p>
                <p>Build Number: ${env.BUILD_NUMBER}</p>
                <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: 'your_email@example.com'
            )
        }
    }
}
