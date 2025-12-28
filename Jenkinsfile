pipeline {
    agent any

    // webhook trigger block yahan hona chahiye
    triggers {
        githubPush()
    }

    environment {
        IMAGE_NAME = 'thedevopsengineer/jenkins53'
        DOCKER_CREDENTIALS_ID = 'dockerhub'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/Naveed-Iqbal-Devops-Engineer/1repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    env.IMAGE_TAG = "${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker build -t ${env.IMAGE_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh "docker push ${env.IMAGE_TAG}"
            }
        }

        stage('Deploy Dev and Staging') {
            steps {
                script {
                    def containers = ['dev': 8001, 'staging': 8002]
                    containers.each { envName, port ->
                        def containerName = "django-notes-${envName}"
                        sh """
                            docker rm -f ${containerName} || true
                            docker run -d --name ${containerName} \\
                            -p ${port}:8000 ${env.IMAGE_TAG}
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Dev on 8001 | Staging on 8002"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}
