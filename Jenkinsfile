pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"

        AWS_ACCOUNT_ID = "874632206513"

        ECR_FRONTEND = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bb-frontend"
        ECR_MASTER = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bb-master-service"
        ECR_REGISTER = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bb-register-service"
        ECR_DOCUMENT = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bb-document-service"

        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                bat 'java -version'
                bat 'mvn -version'
                bat 'docker --version'
                bat 'aws --version'
                bat 'helm version'
                bat 'kubectl version --client'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {

                    bat """
                    aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
                    """
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                dir('frontend') {
                    bat """
                    docker build -t %ECR_FRONTEND%:%IMAGE_TAG% .
                    """
                }
            }
        }

        stage('Build Master Service') {
            steps {
                dir('master-service') {
                    bat """
                    docker build -t %ECR_MASTER%:%IMAGE_TAG% .
                    """
                }
            }
        }

        stage('Build Register Service') {
            steps {
                dir('register-service') {
                    bat """
                    docker build -t %ECR_REGISTER%:%IMAGE_TAG% .
                    """
                }
            }
        }

        stage('Build Document Service') {
            steps {
                dir('document-service') {
                    bat """
                    docker build -t %ECR_DOCUMENT%:%IMAGE_TAG% .
                    """
                }
            }
        }

        stage('Push Images') {
            steps {

                bat "docker push %ECR_FRONTEND%:%IMAGE_TAG%"
                bat "docker push %ECR_MASTER%:%IMAGE_TAG%"
                bat "docker push %ECR_REGISTER%:%IMAGE_TAG%"
                bat "docker push %ECR_DOCUMENT%:%IMAGE_TAG%"

            }
        }

        stage('Deploy to EKS') {
            steps {

                bat """
                helm upgrade --install bb-healthapp helm-chart ^
                --set frontend.image.repository=%ECR_FRONTEND% ^
                --set frontend.image.tag=%IMAGE_TAG% ^
                --set master.image.repository=%ECR_MASTER% ^
                --set master.image.tag=%IMAGE_TAG% ^
                --set register.image.repository=%ECR_REGISTER% ^
                --set register.image.tag=%IMAGE_TAG% ^
                --set document.image.repository=%ECR_DOCUMENT% ^
                --set document.image.tag=%IMAGE_TAG%
                """
            }
        }
    }

    post {

        success {
            echo "====================================="
            echo "Pipeline Executed Successfully"
            echo "Docker Images Pushed"
            echo "Application Deployed to EKS"
            echo "====================================="
        }

        failure {
            echo "Pipeline Failed"
        }

        always {
            cleanWs()
        }
    }
}