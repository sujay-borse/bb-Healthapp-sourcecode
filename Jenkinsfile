pipeline {
    agent any

    environment {

        AWS_REGION = "us-west-2"

        AWS_ACCOUNT_ID = "874632206513"

        ECR_FRONTEND = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bbhealthapp-frontend"
        ECR_MASTER = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bbhealthapp-master-service"
        ECR_REGISTER = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bbhealthapp-register-service"
        ECR_DOCUMENT = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bbhealthapp-document-service"

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
                bat 'kubectl version --client'

                // Uncomment only if Helm is installed
                // bat 'helm version'
            }
        }

        stage('Login to AWS ECR') {
            steps {

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {

                    bat """
                    aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
                    """
                }

            }
        }

        stage('Build Frontend Image') {

            steps {

                dir('bbhealthapp-frontend') {

                    bat """
                    docker build -t %ECR_FRONTEND%:%IMAGE_TAG% .
                    """

                }

            }

        }

        stage('Build Master Service') {

            steps {

                dir('bbhealthapp-backend\\bbhealthapp-api-master') {

                    bat 'mvn clean package -DskipTests'

                    bat """
                    docker build -t %ECR_MASTER%:%IMAGE_TAG% .
                    """

                }

            }

        }
                stage('Build Register Service') {

            steps {

                dir('bbhealthapp-backend\\bbhealthapp-api-register') {

                    bat 'mvn clean package -DskipTests'

                    bat """
                    docker build -t %ECR_REGISTER%:%IMAGE_TAG% .
                    """

                }

            }

        }

        stage('Build Document Service') {

            steps {

                dir('bbhealthapp-backend\\bbhealthapp-api-document') {

                    bat 'mvn clean package -DskipTests'

                    bat """
                    docker build -t %ECR_DOCUMENT%:%IMAGE_TAG% .
                    """

                }

            }

        }

        stage('Push Images to ECR') {

            steps {

                bat """
                docker push %ECR_FRONTEND%:%IMAGE_TAG%
                docker push %ECR_MASTER%:%IMAGE_TAG%
                docker push %ECR_REGISTER%:%IMAGE_TAG%
                docker push %ECR_DOCUMENT%:%IMAGE_TAG%
                """

            }

        }

        stage('Update Kubeconfig') {

            steps {

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {

                    bat """
                    aws eks update-kubeconfig ^
                    --region %AWS_REGION% ^
                    --name bbhealthapp-dev
                    """

                }

            }

        }
                stage('Deploy to Kubernetes') {

            steps {

                bat """
                kubectl apply -f k8s\\namespace.yaml
                kubectl apply -f k8s\\configmap.yaml
                kubectl apply -f k8s\\secret.yaml

                kubectl apply -f k8s\\master-service-deployment.yaml
                

                kubectl apply -f k8s\\register-service-deployment.yaml
                

                kubectl apply -f k8s\\document-service-deployment.yaml
                

                kubectl apply -f k8s\\frontend-deployment.yaml
                

                kubectl apply -f k8s\\ingress.yaml
                """

            }

        }

        stage('Verify Deployment') {

            steps {

                bat """
                kubectl get nodes
                kubectl get pods -n bbhealthapp
                kubectl get svc -n bbhealthapp
                kubectl get ingress -n bbhealthapp
                """

            }

        }

    }

    post {

        success {

            echo '========================================'
            echo 'BUILD AND DEPLOYMENT SUCCESSFUL'
            echo '========================================'

        }

        failure {

            echo '========================================'
            echo 'BUILD OR DEPLOYMENT FAILED'
            echo '========================================'

        }
                always {

            bat """
            docker image prune -f
            docker system prune -f
            """

            cleanWs()

        }

    }

}