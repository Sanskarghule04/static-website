pipeline {
    agent any

    environment {
        IMAGE_NAME = "nginxsite"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')  // Your DockerHub creds in Jenkins
        AWS_REGION = 'us-east-1'
        ECR_REPO = "662147645403.dkr.ecr.us-east-1.amazonaws.com/nginxsite"
        AWS_CREDENTIALS = credentials('aws-ecr-creds')           // Your AWS creds in Jenkins
    }

    stage('Clone Repository') {
    steps {
        git branch: 'main', url: 'https://github.com/Sanskarghule04/static-website.git'
    }
}


        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    sh '''
                    aws configure set aws_access_key_id ${AWS_CREDENTIALS_USR}
                    aws configure set aws_secret_access_key ${AWS_CREDENTIALS_PSW}
                    aws configure set region ${AWS_REGION}

                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REPO}
                    '''
                }
            }
        }

        stage('Tag and Push to AWS ECR') {
            steps {
                script {
                    sh """
                    docker tag ${IMAGE_NAME}:latest ${ECR_REPO}:latest
                    docker push ${ECR_REPO}:latest
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
